import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/Services/session_manager.dart';
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
      // Get current user ID
      _currentUserId = await _sessionManager.getUserId();
      
      // Get recent users and filter out the current user
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
      // Handle error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileSwitcherViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(),
            title: const Text('Sélectionner un profil'),
          ),
          body: ListView(
            children: [
              ...viewModel.profilesSortedByCreationDate.map((profile) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: profile.imageUrl != null
                      ? NetworkImage(profile.imageUrl!)
                      : const AssetImage('assets/user.jpg') as ImageProvider,
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
                onTap: () => viewModel.switchProfile(profile.id),
              )),
              ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.add),
                ),
                title: const Text('Créer un nouveau profil '),
                onTap: () {
                  // Handle create profile
                },
              ),
              const Divider(),
              
              // Recent connected accounts section
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                child: Text(
                  'Utilisateurs récents',
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Aucun utilisateur récent',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ..._recentUsers.map((user) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: user['photoURL'] != null
                            ? NetworkImage(user['photoURL'])
                            : const AssetImage('assets/user.jpg') as ImageProvider,
                        backgroundColor: Colors.grey.shade200,
                      ),
                      title: Text(user['name'] ?? 'Unknown User'),
                      subtitle: Text(user['email'] ?? 'Unknown email'),
                      onTap: () async {
                        // Handle recent user selection
                        if (user['userId'] != null) {
                          await viewModel.selectUser(user['userId']);
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