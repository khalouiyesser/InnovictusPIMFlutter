import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/Views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/Views/Visitor/packs_list.dart';

class IntroductionSection extends StatelessWidget {
  final VoidCallback onPacksButtonPressed;

  const IntroductionSection({
    super.key,
    required this.onPacksButtonPressed,
  });

  void _handleLoginTap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final basePadding = screenWidth * 0.05;
        final logoSize = screenWidth * 0.05;
        final titleFontSize = screenWidth * 0.055;
        final buttonHeight = screenWidth * 0.12;
        final contentFontSize = screenWidth * 0.038;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Column(
                    children: [
                      // Row 1: Logo + Login Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Logo and Title
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(screenWidth * 0.01),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF29E33C),
                                    width: 1.5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: logoSize,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      const AssetImage('assets/logo.png'),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text(
                                'GreenEnergy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          // Login Icon Only
                          InkWell(
                            onTap: () => _handleLoginTap(context),
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.01),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                Icons.login,
                                color: Colors.white,
                                size: logoSize * 2, // Match the logo size
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Row 2: Login Text aligned with the icon
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: screenWidth *
                                    0.8), // Déplace le texte vers la droite
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
                SizedBox(height: screenWidth * 0.06),

                Center(
                  child: InkWell(
                    onTap: onPacksButtonPressed,
                    child: Container(
                      width: screenWidth * 0.7,
                      height: buttonHeight,
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
                          fontSize: contentFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenWidth * 0.06),

                // Main Title
                Center(
                  child: Text(
                    'The Energy Revolution Starts Now !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth * 0.06),
                // Main Content Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rich Text Content
                      Text.rich(
                        TextSpan(
                          children: _buildResponsiveTextSpans(contentFontSize),
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.04),

                      // Image
                      Container(
                        height: screenWidth * 0.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          image: const DecorationImage(
                            image: AssetImage('assets/background.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.04),

                      // Feature List
                      _buildFeatureList(screenWidth),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TextSpan> _buildResponsiveTextSpans(double fontSize) {
    return [
      TextSpan(
        text: 'For too long, energy has been controlled by ',
        style: TextStyle(color: Colors.white, fontSize: fontSize, height: 1.1),
      ),
      TextSpan(
        text: 'monopoly.\n',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: 'What if ',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
        text: 'YOU',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: ' could ',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
        text: 'produce, sell, trade',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: ' renewable energy ',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
        text: 'freely and securely ?\n',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: '⚡ GreenEnergy makes it possible ! ',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: '\n',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
        text: 'With ',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
        text: 'smart grids + blockchain ',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text: ', we are ',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
        text: 'decentralizing ',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      TextSpan(
        text:
            'Tunisia’s energy market, empowering individuals and businesses to ',
        style: TextStyle(color: Colors.white, fontSize: fontSize),
      ),
      TextSpan(
        text: 'take control.',
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ];
  }

  Widget _buildFeatureList(double screenWidth) {
    final iconSize = screenWidth * 0.055; // Taille des icônes responsive
    final fontSize = screenWidth * 0.04; // Taille du texte responsive
    final spacing = screenWidth * 0.02; // Espacement responsive

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Feature 1: Energy independence
        _buildFeatureRow(
          Icons.power_off,
          "No more reliance on STEG.",
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 2: Selling energy
        _buildFeatureRow(
          Icons.attach_money,
          "Sell your excess solar energy directly to others.",
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 3: AI + IoT
        _buildFeatureRow(
          Icons.memory,
          "AI + IoT optimize energy flow in real-time.",
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 4: Blockchain security
        _buildFeatureRow(
          Icons.lock,
          "Blockchain ensures 100% secure & transparent transactions.",
          iconSize,
          fontSize,
        ),
        SizedBox(height: spacing), // Espacement responsive

        // Feature 5: Green impact
        _buildFeatureRow(
          Icons.eco,
          "Earn certified proof of your green impact & reduce carbon emissions.",
          iconSize,
          fontSize,
        ),
      ],
    );
  }

  Widget _buildFeatureRow(
    IconData icon,
    String text,
    double iconSize,
    double fontSize,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: iconSize),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
            ),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
