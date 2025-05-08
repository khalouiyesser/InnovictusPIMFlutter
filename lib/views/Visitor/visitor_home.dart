import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/Views/Visitor/Sections/achievement_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/introduction_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/team_section.dart';
import 'package:piminnovictus/views/Visitor/AssistantView.dart';
import 'package:piminnovictus/views/background.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';

import 'package:provider/provider.dart';

class CopyrightSection extends StatelessWidget {
  const CopyrightSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthScreenTheme _theme = AuthScreenThemeDetector.getTheme();

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        return Padding(
          padding: EdgeInsets.only(bottom: screenWidth * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.copyright,
                color: _theme.textColor,
                size: screenWidth * 0.04,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                AppLocalizations.of(context)
                    .translate("footerText")
                    .replaceAll("{date}", 'DateTime.now().year.toString()'),
                style: TextStyle(
                  color: _theme.textColor,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class VisitorPage extends StatefulWidget {
  const VisitorPage({super.key});

  @override
  State<VisitorPage> createState() => _VisitorPageState();
}

class _VisitorPageState extends State<VisitorPage> with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _packsKey = GlobalKey();
  late AuthScreenTheme _theme;

  void scrollToPacksSection() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_packsKey.currentContext != null) {
        final RenderBox renderBox =
            _packsKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero).dy;

        final padding = MediaQuery.of(context).padding.top;
        final offset = position - padding;

        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTheme();
    // Register to listen for system brightness changes - fixed by removing the cast
    WidgetsBinding.instance.addObserver(this);
  }

  void _updateTheme() {
    _theme = AuthScreenThemeDetector.getTheme();
  }

  @override
  void dispose() {
    // Remove observer before disposal
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Update the theme when system brightness changes
    if (mounted) {
      setState(() {
        _updateTheme();
      });
    }
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return PopupMenuButton<String>(
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                languageProvider.locale.languageCode == 'en' ? 'En' : 'Fr',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down, color: Colors.white),
            ],
          ),
          onSelected: (String value) {
            languageProvider.setLocale(Locale(value));
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'en',
              child: Text('English'),
            ),
            const PopupMenuItem(
              value: 'fr',
              child: Text('French'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();
    final authTheme = AuthScreenThemeDetector.getTheme();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BlurredRadialBackground(
              isDarkMode: isDarkMode, // Use the detected system theme
              backgroundGradientColors: authTheme
                  .backgroundGradientColors, // Use theme gradient colors
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final logoSize = screenWidth * 0.05;
                  final titleFontSize = screenWidth * 0.055;

                  return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05),
                          child: Column(
                            children: [
                              SizedBox(height: screenWidth * 0.07),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.all(screenWidth * 0.02),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF29E33C),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: logoSize,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: const AssetImage(
                                              'assets/logo.png'),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.02),
                                      Text(
                                        'GreenEnergy',
                                        style: TextStyle(
                                          color: _theme.textColor,
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  _buildLanguageDropdown(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: IntroductionSection(
                          onPacksButtonPressed: scrollToPacksSection,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: PacksSection(key: _packsKey),
                      ),
                      const SliverToBoxAdapter(
                        child: AchievementSection(),
                      ),
                      const SliverToBoxAdapter(
                        child: TeamSection(),
                      ),
                      const SliverToBoxAdapter(
                        child: CopyrightSection(),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Logo Assistant
            Positioned(
              right: 20,
              bottom: 100, // Position au-dessus du bouton de login
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent, // Cercle transparent
                        border: Border.all(
                          color: const Color(0xFF29E33C), // Bordure verte
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssistantView(),
                              ),
                            );
                          },
                          child: Center(
                            child: Image.asset(
                              'assets/assistant_icon.png', // Chemin vers votre image d'assistant
                              width: 35,
                              height: 35,
                              color: const Color(
                                  0xFF29E33C), // Couleur verte pour l'image
                              // Utilisez une icône par défaut si l'image n'est pas disponible
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons
                                      .support_agent, // Icône d'assistant par défaut
                                  color: Color(0xFF29E33C),
                                  size: 30,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Bouton Login existant
            Positioned(
              right: 20,
              bottom: 20,
              child: TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 3),
                builder: (context, double value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.14159,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF29E33C).withOpacity(0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginView()),
                            );
                          },
                          child: const Center(
                            child: Icon(
                              Icons.login,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
