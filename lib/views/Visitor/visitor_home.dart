import 'package:flutter/material.dart';
import 'package:piminnovictus/views/Visitor/Sections/achievement_section.dart';
import 'package:piminnovictus/views/Visitor/Sections/introduction_section.dart';
import 'package:piminnovictus/views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/views/Visitor/Sections/stat_section.dart';
import 'package:piminnovictus/views/Visitor/Sections/team_section.dart';
import 'package:piminnovictus/views/background.dart';

// Create a new widget for the copyright section
class CopyrightSection extends StatelessWidget {
  const CopyrightSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
         
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.copyright,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${DateTime.now().year} GreenEnergyChain. All rights reserved.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Updated VisitorPage with copyright section
class VisitorPage extends StatefulWidget {
  const VisitorPage({super.key});

  @override
  State<VisitorPage> createState() => _VisitorPageState();
}

class _VisitorPageState extends State<VisitorPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _packsKey = GlobalKey();

  // Method to scroll to PacksSection
  void scrollToPacksSection() {
    // Ensure the widget is built and rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox = _packsKey.currentContext?.findRenderObject() as RenderBox;
      final double position = renderBox.localToGlobal(Offset.zero).dy;
      
      // Account for any app bar or status bar offset
      final double offset = position - MediaQuery.of(context).padding.top;
      
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlurredRadialBackground(
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: IntroductionSection(
                  onPacksButtonPressed: scrollToPacksSection,
                ),
              ),
              SliverToBoxAdapter(
                child: PacksSection(key: _packsKey),
              ),
              const SliverToBoxAdapter(
                child: GreenEnergyCard(),
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
        ),
      ),
    );
  }
}