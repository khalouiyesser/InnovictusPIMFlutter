import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: Image.asset(
            "assets/Pulse.png",
            fit: BoxFit.cover,
          ),
        ),
        // Overlay
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text('Privacy Policy'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Container(
            color: Colors.transparent,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Privacy Policy",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Divider(
                              color: Color.fromARGB(90, 255, 255, 255),
                              thickness: 2,
                            ),
                            SizedBox(height: 20),
                            Text(
                              """Privacy Policy for GreenEnergyChain (Tunisia)

Effective Date: 01-02-2025

GreenEnergyChain is committed to protecting your privacy. This Privacy Policy outlines how we collect, use, and safeguard your personal information when you use our platform.

1. Information We Collect
• Personal Information: Name, email address, phone number, and other contact details provided during registration.
• Transaction Data: Details of transactions conducted on the platform, including energy traded and GEC used.
• IoT Data: Real-time energy production data collected through IoT devices.
• Usage Data: Information on how you interact with the platform, including IP addresses, browser types, and access times.

2. Use of Information
We use the collected information to:
• Provide and improve our services.
• Facilitate transactions and smart contracts.
• Monitor and optimize energy production and consumption.
• Ensure the security and integrity of the platform.
• Communicate with you regarding updates, promotions, and support.

3. Data Sharing
We do not sell or rent your personal information to third parties. However, we may share information with:
• Service Providers: Third-party vendors who assist in platform operations.
• Legal Authorities: When required by law or to protect our rights and safety.
• Business Transfers: In the event of a merger, acquisition, or sale of assets.

4. Data Security
We implement robust security measures to protect your data from unauthorized access, alteration, or destruction. These measures include encryption, secure servers, and access controls.

5. User Rights
• Access: You can request access to the personal information we hold about you.
• Correction: You can request corrections to any inaccurate or incomplete information.
• Deletion: You can request the deletion of your personal information, subject to legal obligations.

6. Cookies and Tracking
We use cookies and similar technologies to enhance your experience on our platform. You can manage your cookie preferences through your browser settings.

7. International Transfers
Your information may be transferred to and processed in countries outside Tunisia, where data protection laws may differ. We ensure appropriate safeguards are in place to protect your data.

8. Changes to Privacy Policy
We may update this Privacy Policy from time to time. Any changes will be posted on the platform, and your continued use constitutes acceptance of the revised policy.

9. Contact Information
For any questions or concerns regarding this Privacy Policy, please contact us at [Insert Contact Information].

By using GreenEnergyChain, you acknowledge that you have read, understood, and agree to these Terms and Conditions and Privacy Policy. Thank you for choosing GreenEnergyChain for your renewable energy needs.""",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 31, 219, 59),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "I Understand",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}