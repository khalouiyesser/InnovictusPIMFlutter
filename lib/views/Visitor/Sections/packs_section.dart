import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'card_content.dart';
import 'flip_card.dart';

class PacksSection extends StatefulWidget {
  const PacksSection({super.key});

  @override
  _PacksSectionState createState() => _PacksSectionState();
}

class _PacksSectionState extends State<PacksSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
         mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // **Colorize Animated Text**
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Power Up with Our Exclusive Packs',
                textStyle: TextStyle(
                  fontSize: 19.0, // Font size is required
                  fontWeight: FontWeight.bold,
                ),
                colors: [
                  Colors.white,
                  Colors.green,
                  Colors.white,
                ],
                speed: const Duration(milliseconds: 200),
              ),
            ],
            isRepeatingAnimation: false,
          ),
          const SizedBox(height: 20),

          // **Description Section**
          Column(
             mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.bar_chart, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: const Text(
                      'Choose the Perfect Plan & Take Control of Your Energy!',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.apartment, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: const Text(
                      'Flexible, transparent, and built for YOU! Whether you’re an individual, '
                      'a business, or a large enterprise, GreenEnergyChain offers tailored '
                      'solutions to maximize your energy efficiency and savings.',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: const Text(
                      'Ready to take the leap? Tap "Account Creation" and start your energy revolution today!',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // **Grid of Flip Cards**
          SizedBox(
            height: 600, // Adjust height as needed
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
              children: const [
                FlipCard(
                  front: CardContent(image: 'assets/panel.png', title: 'Basic Pack'),
                  back: CardContent(text: 'Unlock energy potential.', buttonText: 'See Details'),
                ),
                FlipCard(
                  front: CardContent(image: 'assets/background.jpg', title: 'Advanced Pack'),
                  back: CardContent(text: 'Track energy live.', buttonText: 'See Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
