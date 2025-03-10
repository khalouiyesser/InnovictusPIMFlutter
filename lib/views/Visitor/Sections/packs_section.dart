import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/viewmodels/packs_view_model.dart';
import 'package:piminnovictus/views/Visitor/packs_list.dart';
import 'package:provider/provider.dart';
import '../card_content.dart';
import '../flip_card.dart';

class PacksSection extends StatefulWidget {
  const PacksSection({super.key});

  @override
  _PacksSectionState createState() => _PacksSectionState();
}

class _PacksSectionState extends State<PacksSection> {
 late PacksViewModel _packsViewModel;
bool _isLoading = true;
List<Pack> packs = [];
  @override
void initState() {
  super.initState();
  _packsViewModel = Provider.of<PacksViewModel>(context, listen: false);
  _loadPacks();
}

Future<void> _loadPacks() async {
  setState(() {
    _isLoading = true;
  });

  await _packsViewModel.getAllPacks();

  setState(() {
    packs = _packsViewModel.packs;
    _isLoading = false;
  });
}
 @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final basePadding = screenWidth * 0.05;
      final titleFontSize = screenWidth * 0.055;
      final contentFontSize = screenWidth * 0.038;
      final buttonHeight = screenWidth * 0.12;

      // Create flip cards using Pack objects from ViewModel
      List<Widget> allCards = _isLoading 
          ? [] 
          : packs.map((pack) => FlipCard(
              front: CardContent(
                image: pack.image,
                title: pack.title,
                pack: pack,
              ),
              back: CardContent(
                text: pack.description,
                signiUpButtont: AppLocalizations.of(context).translate("details"),
                pack: pack,
              ),
            )).toList();

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
            // Title section
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  AppLocalizations.of(context).translate("power_up_packs"),
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  colors: [Colors.white, Colors.green, Colors.white],
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              isRepeatingAnimation: false,
            ),
            SizedBox(height: screenWidth * 0.04),

            // Description Section
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescriptionRow(
                    Icons.bar_chart,
                    AppLocalizations.of(context).translate("choose_perfect_plan"),
                    screenWidth),
                _buildDescriptionRow(
                    Icons.apartment,
                    AppLocalizations.of(context).translate("flexible_solutions"),
                    screenWidth),
                _buildDescriptionRow(
                    Icons.rocket_launch,
                    AppLocalizations.of(context).translate("ready_to_leap"),
                    screenWidth),
              ],
            ),

            SizedBox(height: screenWidth * 0.06),

            // Grid of Flip Cards with loading indicator
            SizedBox(
              height: screenWidth * 1.2,
              child: _isLoading 
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : _packsViewModel.errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white70,
                            size: screenWidth * 0.1,
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          Text(
                            _packsViewModel.errorMessage,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: contentFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenWidth * 0.02),
                          ElevatedButton(
                            onPressed: _loadPacks,
                            child: Text(
                              AppLocalizations.of(context)!.translate("retry"),
                              style: TextStyle(fontSize: contentFontSize),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(buttonHeight / 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenWidth * 0.02,
                      childAspectRatio: 0.8,
                      children: allCards.take(cardsToShow).toList(),
                    ),
            ),

            SizedBox(height: screenWidth * 0.03),

            // Custom Button
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
                  width: screenWidth * 0.7,
                  height: buttonHeight,
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
                      AppLocalizations.of(context).translate("view_all_packs_offers"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: contentFontSize,
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
