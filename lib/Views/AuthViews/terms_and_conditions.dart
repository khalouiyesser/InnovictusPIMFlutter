import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                "assets/Pulse.png",
                fit: BoxFit.cover,
              ),
            ),
            // Overlay
            Scaffold(
              extendBodyBehindAppBar:
                  true, // This allows the body to extend behind the AppBar
              appBar: AppBar(
                title:
                    Text(AppLocalizations.of(context).translate('termsTitle')),
                backgroundColor: Colors.transparent, // Make AppBar transparent
                elevation: 0, // Remove AppBar shadow
                flexibleSpace: Container(
                  // Add background to AppBar
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: Container(
                color: Colors.transparent,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('termsAndConditions'),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(
                                  color: Color.fromARGB(90, 255, 255, 255),
                                  thickness: 2,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('termsContent'),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 31, 219, 59),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('understand'),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
