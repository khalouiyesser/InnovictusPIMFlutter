import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/Views/DashboardClient/all_profiles_view.dart';
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:provider/provider.dart';

class ProfileSwitcherDropdown extends StatefulWidget {
  final double customRadius;
  final Color borderColor;
  final double borderWidth;

  const ProfileSwitcherDropdown({
    Key? key,
    required this.customRadius,
    required this.borderColor,
    required this.borderWidth,
  }) : super(key: key);

  @override
  _ProfileSwitcherDropdownState createState() => _ProfileSwitcherDropdownState();
}

class _ProfileSwitcherDropdownState extends State<ProfileSwitcherDropdown> {
  final GlobalKey _avatarKey = GlobalKey();
  OverlayEntry? _arrowOverlay;

  void _showArrow() {
    // Remove any existing overlay
    _hideArrow();
    
    // Get the position of the avatar
    final RenderBox renderBox = _avatarKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    
    // Create the overlay entry with the arrow
    _arrowOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + size.height - 2, // Reduced space between avatar and arrow
        left: position.dx + (size.width / 2) - 10, // Center horizontally
        child: Material(
          color: Colors.transparent,
          elevation: 0,
          child: Icon(
            Icons.arrow_drop_down,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
      ),
    );
    
    // Add the overlay to the screen
    Overlay.of(context).insert(_arrowOverlay!);
  }

  void _hideArrow() {
    _arrowOverlay?.remove();
    _arrowOverlay = null;
  }

  @override
  void dispose() {
    _hideArrow();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSwitcherViewModel>(
      builder: (context, viewModel, child) {
        return PopupMenuButton<String>(
          key: _avatarKey,
          offset: const Offset(0, 54), // Reduced to have dropdown closer to arrow
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          onOpened: _showArrow,
          onCanceled: _hideArrow,
          child: CircleAvatar(
            radius: widget.customRadius,
            backgroundImage: viewModel.currentProfile?.imageUrl != null
                ? NetworkImage(viewModel.currentProfile!.imageUrl!)
                : const AssetImage('assets/user.jpg') as ImageProvider,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              child: _buildCurrentProfileItem(viewModel.currentProfile!),
            ),
            ...viewModel.profiles.map((profile) => PopupMenuItem<String>(
              value: profile.id,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: _buildProfileItem(profile),
            )),
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              child: _buildViewAllProfilesButton(context),
            ),
          ],
          onSelected: (String profileId) {
            viewModel.switchProfile(profileId);
            _hideArrow();
          },
        );
      },
    );
  }
 
  Widget _buildCurrentProfileItem(ProfileModel profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: profile.imageUrl != null
                    ? NetworkImage(profile.imageUrl!)
                    : const AssetImage('assets/user.jpg') as ImageProvider,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  profile.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              if (profile.isSelected)
                const Icon(Icons.check_circle, color: Color(0xFF29E33C), size: 20),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildProfileItem(ProfileModel profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: profile.imageUrl != null
              ? NetworkImage(profile.imageUrl!)
              : const AssetImage('assets/user.jpg') as ImageProvider,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            profile.name,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        if (profile.isSelected)
          const Icon(Icons.check_circle, color: Color(0xFF29E33C), size: 20),
      ],
    );
  }

  Widget _buildViewAllProfilesButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        InkWell(
          onTap: () {
            Navigator.pop(context);
            _hideArrow();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllProfilesView()),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Voir tous les profils',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}