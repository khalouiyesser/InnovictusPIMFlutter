/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A140C),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 70),

            // Image du profil
            Stack(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/user.jpg'),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child:
                        const Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Nom et email
            const Text(
              'Khaled Guedria',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'khaled.guedria@esprit.tn',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),

            // Dark Mode Switch
            _buildMenuItem(
              icon: Icons.dark_mode,
              title: 'Light Mode',
              switchWidget: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(height: 10),

            // Preferences
            _buildMenuItem(
              icon: Icons.settings,
              title: 'Preferences',
              onTap: () {},
            ),
            const SizedBox(height: 10),

            // Logout
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              color: const Color.fromARGB(255, 255, 255, 255),
              onTap: () {
                // Ajouter la logique de déconnexion ici
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color color = Colors.white,
    VoidCallback? onTap,
    Widget? switchWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A), // Fond des boutons
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: color),
                ),
              ],
            ),
            switchWidget ?? const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 70),

                // Image du profil
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/user.jpg'),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Nom et email
                const Text(
                  'Khaled Guedria',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'khaled.guedria@esprit.tn',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),

                // Dark Mode Switch
                _buildMenuItem(
                  icon: Icons.dark_mode,
                  title: 'Light Mode',
                  switchWidget: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    activeColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),

                // Preferences
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Preferences',
                  onTap: () {},
                ),
                const SizedBox(height: 10),

                // Logout
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  color: const Color.fromARGB(255, 255, 255, 255),
                  onTap: () {
                    // Ajouter la logique de déconnexion ici
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    Color color = Colors.white,
    VoidCallback? onTap,
    Widget? switchWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A), // Fond des boutons
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 16, color: color),
                ),
              ],
            ),
            switchWidget ?? const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

