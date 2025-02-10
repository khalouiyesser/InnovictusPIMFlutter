import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/AuthViews/RegisterView.dart';
import 'package:piminnovictus/views/Visitor/pack_details.dart';

class CardContent extends StatelessWidget {
  final String? image;
  final String? title;
  final String? text;
  final String? buttonText;
  final String? signiUpButtont;
  // Add a pack parameter
  final Map<String, String>? pack;

  const CardContent({
    super.key,
    this.image,
    this.title,
    this.text,
    this.buttonText,
    this.signiUpButtont,
    this.pack, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    // Create pack data based on the card content
    final packData = pack ?? {
      "title": title ?? "",
      "image": image ?? "",
      "description": text ?? "",
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
              height: 100,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          const SizedBox(height: 10),

          if (title != null)
            Text(
              title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                text ?? '',
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          if (buttonText != null && signiUpButtont != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Details button with gradient background
                SizedBox(
                  width: 56,
                  height: 30,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF29E33C), Color.fromARGB(255, 9, 128, 25)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => 
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
                        fixedSize: const Size(double.infinity, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        buttonText!,
                        
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Get It button
                SizedBox(
                  width: 56,
                  height: 30,
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                            RegisterView(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF29E33C), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      signiUpButtont!,
                      style: const TextStyle(
                        color: Color(0xFF29E33C),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}