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
      _isVisible = true; // Directly set true without resetting
      _isCounting = true; // Prevent re-triggering
    });

    // Allow animation to complete before allowing restart
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCounting = false; // Re-enable counting when visible again
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
      child: Container(
        padding: const EdgeInsets.all(20),
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
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 3 / 2,
              children: [
                AchievementCard(
                  key: UniqueKey(), // Ensures animation restarts correctly
                  count: 520,
                  label: "Regular Users",
                  isVisible: _isVisible,
                ),
                AchievementCard(
                  key: UniqueKey(),
                  count: 120,
                  label: "Enterprise Users",
                  isVisible: _isVisible,
                ),
                AchievementCard(
                  key: UniqueKey(),
                  count: 100,
                  label: "Carbon Footprint Certified",
                  isVisible: _isVisible,
                ),
                AchievementCard(
                  key: UniqueKey(),
                  count: 10000,
                  label: "Installed Solar Panels",
                  isVisible: _isVisible,
                ),
              ],
            ),
          ],
        ),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder<int>(
          key: UniqueKey(), // Ensures animation restarts correctly
          duration: const Duration(seconds: 5),
          tween: isVisible
              ? IntTween(begin: 0, end: count)
              : IntTween(begin: count, end: count),
          builder: (context, value, child) {
            return Text(
              "+$value",
              style: const TextStyle(
                fontSize: 25,
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
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
