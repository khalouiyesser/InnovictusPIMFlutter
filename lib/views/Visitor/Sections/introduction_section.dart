import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/Views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/Views/Visitor/packs_list.dart';
import 'package:provider/provider.dart';

class IntroductionSection extends StatelessWidget {
  final VoidCallback onPacksButtonPressed;

  const IntroductionSection({
    super.key,
    required this.onPacksButtonPressed,
  });

  void _handleLoginTap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final basePadding = screenWidth * 0.05;
        final logoSize = screenWidth * 0.05;
        final titleFontSize = screenWidth * 0.055;
        final buttonHeight = screenWidth * 0.12;
        final contentFontSize = screenWidth * 0.038;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                SizedBox(height: screenWidth * 0.04),

                Center(
                  child: InkWell(
                    onTap: onPacksButtonPressed,
                    child: Container(
                      width: screenWidth * 0.7,
                      height: buttonHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(buttonHeight / 2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
  AppLocalizations.of(context).translate("view_all_packs_offers"),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenWidth * 0.06),

                // Main Title
                Center(
                  child: Text(
  AppLocalizations.of(context).translate("energy_revolution_title"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.06),
                // Main Content Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rich Text Content
                      Text.rich(
                        TextSpan(
                          children: _buildResponsiveTextSpans(context ,contentFontSize),
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.04),

                      // Image
                      Container(
                        height: screenWidth * 0.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          image: const DecorationImage(
                            image: AssetImage('assets/background.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.04),

                      // Feature List
                      _buildFeatureList(context,screenWidth),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
Widget _buildLanguageDropdown(BuildContext context) {
  return Consumer<LanguageProvider>(
    builder: (context, languageProvider, child) {
      return PopupMenuButton<String>(
        icon: Row(
          children: [
            Text(
              languageProvider.locale.languageCode == 'en' ? 'En' : 'Fr',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
        onSelected: (String value) {
          // Update the language when a new option is selected
          languageProvider.setLocale(Locale(value));
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'en',
            child: Text('English'),
          ),
          PopupMenuItem(
            value: 'fr',
            child: Text('French'),
          ),
        ],
      );
    },
  );
}
  List<TextSpan> _buildResponsiveTextSpans(BuildContext context, double fontSize) {
    return [
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_intro_1"),
        style: TextStyle(color: Colors.white, fontSize: fontSize, height: 1.1),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_intro_2") + "\n",
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_what_if_1"),
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_what_if_2"),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_what_if_3"),
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_what_if_4"),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_what_if_5"),
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("energy_what_if_6") + "\n",
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("green_energy_tagline"),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: '\n',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("tech_description_1"),
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("tech_description_2"),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("tech_description_3"),
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("tech_description_4"),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        
      text: AppLocalizations.of(context).translate("tech_description_5"),
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
      text: AppLocalizations.of(context).translate("tech_description_6"),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  Widget _buildFeatureList(BuildContext context, double screenWidth) {
    final iconSize = screenWidth * 0.055; // Taille des icônes responsive
    final fontSize = screenWidth * 0.04; // Taille du texte responsive
    final spacing = screenWidth * 0.02; // Espacement responsive

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feature 1: Energy independence
        _buildFeatureRow(
          Icons.power_off,
        AppLocalizations.of(context).translate("feature_steg"),
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 2: Selling energy
        _buildFeatureRow(
          Icons.attach_money,
        AppLocalizations.of(context).translate("feature_selling"),
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 3: AI + IoT
        _buildFeatureRow(
          Icons.memory,
        AppLocalizations.of(context).translate("feature_ai_iot"),
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 4: Blockchain security
        _buildFeatureRow(
          Icons.lock,
        AppLocalizations.of(context).translate("feature_blockchain"),
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 5: Green impact
        _buildFeatureRow(
          Icons.eco,
        AppLocalizations.of(context).translate("feature_green_impact"),
          iconSize,
          fontSize,
        ),
      ],
    );
  }

  Widget _buildFeatureRow(
    IconData icon,
    String text,
    double iconSize,
    double fontSize,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: iconSize),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
