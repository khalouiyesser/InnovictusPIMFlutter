import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Views/AuthViews/RegisterView.dart';

class PackDetails extends StatelessWidget {
  final Pack pack;
  const PackDetails({Key? key, required this.pack}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!
              .translate("pack_details")
              .replaceAll("{title}", pack.title),
          style: TextStyle(
            color: Colors.white,
            fontSize: 20, // Fixed size for app bar title
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // Responsive Sizing
          final basePadding = screenWidth * 0.05; // Responsive padding
          final titleFontSize =
              screenWidth * 0.06; // Responsive title font size
          final descriptionFontSize =
              screenWidth * 0.04; // Responsive description font size
          final buttonFontSize =
              screenWidth * 0.045; // Responsive button font size
          final buttonWidth = screenWidth * 0.4; // Responsive button width
          final buttonHeight = screenWidth * 0.12; // Responsive button height
          final imageHeight = screenWidth * 0.55; // Responsive image height
          final imageWidth = imageHeight *
              1.4; // Responsive image width (maintain aspect ratio)

          return SingleChildScrollView(
            padding: EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🌟 Title
                Text(
                  pack.title,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: basePadding),

                // 🖼 Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      pack.image,
                      height: imageHeight,
                      width: imageWidth,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: basePadding),

                // 📝 Description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: basePadding * 0.5),
                  child: Text(
                    pack.description,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: basePadding),

                // 🌟 Get It Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      text: AppLocalizations.of(context)!.translate("subscribe"),
                      width: buttonWidth,
                      height: buttonHeight,
                      color: Colors.transparent,
                      textColor: Color(0xFF29E33C),
                      borderColor: Color(0xFF29E33C),
                      fontSize: buttonFontSize, // Responsive font size
                      onTap: () {
                        print('PackDetails - Passing pack ID: ${pack.id}');
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    RegisterView(packId: pack.id ?? ""),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: basePadding),

                // 🌟 Everything About Pack Title
                Padding(
                  padding: EdgeInsets.only(bottom: basePadding * 0.5),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate("pack_details_every")
                          .replaceAll("{title}", pack.title),
                      style: TextStyle(
                        fontSize: titleFontSize * 0.8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // 📊 Table
                Card(
                  color: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(basePadding),
                    child: Column(
                      children: [
                        _buildTableRow("💰 ${AppLocalizations.of(context)!.translate("price")} :", "${pack.price} €", descriptionFontSize),
                        _buildDivider(),
                        _buildTableRow("🔆 ${AppLocalizations.of(context)!.translate("solar_panels")} :", "${pack.panels} panels", descriptionFontSize),
                        _buildDivider(),
                        _buildTableRow("⚡ ${AppLocalizations.of(context)!.translate("energy_gain")} :", "${pack.generated} kWh/jour", descriptionFontSize),
                        _buildDivider(),
                        _buildTableRow("💹 ${AppLocalizations.of(context)!.translate("financial_gain")} :", "${pack.gain} €/an", descriptionFontSize),
                        _buildDivider(),
                        _buildTableRow("🌍 ${AppLocalizations.of(context)!.translate("co2_saved")} :", "${pack.fossil} kg CO₂/an", descriptionFontSize),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTableRow(String title, String value, double fontSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "$title ",
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
              TextSpan(
                text: value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          softWrap: true,
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
    required double fontSize, // Responsive font size
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
          border: borderColor != null
              ? Border.all(color: borderColor, width: 2)
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize, // Responsive font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}