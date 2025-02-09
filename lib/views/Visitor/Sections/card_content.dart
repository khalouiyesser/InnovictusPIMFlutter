import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final String? image;
  final String? title;
  final String? text;
  final String? buttonText;

  const CardContent({
    super.key,
    this.image,
    this.title,
    this.text,
    this.buttonText,
  });

  @override
// Inside CardContent
Widget build(BuildContext context) {
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
            height: 100, // Fixed height for the image
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                image!,
                fit: BoxFit.cover,
              ),
            ),
          ),

        const SizedBox(height: 10), // Space

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

        const SizedBox(height: 10), // Space

        Expanded( // Ensure text takes available space without overflow
          child: SingleChildScrollView(
            child: Text(
              _truncateText(text ?? '', 3),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 10), // Space before the button

        if (buttonText != null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}



  String _truncateText(String text, int maxLines) {
    final words = text.split(' ');
    final buffer = StringBuffer();
    int lineCount = 0;
    int currentLength = 0;

    for (var word in words) {
      if (lineCount >= maxLines) break;

      if (currentLength + word.length > 30) {
        lineCount++;
        if (lineCount >= maxLines) break;
        buffer.write('\n');
        currentLength = 0;
      }

      buffer.write('$word ');
      currentLength += word.length + 1;
    }

    return  buffer.toString().trim() + '...';
  }
}
