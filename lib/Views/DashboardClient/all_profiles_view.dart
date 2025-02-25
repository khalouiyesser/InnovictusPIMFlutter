import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/Views/Users/create_profile.dart';
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:provider/provider.dart';

class AllProfilesView extends StatefulWidget {
  const AllProfilesView({Key? key}) : super(key: key);

  @override
  State<AllProfilesView> createState() => _AllProfilesViewState();
}

class _AllProfilesViewState extends State<AllProfilesView> {
  final SessionManager _sessionManager = SessionManager();
  List<Map<String, dynamic>> _recentUsers = [];
  bool _isLoadingRecentUsers = true;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndRecentUsers();
  }

  Future<void> _loadCurrentUserAndRecentUsers() async {
    try {
      _currentUserId = await _sessionManager.getUserId();
      final users = await _sessionManager.getRecentUsers();
      final filteredUsers = users.where((user) => 
        user['userId'] != _currentUserId
      ).toList();
      
      setState(() {
        _recentUsers = filteredUsers;
        _isLoadingRecentUsers = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingRecentUsers = false;
      });
    }
  }
Future<void> _showSwitchProfileDialog(BuildContext context, String profileName, String profileId, ProfileSwitcherViewModel viewModel) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final dialogWidth = constraints.maxWidth * 0.8;
            final dialogHeight = constraints.maxHeight * 0.25;
            
            return Container(
              width: dialogWidth,
              height: dialogHeight,
              padding: EdgeInsets.all(dialogWidth * 0.04),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 1, 10, 2).withOpacity(0.9),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Changer de profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dialogWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: dialogHeight * 0.05),
                  Text(
                    'Voulez-vous vraiment passer au profil "$profileName" ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: dialogWidth * 0.04,
                    ),
                  ),
                  SizedBox(height: dialogHeight * 0.1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // No Button
                      SizedBox(
                        width: dialogWidth * 0.35,
                        height: dialogHeight * 0.15,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFF29E33C),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Non',
                            style: TextStyle(
                              color: const Color(0xFF29E33C),
                              fontSize: dialogWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: dialogWidth * 0.04),
                      // Yes Button
                      SizedBox(
                        width: dialogWidth * 0.35,
                        height: dialogHeight * 0.15,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF29E33C),
                                Color.fromARGB(255, 9, 128, 25)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await viewModel.switchProfile(profileId);
                              if (context.mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => BottomNavBarExample(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              'Oui',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: dialogWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
     final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Consumer<ProfileSwitcherViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
  title: Text(AppLocalizations.of(context).translate('selectProfile')),
          ),
          body: ListView(
            children: [
              ...viewModel.profilesSortedByCreationDate.map((profile) => ListTile(
                leading: CircleAvatar(             backgroundImage: AssetImage('assets/user.jpg'),

                ),
                title: Text(profile.name),
                subtitle: Text(
                  profile.getTimeAgo(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                trailing: profile.isSelected
                    ? const Icon(Icons.check_circle, color: Colors.blue)
                    : null,
                onTap: () => _showSwitchProfileDialog(
                  context,
                  profile.name,
                  profile.id,
                  viewModel,
                ),
              )),
              ListTile(
  leading: const CircleAvatar(
    child: Icon(Icons.add),
  ),
    title: Text(AppLocalizations.of(context).translate('createNewProfile')),

  onTap: () async {
    // Get the packs list from your PacksList widget
    final List<Pack> packs = [
      Pack(
        id: "1",
        title: "Basic Pack",
        image: "assets/panel.png",
        description: "• Unlock energy potential\n• Maximize savings\n• Smart monitoring",
        price: 999,
        panelsCount: "6",
        energyGain: "5 kWh/jour",
        co2Saved: "10 kg CO₂/jour",
        certification: "Empreinte carbone réduite"
      ),
      // Add other packs here...
    ];
    
    final result = await showDialog(
      context: context,
      builder: (context) => CreateProfileDialog(packs: packs),
    );
    
    if (result != null) {
      // Handle the created profile with selected pack
      // You can access:
      // result['name'] - profile name
      // result['imagePath'] - selected image path
      // result['selectedPack'] - selected pack object
    }
  },
),
              const Divider(),
              
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                child: Text(
                    AppLocalizations.of(context).translate('recentUsers'),

                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              
              if (_isLoadingRecentUsers)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_recentUsers.isEmpty)
                 Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    AppLocalizations.of(context).translate('noRecentUsers'),

                    style:const  TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ..._recentUsers.map((user) => ListTile(
                  leading: CircleAvatar(
                                 backgroundImage: AssetImage('assets/user.jpg'),

                    backgroundColor: Colors.grey.shade200,
                  ),
                  title: Text(user['name'] ?? 'Unknown User'),
                  subtitle: Text(user['email'] ?? 'Unknown email'),
                  onTap: () async {
                    if (user['userId'] != null) {
                      _showSwitchProfileDialog(
                        context,
                        user['name'] ?? 'Unknown User',
                        user['userId'],
                        viewModel,
                      );
                    }
                  },
                )),
            ],
          ),
        );
      },
    );
  }
  
  String _formatLastSeen(DateTime? lastSeen) {
    if (lastSeen == null) return 'Inconnue';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen);
    
    if (difference.inDays > 0) {
      return 'Il y a ${difference.inDays} jour${difference.inDays > 1 ? 's' : ''}';
    } else if (difference.inHours > 0) {
      return 'Il y a ${difference.inHours} heure${difference.inHours > 1 ? 's' : ''}';
    } else {
      return 'Il y a ${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
    }
  }
}