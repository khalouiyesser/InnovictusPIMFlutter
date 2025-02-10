import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List of team members remains the same
    final List<TeamMember> teamMembers = const [
      TeamMember(
        name: "Shayma Ouertani",
        email: "shayma.ouerhani@esprit.tn",
        phone: "+216 28 160 626",
        image: "assets/shayma.jpeg",
        linkedinUrl: "https://www.linkedin.com/in/shayma-ouerhani-b468ab284/",
      ),
      TeamMember(
        name: "Hadhemi Mahmoud",
        email: "hadhemi.mahmoud@esprit.tn",
        phone: "+216 26 892 285",
        image: "assets/hadhemi.jpg",
        linkedinUrl: "https://www.linkedin.com/in/hadhemi-mahmoud-aa6384250/",
      ),
      TeamMember(
        name: "Yesser El Khaloui",
        email: "yesser.khaloui@esprit.tn",
        phone: "+216 25 114 365",
        image: "assets/yesser.jpg",
        linkedinUrl: "https://www.linkedin.com/in/yesserkhaloui/",
      ),
      TeamMember(
        name: "Houssem Khalfaoui",
        email: "houssemeddine.khalfaoui@esprit.tn",
        phone: "+216 25 405 325",
        image: "assets/houssem.jpg",
        linkedinUrl: "https://www.linkedin.com/in/houssem-khalfaoui-499389254/",
      ),
      TeamMember(
        name: "Yassine Ajbouni",
        email: "yassine.ajbouni@esprit.tn",
        phone: "+216 23 990 938",
        image: "assets/yassine.jpg",
        linkedinUrl: "https://www.linkedin.com/in/yassine-ajbouni-1616b01a0/",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title and description sections remain the same...
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.groups, color: Colors.white, size: 30),
                SizedBox(width: 8),
                Text(
                  "Who We Are?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "We are a team of passionate engineers committed to creating innovative solutions for a sustainable future. "
              "Our mission is to revolutionize the energy landscape in Tunisia by offering a real, impactful solution that supports the environment. "
              "Through GreenEnergyChain, we aim to reduce reliance on fossil fuels, promote renewable energy, and empower communities "
              "with smart, decentralized energy systems. Together, we are shaping a greener, more sustainable world.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              "Contact Us",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // Modified team members layout
            Column(
              children: [
                // First row - 2 members
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: teamMembers[0]),
                    const SizedBox(width: 20),
                    Expanded(child: teamMembers[1]),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Second row - 1 centered member
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: teamMembers[2],
                ),
                const SizedBox(height: 20),
                
                // Third row - 2 members
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: teamMembers[3]),
                    const SizedBox(width: 20),
                    Expanded(child: teamMembers[4]),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
class TeamMember extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String image;
  final String linkedinUrl;

  const TeamMember({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.linkedinUrl,
  }) : super(key: key);

  // Function to open email
  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Contact Request',
        'body': 'Hello, I would like to get in touch with you.',
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch email client')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Function to make phone call
  Future<void> _callPhone(BuildContext context) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phone.replaceAll(' ', ''),
    );

    try {
      if (await canLaunchUrl(phoneLaunchUri)) {
        await launchUrl(phoneLaunchUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch phone app')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Function to open LinkedIn
  Future<void> _openLinkedIn(BuildContext context) async {
    final Uri linkedInUri = Uri.parse(linkedinUrl);

    try {
      if (await canLaunchUrl(linkedInUri)) {
        await launchUrl(linkedInUri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch LinkedIn')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF29E33C),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage(image),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Email with white color
          InkWell(
            onTap: () => _sendEmail(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.email, color: Color(0xFF29E33C), size: 12),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Phone with white color
          InkWell(
            onTap: () => _callPhone(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.phone, color: Color(0xFF29E33C), size: 12),
                const SizedBox(width: 4),
                Text(
                  phone,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // LinkedIn with white color
          InkWell(
            onTap: () => _openLinkedIn(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.link, color: Color(0xFF29E33C), size: 12),
                const SizedBox(width: 4),
                const Text(
                  "LinkedIn Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}