import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/views/Visitor/Sections/achievement_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/introduction_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/stat_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/team_section.dart';
import 'package:piminnovictus/views/background.dart'; // Ensure this is defined
import 'package:provider/provider.dart';

class CopyrightSection extends StatelessWidget {
  const CopyrightSection({super.key});

  @override
  Widget build(BuildContext context) {
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
                color: Colors.white70,
                size: screenWidth * 0.04,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '${DateTime.now().year} GreenEnergyChain. All rights reserved.',
                style: TextStyle(
                  color: Colors.white70,
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

class _VisitorPageState extends State<VisitorPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _packsKey = GlobalKey();
  bool _isVisible = true;

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

  void _onScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // Attach scroll listener
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove scroll listener
    _scrollController.dispose();
    super.dispose();
  }

 @override
Widget build(BuildContext context) {
  return SafeArea(
    child: Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final logoSize = screenWidth * 0.05;
          final titleFontSize = screenWidth * 0.055;

          return BlurredRadialBackground(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Column(
                      children: [
                        // Add space before the logo and title
                        SizedBox(height: screenWidth * 0.05), // Adjust the height as needed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Logo and Title
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(screenWidth * 0.02),
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
                                    backgroundImage:
                                        const AssetImage('assets/logo.png'),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'GreenEnergy',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            // Language Dropdown
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
            ),
          );
        },
      ),
    floatingActionButton: LayoutBuilder(
  builder: (context, constraints) {
    final screenWidth = constraints.maxWidth;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: _isVisible ? 1.0 : 0.0,
      child: SizedBox(
        width: screenWidth * 0.5, 
        height: screenWidth * 0.12,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginView()),
            );
          },
          backgroundColor: const Color(0xFF29E33C),
          label: const Text(
            'Skip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  },
),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ),
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
}}