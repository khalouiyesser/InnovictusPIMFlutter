import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:url_launcher/url_launcher.dart';

class TeamSection extends StatelessWidget {
  const TeamSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final basePadding = screenWidth * 0.05;
        final titleFontSize = screenWidth * 0.055;
        final contentFontSize = screenWidth * 0.038;
        final teamMemberNameSize = screenWidth * 0.035;
        final teamMemberInfoSize = screenWidth * 0.025;
        final teamMemberLinkSize = screenWidth * 0.03;
        final iconSize = screenWidth * 0.03;
        final avatarRadius = screenWidth * 0.08;
        final containerSpacing = screenWidth * 0.02;

        final List<TeamMember> teamMembers = [
          TeamMember(
            name: "Shayma Ouertani",
            email: "shayma.ouerhani@esprit.tn",
            phone: "+216 28 160 626",
            image: "assets/shayma.jpeg",
            linkedinUrl: "https://www.linkedin.com/in/shayma-ouerhani-b468ab284/",
            nameFontSize: teamMemberNameSize,
            infoFontSize: teamMemberInfoSize,
            linkFontSize: teamMemberLinkSize,
            iconSize: iconSize,
            avatarRadius: avatarRadius,
          ),
          // Copy the same pattern for other team members
          TeamMember(
            name: "Hadhemi Mahmoud",
            email: "hadhemi.mahmoud@esprit.tn",
            phone: "+216 26 892 285",
            image: "assets/hadhemi.jpg",
            linkedinUrl: "https://www.linkedin.com/in/hadhemi-mahmoud-aa6384250/",
            nameFontSize: teamMemberNameSize,
            infoFontSize: teamMemberInfoSize,
            linkFontSize: teamMemberLinkSize,
            iconSize: iconSize,
            avatarRadius: avatarRadius,
          ),
          TeamMember(
            name: "Yesser El Khaloui",
            email: "yesser.khaloui@esprit.tn",
            phone: "+216 25 114 365",
            image: "assets/yesser.jpg",
            linkedinUrl: "https://www.linkedin.com/in/yesserkhaloui/",
            nameFontSize: teamMemberNameSize,
            infoFontSize: teamMemberInfoSize,
            linkFontSize: teamMemberLinkSize,
            iconSize: iconSize,
            avatarRadius: avatarRadius,
          ),
          TeamMember(
            name: "Houssem Khalfaoui",
            email: "houssemeddine.khalfaoui@esprit.tn",
            phone: "+216 25 405 325",
            image: "assets/houssem.jpg",
            linkedinUrl: "https://www.linkedin.com/in/houssem-khalfaoui-499389254/",
            nameFontSize: teamMemberNameSize,
            infoFontSize: teamMemberInfoSize,
            linkFontSize: teamMemberLinkSize,
            iconSize: iconSize,
            avatarRadius: avatarRadius,
          ),
          TeamMember(
            name: "Yassine Ajbouni",
            email: "yassine.ajbouni@esprit.tn",
            phone: "+216 23 990 938",
            image: "assets/yassine.jpg",
            linkedinUrl: "https://www.linkedin.com/in/yassine-ajbouni-1616b01a0/",
            nameFontSize: teamMemberNameSize,
            infoFontSize: teamMemberInfoSize,
            linkFontSize: teamMemberLinkSize,
            iconSize: iconSize,
            avatarRadius: avatarRadius,
          ),
        ];

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: basePadding, vertical: screenWidth * 0.075),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: screenWidth * 0.002,
              ),
              borderRadius: BorderRadius.circular(screenWidth * 0.037),
            ),
            padding: EdgeInsets.all(basePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.groups, color: Colors.white, size: titleFontSize),
                    SizedBox(width: screenWidth * 0.02),
                    Text(AppLocalizations.of(context)!.translate("whoWeAre"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: containerSpacing),
                Text(
                    AppLocalizations.of(context)!.translate("aboutUs"),
                  style: TextStyle(color: Colors.white70, fontSize: contentFontSize),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: containerSpacing * 2),
                Text(
  AppLocalizations.of(context)!.translate("contact_us"),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: containerSpacing * 2),
                
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: teamMembers[0]),
                        SizedBox(width: containerSpacing),
                        Expanded(child: teamMembers[1]),
                      ],
                    ),
                    SizedBox(height: containerSpacing * 2),
                    
                    SizedBox(
                      width: screenWidth * 0.5,
                      child: teamMembers[2],
                    ),
                    SizedBox(height: containerSpacing * 2),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: teamMembers[3]),
                        SizedBox(width: containerSpacing),
                        Expanded(child: teamMembers[4]),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TeamMember extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String image;
  final String linkedinUrl;
  final double nameFontSize;
  final double infoFontSize;
  final double linkFontSize;
  final double iconSize;
  final double avatarRadius;

  const TeamMember({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
    required this.linkedinUrl,
    required this.nameFontSize,
    required this.infoFontSize,
    required this.linkFontSize,
    required this.iconSize,
    required this.avatarRadius,
  }) : super(key: key);

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
      padding: EdgeInsets.all(avatarRadius * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(avatarRadius * 0.02),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF29E33C),
                width: avatarRadius * 0.04,
              ),
            ),
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundImage: AssetImage(image),
            ),
          ),
          SizedBox(height: avatarRadius * 0.2),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: nameFontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: avatarRadius * 0.1),

          InkWell(
            onTap: () => _sendEmail(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.email, color: Color(0xFF29E33C), size: iconSize),
                SizedBox(width: avatarRadius * 0.1),
                Flexible(
                  child: Text(
                    email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: infoFontSize,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: avatarRadius * 0.1),

          InkWell(
            onTap: () => _callPhone(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone, color: Color(0xFF29E33C), size: iconSize),
                SizedBox(width: avatarRadius * 0.1),
                Text(
                  phone,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: infoFontSize,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          SizedBox(height: avatarRadius * 0.1),

          InkWell(
            onTap: () => _openLinkedIn(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link, color: Color(0xFF29E33C), size: iconSize),
                SizedBox(width: avatarRadius * 0.1),
                Text(
                  "LinkedIn Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: linkFontSize,
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