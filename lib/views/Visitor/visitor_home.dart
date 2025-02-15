import 'package:flutter/material.dart';
import 'package:piminnovictus/views/Visitor/Sections/achievement_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/introduction_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/stat_section.dart';
import 'package:piminnovictus/Views/Visitor/Sections/team_section.dart';
import 'package:piminnovictus/views/background.dart';

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return BlurredRadialBackground(
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
            );
          },
        ),
      ),
    );
  }
}