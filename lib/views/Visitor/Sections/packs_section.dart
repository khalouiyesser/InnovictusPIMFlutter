import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/views/Visitor/packs_list.dart';
import '../card_content.dart';
import '../flip_card.dart';

class PacksSection extends StatefulWidget {
  const PacksSection({super.key});

  @override
  _PacksSectionState createState() => _PacksSectionState();
}

class _PacksSectionState extends State<PacksSection> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final basePadding = screenWidth * 0.05;
        final titleFontSize = screenWidth * 0.055;
        final contentFontSize = screenWidth * 0.038;
        final buttonHeight = screenWidth * 0.12;

        // List of all available cards
        List<Widget> allCards = [
          const FlipCard(
            front: CardContent(image: 'assets/panel.png', title: 'Basic Pack'),
            back: CardContent(
              text:
                  'Unlock energy potential Unlock energy potentialhhhhhhhhhhhhhhhhhhhhhhhhh hhhhhhhhhhhhhhhhh Unlock energy potential Unlock energy potential Unlock energy potential Unlock energy potentialUnlock energy potential Unlock energy potentialUnlock energy potentialUnlock energy potential v Unlock energy potentialUnlock energy potential ...',
              buttonText: 'Details',
              signiUpButtont: 'Get It',
              pack: {
                "title": "Basic Pack",
                "image": "assets/panel.png",
                "description":
                    "Unlock energy potential Unlock energy potential Unlock energy potential Unlock energy potential Unlock energy potential Unlock energy potentialUnlock energy potential Unlock energy potentialUnlock energy potentialUnlock energy potential v Unlock energy potentialUnlock energy potential ...",
              },
            ),
          ),
          const FlipCard(
            front: CardContent(
                image: 'assets/background.jpg', title: 'Advanced Pack'),
            back: CardContent(
              text: 'Track energy live.',
              buttonText: 'Details',
              signiUpButtont: 'Get It',
              pack: {
                "title": "Advanced Pack",
                "image": "assets/background.jpg",
                "description": "Track energy live.",
              },
            ),
          ),
          const FlipCard(
            front: CardContent(image: 'assets/panel.png', title: 'Basic Pack'),
            back: CardContent(
              text: 'Unlock energy potential...',
              buttonText: 'Details',
              signiUpButtont: 'Get It',
              pack: {
                "title": "Basic Pack",
                "image": "assets/panel.png",
                "description": "Unlock energy potential...",
              },
            ),
          ),
          const FlipCard(
            front: CardContent(
                image: 'assets/background.jpg', title: 'Advanced Pack'),
            back: CardContent(
              text: 'Track energy live.',
              buttonText: 'Details',
              signiUpButtont: 'Get It',
              pack: {
                "title": "Advanced Pack",
                "image": "assets/background.jpg",
                "description": "Track energy live.",
              },
            ),
          ),
        ];

        // Determine the number of cards to display
        int totalCards = allCards.length;
        int cardsToShow =
            (totalCards > 4) ? 4 : (totalCards == 3 ? 2 : totalCards);

        return Padding(
          padding: EdgeInsets.all(basePadding),
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
                      fontSize: titleFontSize, // Taille responsive
                      fontWeight: FontWeight.bold,
                    ),
                    colors: [Colors.white, Colors.green, Colors.white],
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
              SizedBox(height: screenWidth * 0.04),

              // **Description Section**
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescriptionRow(
                      Icons.bar_chart,
                      'Choose the Perfect Plan & Take Control of Your Energy!',
                      screenWidth),
                  _buildDescriptionRow(
                      Icons.apartment,
                      'Flexible, transparent, and built for YOU! Whether you’re an individual, a business, or a large enterprise, GreenEnergyChain offers tailored solutions to maximize your energy efficiency and savings.',
                      screenWidth),
                  _buildDescriptionRow(
                      Icons.rocket_launch,
                      'Ready to take the leap? Tap "Account Creation" and start your energy revolution today!',
                      screenWidth),
                ],
              ),

              SizedBox(height: screenWidth * 0.06),

              // **Grid of Flip Cards**
              SizedBox(
                height: screenWidth * 1.2, // Hauteur responsive
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: screenWidth * 0.02, // Espacement responsive
                  mainAxisSpacing: screenWidth * 0.02, // Espacement responsive
                  childAspectRatio: 0.8,
                  children: allCards.take(cardsToShow).toList(),
                ),
              ),

              SizedBox(height: screenWidth * 0.03),

              // **Custom Button**
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            PacksList(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: screenWidth * 0.7, // Largeur responsive
                    height: buttonHeight, // Hauteur responsive
                    child: Container(
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
                        "View all packs & offers",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: contentFontSize, // Taille responsive
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method for description rows
  Widget _buildDescriptionRow(IconData icon, String text, double screenWidth) {
    final iconSize = screenWidth * 0.055; // Taille des icônes responsive
    final fontSize = screenWidth * 0.038; // Taille du texte responsive

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: iconSize),
        SizedBox(width: screenWidth * 0.02), // Espacement responsive
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize, // Taille responsive
            ),
          ),
        ),
      ],
    );
  }
}
