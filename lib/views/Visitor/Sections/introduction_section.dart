import 'package:flutter/material.dart';

class IntroductionSection extends StatelessWidget {
  const IntroductionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Title
          Row(
            children: [
              Container(
                padding:const EdgeInsets.all(3), // For the green border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF2E7D32),
                    width: 2,
                  ),
                ),
                child:const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
              ),
              const SizedBox(width: 15),
             const Text(
                'GreenEnergyChain',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Title
         const Center(
            child: Text(
              'The Energy Revolution Starts Now !',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
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
                          text: '⚡ GreenEnergyChain makes it possible ! ',
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
        ],
      ),
    );
  }
}
