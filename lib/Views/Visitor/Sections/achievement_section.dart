import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AchievementSection extends StatefulWidget {
  const AchievementSection({Key? key}) : super(key: key);

  @override
  State<AchievementSection> createState() => _AchievementSectionState();
}

class _AchievementSectionState extends State<AchievementSection> {
  bool _isVisible = false;
  bool _isCounting = false;

  void _handleVisibilityChange(VisibilityInfo visibilityInfo) {
    if (visibilityInfo.visibleFraction > 0.8 && !_isCounting) {
      setState(() {
        _isVisible = true;
        _isCounting = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isCounting = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key("achievement_section"),
      onVisibilityChanged: _handleVisibilityChange,
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 600 ? 40 : 20,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  "Our GreenEnergyChain Community and Achievements",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 3 / 2,
                  children: [
                    AchievementCard(count: 520, label: "Regular Users", isVisible: _isVisible),
                    AchievementCard(count: 120, label: "Enterprise Users", isVisible: _isVisible),
                    AchievementCard(count: 100, label: "Carbon Footprint Certified", isVisible: _isVisible),
                    AchievementCard(count: 10000, label: "Installed Solar Panels", isVisible: _isVisible),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AchievementCard extends StatelessWidget {
  final int count;
  final String label;
  final bool isVisible;

  const AchievementCard({
    Key? key,
    required this.count,
    required this.label,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth > 150 ? 10 : 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<int>(
                key: UniqueKey(),
                duration: const Duration(seconds: 5),
                tween: isVisible
                    ? IntTween(begin: 0, end: count)
                    : IntTween(begin: count, end: count),
                builder: (context, value, child) {
                  return Text(
                    "+$value",
                    style: TextStyle(
                      fontSize: constraints.maxWidth > 150 ? 25 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 5),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: constraints.maxWidth > 150 ? 16 : 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
