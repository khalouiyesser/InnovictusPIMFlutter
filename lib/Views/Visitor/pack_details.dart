import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/AuthViews/RegisterView.dart';

class PackDetails extends StatelessWidget {
  final Map<String, String> pack;

  const PackDetails({Key? key, required this.pack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "${pack["title"]} Details", // Concatenating title with "Details"
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0), // 🌟 Ensure consistent 20 padding everywhere
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 🌟 Aligns everything to the left
          children: [
            // 🌟 Title
            Text(
              pack["title"]!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),

            // 🖼 Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                pack["image"]!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),

            // 📝 Description with left-aligned text and 20 padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10), // ✅ Only 20px padding on left/right
              child: Text(
                pack["description"]!,
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
             SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              
                _buildButton(
                  text: "Get it",
                  width: 140,
                  height: 50,
                  color: Colors.transparent,
                  textColor: Colors.green,
                  borderColor: Colors.green,
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            RegisterView(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
Padding(
  padding: const EdgeInsets.only(bottom: 10.0), // ✅ Adds spacing before the table
  child: Center( // ✅ Centers the text
    child: Text(
      "Everything about ${pack["title"]} !",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  ),
),

            // 📊 Table with improved styling
            Card(
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0), // ✅ 20px padding inside the card
                child: Column(
                  children: [
                    _buildTableRow("💰 Prix :", "999€"),
                    _buildDivider(),
                    _buildTableRow("🔆 Panneaux Solaires :", "6 panneaux"),
                    _buildDivider(),
                    _buildTableRow("⚡ Énergie Gagnée :", "5 kWh/jour"),
                    _buildDivider(),
                    _buildTableRow("🌍 Fossile Évitée :", "10 kg CO₂/jour"),
                    _buildDivider(),
                    _buildTableRow("✅ Certification :", "Empreinte carbone réduite"),
                  ],
                ),
              ),
            ),
           
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft, // ✅ Left alignment
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$title ", // ✅ Title with a space after
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              TextSpan(
                text: value,
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          softWrap: true, // ✅ Ensures text wraps correctly
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white30,
      thickness: 1,
      height: 10,
    );
  }

  Widget _buildButton({
    required String text,
    required double width,
    required double height,
    required Color color,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          border: borderColor != null ? Border.all(color: borderColor, width: 2) : null,
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
