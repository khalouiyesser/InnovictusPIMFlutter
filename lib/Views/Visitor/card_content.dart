import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/AuthViews/RegisterView.dart';
import 'package:piminnovictus/views/Visitor/pack_details.dart';

class CardContent extends StatelessWidget {
  final String? image;
  final String? title;
  final String? text;
  final String? buttonText;
  final String? signiUpButtont;
  final Map<String, String>? pack;

  const CardContent({
    super.key,
    this.image,
    this.title,
    this.text,
    this.buttonText,
    this.signiUpButtont,
    this.pack,
  });

  @override
  Widget build(BuildContext context) {
    final packData = pack ??
        {
          "title": title ?? "",
          "image": image ?? "",
          "description": text ?? "",
        };

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
        if (buttonText != null) availableHeight -= cardHeight * 0.15;

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
              color: Colors.white.withOpacity(0.3),
              width: 1,
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
                  child: Text(
                    text!,
                    style: textStyle,
                    maxLines: maxLines,
                    overflow: TextOverflow
                        .ellipsis, // Automatically adds "..." when text overflows
                  ),
                ),
              if (buttonText != null && signiUpButtont != null) ...[
                SizedBox(height: cardHeight * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: cardWidth * 0.37,
                      height: cardHeight * 0.12,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF29E33C),
                              Color.fromARGB(255, 9, 128, 25)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        PackDetails(pack: packData),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            buttonText!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: cardWidth * 0.08,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: cardWidth * 0.02),
                    SizedBox(
                      width: cardWidth * 0.35,
                      height: cardHeight * 0.12,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      RegisterView(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
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
              ],
            ],
          ),
        );
      },
    );
  }
}
