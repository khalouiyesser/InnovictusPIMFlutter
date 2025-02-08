
import 'package:flutter/material.dart';
import 'package:piminnovictus/views/Visitor/Sections/introduction_section.dart';
import 'package:piminnovictus/views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/views/background.dart';


class VisitorPage extends StatelessWidget {
  const VisitorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: BlurredRadialBackground(
          child:  CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: IntroductionSection(),
              ),
              SliverToBoxAdapter(
                child: PacksSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}