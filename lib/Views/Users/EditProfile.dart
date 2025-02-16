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
import 'dart:ui'; // Pour le BackdropFilter
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isPreferencesExpanded = false;
  bool isPersonalInfoExpanded = false;
  bool isPasswordExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              // Fond adapté au mode clair ou sombre
              Positioned.fill(
                child:
                    isDarkMode ? _darkModeBackground() : _lightModeBackground(),
              ),
              // Contenu principal avec flou d'arrière-plan
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      // Image du profil et informations
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
                                color: Theme.of(context).iconTheme.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF29E33C),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(Icons.check,
                                  color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Khaled Guedria',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'khaled.guedria@esprit.tn',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 30),
                      // Item Dark Mode
                      _buildMenuItem(
                        context,
                        icon: Icons.dark_mode,
                        title: 'Dark Mode',
                        switchWidget: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme(value);
                          },
                          activeColor: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Carte Preferences intégrée
                      _buildPreferencesCard(context),
                      const SizedBox(height: 10),
                      // Item Logout
                      _buildMenuItem(
                        context,
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () {
                          // Logique de déconnexion ici
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fond pour le mode clair
  Widget _lightModeBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF93DAB2).withOpacity(0.8),
            Colors.white.withOpacity(0.5),
          ],
        ),
      ),
    );
  }

  // Fond pour le mode sombre
  Widget _darkModeBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.5,
          colors: [
            const Color(0xFF0A140C),
            const Color(0xFF0D0F0D).withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  // Widget générique pour un menu item standard
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? switchWidget,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF29E33C),
            width: 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).iconTheme.color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
            switchWidget ?? const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Carte Preferences intégrée contenant les deux sous-cartes
  Widget _buildPreferencesCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPreferencesExpanded = !isPreferencesExpanded;
          // Réinitialiser l'expansion des sous-cartes lors de la fermeture
          if (!isPreferencesExpanded) {
            isPersonalInfoExpanded = false;
            isPasswordExpanded = false;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFF29E33C),
            width: 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête de la carte Preferences
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.settings,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
                      'Preferences',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isPreferencesExpanded
                      ? Icons.expand_more
                      : Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            if (isPreferencesExpanded) ...[
              const SizedBox(height: 16),
              // Sous-carte : Personal Informations
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPersonalInfoExpanded = !isPersonalInfoExpanded;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête de la sous-carte Personal Informations
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Personal Informations',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          Icon(
                            isPersonalInfoExpanded
                                ? Icons.expand_more
                                : Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      if (isPersonalInfoExpanded) ...[
                        const SizedBox(height: 15),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Phone",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Sous-carte : Password
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordExpanded = !isPasswordExpanded;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF29E33C),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // En-tête de la sous-carte Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                          Icon(
                            isPasswordExpanded
                                ? Icons.expand_more
                                : Icons.chevron_right,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      if (isPasswordExpanded) ...[
                        const SizedBox(height: 15),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Current Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "New Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Bouton Save global pour la carte Preferences
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Logique de sauvegarde
                    print("Preferences saved");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29E33C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
