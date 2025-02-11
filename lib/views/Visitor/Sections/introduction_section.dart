import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/views/Visitor/Sections/packs_section.dart';
import 'package:piminnovictus/views/Visitor/packs_list.dart';

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
      transitionDuration: Duration.zero, // No transition animation
      reverseTransitionDuration: Duration.zero,
    ),
  );

  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Title
           Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo and Title
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2E7D32),
                      width: 1.5,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'GreenEnergy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            // Login Icon and Text
            InkWell(
              onTap: () => _handleLoginTap(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  
                ],
              ),
            ),
          ],
        ),
        Row(children: [ SizedBox(width: 309),
          Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),]),
                    const SizedBox(height: 30),



Center(
      child: InkWell(
        onTap: onPacksButtonPressed,
        child: SizedBox(
          width: 250,
          height: 50,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Text(
              "View all packs & offers",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
),
          const SizedBox(height: 30),

          // Title
         const Center(
            child: Text(
              'The Energy Revolution Starts Now !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Transparent Card with White Border
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'For too long, energy has been controlled by ',
                          style: TextStyle(
                              color: Colors.white, fontSize: 16, height: 1.1)),
                      TextSpan(
                          text: 'monopoly.\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: 'What if ',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextSpan(
                          text: 'YOU',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' could ',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextSpan(
                          text: 'produce, sell, trade',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' renewable energy ',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextSpan(
                          text: 'freely and securely ?\n',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '⚡ GreenEnergy makes it possible ! ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: '\n',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextSpan(
                          text: 'With ',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextSpan(
                          text: 'smart grids + blockchain ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ', we are ',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextSpan(
                          text: 'decentralizing ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'Tunisia’s energy market, empowering individuals and businesses to ',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      TextSpan(
                          text: 'take control.',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Image Container
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: AssetImage('assets/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

               const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.power_off,
                            color: Colors.white,
                            size: 20), // Energy independence
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "No more reliance on STEG.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.attach_money,
                            color: Colors.white, size: 20), // Selling energy
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Sell your excess solar energy directly to others.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.memory,
                            color: Colors.white, size: 20), // AI + IoT
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "AI + IoT optimize energy flow in real-time.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock,
                            color: Colors.white,
                            size: 20), // Blockchain security
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Blockchain ensures 100% secure & transparent transactions.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.eco,
                            color: Colors.white, size: 20), // Green impact
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Earn certified proof of your green impact & reduce carbon emissions.",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
    );
  }
}
