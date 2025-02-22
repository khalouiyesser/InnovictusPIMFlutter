import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/profile.dart';
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:provider/provider.dart';

class AllProfilesView extends StatelessWidget {
  const AllProfilesView({Key? key}) : super(key: key);

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
              ...viewModel.recentUsers.map((user) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photoURL!= null
                      ? NetworkImage(user.photoURL!)
                      : const AssetImage('assets/user.jpg') as ImageProvider,
                  backgroundColor: Colors.grey.shade200,
                ),
                title: Text(user.displayName.toString()),
              
                onTap: () => viewModel.selectUser(user.uid),
              )),
              if (viewModel.recentUsers.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Aucun utilisateur récent',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
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