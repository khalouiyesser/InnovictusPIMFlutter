import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';

import '../AuthViews/RegisterView.dart';
import 'pack_details.dart';

class CardContent extends StatelessWidget {
  final String? image;
  final String? title;
  final String? text;
  final String? signiUpButtont;
  final String? selectButtont;

  final VoidCallback? onSelectPressed;
  final bool isSelected;

  final Pack pack;
  const CardContent({
    super.key,
    this.image,
    this.title,
    this.text,
    this.signiUpButtont,
    this.selectButtont,
    this.onSelectPressed, // Add this parameter
    this.isSelected = false,
    required this.pack,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final cardHeight = constraints.maxHeight;

        final textStyle = TextStyle(
          color: Colors.white,
          fontSize: cardWidth * 0.08,
          height: 1.5,
        );

        double availableHeight = cardHeight;
        if (image != null) availableHeight -= cardHeight * 0.70;
        if (title != null) availableHeight -= cardHeight * 0.15;

        final lineHeight = textStyle.fontSize! * textStyle.height!;
        final maxLines = (availableHeight / lineHeight).floor();

        return Container(
          width: cardWidth,
          height: cardHeight,
          padding: EdgeInsets.all(cardWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF29E33C)
                  : Colors.white.withOpacity(0.3),
              width: isSelected ? 3 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                SizedBox(
                  height: cardHeight * 0.70,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              if (title != null) ...[
                SizedBox(height: cardHeight * 0.01),
                Center(
                  child: Text(
                    title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: cardWidth * 0.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: cardHeight * 0.01),
              ],
              if (text != null)
                Expanded(
                  child: Center(
                    child: Text(
                      text!,
                      style: textStyle,
                      maxLines: maxLines,
                      overflow: TextOverflow
                          .ellipsis, // Automatically adds "..." when text overflows
                    ),
                  ),
                ),
              if ( signiUpButtont != null) ...[
                SizedBox(height: cardHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     SizedBox(width: cardWidth * 0.02),
                    SizedBox(
                     width: cardWidth * 0.5,
                      height: cardHeight * 0.16,
                      child: OutlinedButton(
                        onPressed: () {
                              Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PackDetails(pack: pack),
      ),
    );
                          },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFF29E33C), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          signiUpButtont!,
                          style: TextStyle(
                            color: const Color(0xFF29E33C),
                            fontSize: cardWidth * 0.08,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (selectButtont != null) ...[
                // New select button for subscription view
                SizedBox(height: cardHeight * 0.01),
                Center(
                  child: SizedBox(
                    width: cardWidth * 0.58,
                    height: cardHeight * 0.16,
                    child: OutlinedButton(
                      onPressed: onSelectPressed,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color(0xFF29E33C), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        selectButtont!,
                        style: TextStyle(
                          color: const Color(0xFF29E33C),
                          fontSize: cardWidth * 0.08,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
