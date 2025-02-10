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
    // List of all available cards
    List<Widget> allCards = [
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
        front: CardContent(image: 'assets/background.jpg', title: 'Advanced Pack'),
        back: CardContent(text: 'Track energy live.', buttonText: 'Details', signiUpButtont: 'Get It',pack: {
      "title": "Basic Pack",
      "image": "assets/panel.png",
      "description": "Unlock energy potential...",
    },
  ),),
      
      const FlipCard(
        front: CardContent(image: 'assets/panel.png', title: 'Basic Pack'),
        back: CardContent(
          text: 'Unlock energy potential...',
          buttonText: 'Details',
          signiUpButtont: 'Get It',pack: {
      "title": "Basic Pack",
      "image": "assets/panel.png",
      "description": "Unlock energy potential...",
    },
  ),
        ),
      
      const FlipCard(
        front: CardContent(image: 'assets/background.jpg', title: 'Advanced Pack'),
        back: CardContent(text: 'Track energy live.', buttonText: 'Details', signiUpButtont: 'Get It',pack: {
      "title": "Basic Pack",
      "image": "assets/panel.png",
      "description": "Unlock energy potential...",
    },
  ),
      ),
      const FlipCard(
        front: CardContent(image: 'assets/background.jpg', title: 'Advanced Pack'),
        back: CardContent(text: 'Track energy live.', buttonText: 'Details', signiUpButtont: 'Get It',pack: {
      "title": "Basic Pack",
      "image": "assets/panel.png",
      "description": "Unlock energy potential...",
    },
  ),
      ),
    ];

    // Determine the number of cards to display
    int totalCards = allCards.length;
    int cardsToShow = (totalCards > 4) ? 4 : (totalCards == 3 ? 2 : totalCards);

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
                textStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                colors: [Colors.white, Colors.green, Colors.white],
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
              _buildDescriptionRow(Icons.bar_chart, 'Choose the Perfect Plan & Take Control of Your Energy!'),
              _buildDescriptionRow(Icons.apartment,
                  'Flexible, transparent, and built for YOU! Whether you’re an individual, a business, or a large enterprise, GreenEnergyChain offers tailored solutions to maximize your energy efficiency and savings.'),
              _buildDescriptionRow(Icons.rocket_launch,
                  'Ready to take the leap? Tap "Account Creation" and start your energy revolution today!'),
            ],
          ),

          const SizedBox(height: 20),

          // **Grid of Flip Cards**
          SizedBox(
            height: 420,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
              children: allCards.take(cardsToShow).toList(),
            ),
          ),

          // **Custom Button**
        Center(
  child: InkWell(
   onTap: () {
  Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PacksList(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
},

    child: SizedBox(
      width: 250,  // Custom Width
      height: 50,  // Custom Height
      child: Container(
        alignment: Alignment.center, // Ensures text is centered
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Text(
          " View all packs & offers",
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),
        ),
      ),
    ),
  ),
),

        ],
      ),
    );
  }

  // Helper method for description rows
  Widget _buildDescriptionRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
