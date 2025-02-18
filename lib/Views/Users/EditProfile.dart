import 'dart:ui'; // Pour le BackdropFilter
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Views/AuthViews/privacy_policy.dart';
import 'package:piminnovictus/Views/AuthViews/terms_and_conditions.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isPreferencesExpanded = false;
  bool isProfileInformationsExpanded = false;
  bool isPersonalInfoExpanded = false;
  bool isPasswordExpanded = false;
  bool isDarkModeExpanded = false;
  bool isLanguageExpanded = false;
  String selectedLanguage = 'en';
  bool isTermsExpanded = false;

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
                      
                      _buildPreferencesCard(context),
                      const SizedBox(height: 10),
                      // Carte Preferences intégrée
                      _buildProfileInformationsCard(context),
                                            const SizedBox(height: 10),

                      _buildTermssCard(context),
                      // Item Logout
                     
                      const SizedBox(height: 10),
                      // Item Logout
                      _buildMenuItem(
                        context,
                        icon: Icons.logout,
  title: AppLocalizations.of(context).translate('logout'),
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

  Widget _buildProfileInformationsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isProfileInformationsExpanded = !isProfileInformationsExpanded;
          // Réinitialiser l'expansion des sous-cartes lors de la fermeture
          if (!isProfileInformationsExpanded) {
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
                    Icon(Icons.person,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
  AppLocalizations.of(context).translate('profileInformation'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isProfileInformationsExpanded
                      ? Icons.expand_more
                      : Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
            if (isProfileInformationsExpanded) ...[
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
AppLocalizations.of(context).translate('personalInformation'),                            style: TextStyle(
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
                            hintText: AppLocalizations.of(context).translate('username'),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).translate('email'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
  decoration: InputDecoration(
    hintText: AppLocalizations.of(context).translate('phone'),
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
                              AppLocalizations.of(context).translate('password'),

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
                            hintText:AppLocalizations.of(context).translate('currentPassword'),
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
                            hintText:AppLocalizations.of(context).translate('newPassword'),
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
                            hintText: AppLocalizations.of(context).translate('confirmPassword'),
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
                  child:  Text(
  AppLocalizations.of(context).translate('save'),
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
Widget _buildPreferencesCard(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return GestureDetector(
    onTap: () {
      setState(() {
        isPreferencesExpanded = !isPreferencesExpanded;
        if (!isPreferencesExpanded) {
          isDarkModeExpanded = false;
          isLanguageExpanded = false;
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
            // Preferences card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.settings,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
AppLocalizations.of(context).translate('preferences'),                      style: TextStyle(
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
              // Dark Mode card
 Container(
  margin: const EdgeInsets.symmetric(vertical: 2.5),
padding: const EdgeInsets.symmetric(horizontal: 12),
  decoration: BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: const Color(0xFF29E33C),
      width: 1,
    ),
  ),
  child: Column( // Changed from Row to Column to match language card structure
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.dark_mode,
                  color: Theme.of(context).iconTheme.color),
              const SizedBox(width: 10),
              Text(
  AppLocalizations.of(context).translate('darkMode'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
activeColor: Theme.of(context).iconTheme.color,                
              );
            },
          ),
        ],
      ),
    ],
  ),
),
SizedBox(height: 16),
// Language Selection card
           GestureDetector(
              onTap: () {
                setState(() {
                  isLanguageExpanded = !isLanguageExpanded;
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language,
                                color: Theme.of(context).iconTheme.color),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(context).translate('language'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          isLanguageExpanded
                              ? Icons.expand_more
                              : Icons.chevron_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    if (isLanguageExpanded) ...[
                      const SizedBox(height: 15),
                      // English Option
                      ListTile(
                        title: Text(  AppLocalizations.of(context).translate('english'),

                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        onTap: () {
                          languageProvider.setLocale(const Locale('en')); // Set to English
                        },
                        trailing: languageProvider.locale.languageCode == 'en'
                            ? Icon(Icons.check, color: Theme.of(context).iconTheme.color)
                            : null,
                      ),
                      // French Option
                      ListTile(
                        title: Text(AppLocalizations.of(context).translate('french'),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        onTap: () {
                          languageProvider.setLocale(const Locale('fr')); // Set to French
                        },
                        trailing: languageProvider.locale.languageCode == 'fr'
                            ? Icon(Icons.check, color: Theme.of(context).iconTheme.color)
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
              // Save button
              
            ],
          ],
        ),
      ),
    );
}
Widget _buildTermssCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTermsExpanded = !isTermsExpanded;
          // Reset sub-cards expansion when closing
          if (!isTermsExpanded) {
            isDarkModeExpanded = false;
            isLanguageExpanded = false;
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
            // Preferences card header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.shield_outlined,
                        color: Theme.of(context).iconTheme.color),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context).translate('termsAndPrivacy'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                Icon(
                  isTermsExpanded
                      ? Icons.expand_more
                      : Icons.chevron_right,
                  color: Colors.grey,
                ),
              ],
            ),
          if (isTermsExpanded) ...[
  const SizedBox(height: 16),
  // Terms & Conditions card
 // Terms & Conditions card
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsAndConditionsScreen(),
      ),
    );
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.description_outlined,
                color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 10),
            Text(
AppLocalizations.of(context).translate('termsAndConditions'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ],
    ),
  ),
),
  
  // Privacy Policy card
  GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrivacyPolicyScreen(),
      ),
    );
  },
  child:Container(
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
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.privacy_tip_outlined,
                color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 10),
            Text(
AppLocalizations.of(context).translate('privacyPolicy'),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),
        Icon(
          Icons.chevron_right,
          color: Colors.grey,
        ),
      ],
    ),
  ),),

],],
        ),
      ),
    );
}}