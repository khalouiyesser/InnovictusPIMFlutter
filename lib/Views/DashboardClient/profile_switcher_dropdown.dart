import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/Models/User.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/DashboardClient/all_profiles_view.dart';
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
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
  _ProfileSwitcherDropdownState createState() =>
      _ProfileSwitcherDropdownState();
}

class _ProfileSwitcherDropdownState extends State<ProfileSwitcherDropdown> {
  final GlobalKey _avatarKey = GlobalKey();
  OverlayEntry? _arrowOverlay;
  final SessionManager _sessionManager = SessionManager();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _sessionManager.getCurrentUser();
    if (mounted) {
      setState(() {
        currentUser = user;
      });
    }
  }

  void _showArrow() {
    _hideArrow();
    final RenderBox renderBox =
        _avatarKey.currentContext!.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _arrowOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy + size.height - 2,
        left: position.dx + (size.width / 2) - 10,
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) => Material(
            color: Colors.transparent,
            elevation: 0,
            child: Icon(
              Icons.arrow_drop_down,
              color: MyThemes.primaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );

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
    return Consumer2<ThemeProvider, ProfileSwitcherViewModel>(
      builder: (context, themeProvider, viewModel, _) {
        if (viewModel.currentProfile == null) return Container();

        final recentProfiles = viewModel.getRecentProfiles(2);
        final isDark = themeProvider.isDarkMode;

        return PopupMenuButton<String>(
          key: _avatarKey,
          offset: const Offset(0, 54),
          color: isDark ? MyThemes.secondaryColor : MyThemes.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isDark
                  ? MyThemes.whiteColor.withOpacity(0.1)
                  : MyThemes.blackColor.withOpacity(0.1),
            ),
          ),
          onOpened: _showArrow,
          onCanceled: _hideArrow,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.borderColor,
                width: widget.borderWidth,
              ),
            ),
            child: CircleAvatar(
              radius: widget.customRadius,
              backgroundImage: viewModel.currentProfile?.imageUrl != null
                  ? NetworkImage(viewModel.currentProfile!.imageUrl!)
                  : const AssetImage('assets/user.jpg') as ImageProvider,
            ),
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              child:
                  _buildCurrentProfileItem(viewModel.currentProfile!, isDark),
            ),
            PopupMenuItem<String>(
              height: 1,
              padding: EdgeInsets.zero,
              enabled: false,
              child: Divider(
                height: 1,
                color: isDark
                    ? MyThemes.whiteColor.withOpacity(0.1)
                    : MyThemes.blackColor.withOpacity(0.1),
              ),
            ),
            ...recentProfiles.map((profile) => PopupMenuItem<String>(
                  value: profile.id,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildProfileItem(profile, isDark),
                )),
            PopupMenuItem<String>(
              padding: EdgeInsets.zero,
              child: _buildViewAllProfilesButton(context, isDark),
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

  Widget _buildCurrentProfileItem(ProfileModel profile, bool isDark) {
    return Padding(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      profile.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color:
                            isDark ? MyThemes.whiteColor : MyThemes.blackText,
                      ),
                    ),
                    const Icon(
                      Icons.check_circle,
                      color: MyThemes.primaryColor,
                      size: 20,
                    ),
                  ],
                ),
                Text(
                  currentUser?.email ?? 'No email',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: isDark
                        ? MyThemes.whiteColor.withOpacity(0.7)
                        : MyThemes.blackText.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(ProfileModel profile, bool isDark) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: profile.imageUrl != null
                  ? NetworkImage(profile.imageUrl!)
                  : const AssetImage('assets/user.jpg') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? MyThemes.whiteColor : MyThemes.blackText,
                    ),
                  ),
                  Text(
                    profile.getTimeAgo(),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? MyThemes.whiteColor.withOpacity(0.5)
                          : MyThemes.blackText.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewAllProfilesButton(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          height: 1,
          color: isDark
              ? MyThemes.whiteColor.withOpacity(0.1)
              : MyThemes.blackColor.withOpacity(0.1),
        ),
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
            child: Text(
              'Voir tous les profils',
              style: TextStyle(
                fontSize: 16,
                color: MyThemes.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
