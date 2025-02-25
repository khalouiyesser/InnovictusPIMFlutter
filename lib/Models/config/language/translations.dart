import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    // Profile Section
    'profileInformation': 'Profile Informations',
    'personalInformation': 'Personal Informations',
    'username': 'Username',
    'email': 'Email',
    'phone': 'Phone',
    'password': 'Password',
    'currentPassword': 'Current Password',
    'newPassword': 'New Password',
    'confirmPassword': 'Confirm Password',
    
    // Preferences Section
    'preferences': 'Preferences',
    'darkMode': 'Dark Mode',
    'language': 'Language',
    'english': 'English',
    'french': 'French',
    
    // Terms & Privacy Section
    'termsAndPrivacy': 'Terms & Privacy',
    'termsAndConditions': 'Terms & Conditions',
    'privacyPolicy': 'Privacy Policy',
    
    // Actions & Buttons
    'save': 'Save',
    'logout': 'Logout',
    'logoutmsg' : 'Do you really want to log out?',
    'cancel' : 'Cancel',
        'footerText': 'GreenEnergyChain. All rights reserved.',

     // Terms and Conditions Screen
    'termsTitle': 'Terms and Conditions',
    'understand': 'I Understand',
    'termsContent': '''Welcome to GreenEnergyChain, a blockchain-based platform dedicated to the management and trading of renewable energy. By accessing or using our platform, you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully before using our services.

1. Acceptance of Terms
By using GreenEnergyChain, you agree to these Terms and Conditions, our Privacy Policy, and all applicable laws and regulations in Tunisia. If you do not agree with any part of these terms, you must not use our platform.

2. Description of Services
GreenEnergyChain provides a decentralized marketplace for the trading of renewable energy using blockchain technology.

3. User Accounts
- Registration: To use our services, you must create an account.
- Security: You are responsible for maintaining account security.
- Eligibility: You must be at least 18 years old.

4. Privacy and Data Security
Your privacy is important to us. Please refer to our Privacy Policy.

5. Contact Information
For questions or concerns, please contact support@greenenergychain.com''',


//privacy policy 

'privacyPolicyContent': '''Privacy Policy for GreenEnergyChain (Tunisia)

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

By using GreenEnergyChain, you acknowledge that you have read, understood, and agree to these Terms and Conditions and Privacy Policy. Thank you for choosing GreenEnergyChain for your renewable energy needs.''',

// Profile Selection Screen
  'selectProfile': 'Select a profile',
  'recentUsers': 'Recent users',
  'noRecentUsers': 'No recent users',
  'unknownUser': 'Unknown User',
  'unknownEmail': 'Unknown email',
  'lastSeen': 'Last seen',
  'daysAgo': '{} day(s) ago',
  'hoursAgo': '{} hour(s) ago',
  'minutesAgo': '{} minute(s) ago',
  'switchProfileConfirm': 'Do you really want to switch to profile "{}"?',
'createNewProfile': 'Create New Profile',
'viewAllProfiles': 'View All Profiles',
    'welcomeBack': 'Welcome Back!',
    "energyUsages": "Energy Usages",
    "totalEnergy": "Total Energy",
    "consumed": "Consumed",
    "capacity": "Capacity",
    "co2Reduction": "CO2 Reduction",
    "electricityGenerated": "Electricity Generated by Solar",
    "kwh": "kWh",
    "today": "Today",
    "location": "Location",
  "walletOverview": "Wallet Overview",
    "listOfTransaction": "List of Transaction",
    "coinsActivityTracking": "Coins Activity Tracking",
    "send": "Send",
    "receive": "Receive",
    "buy": "Buy",
    "less": "Less",
    "more": "More",
    "mon": "Mon",
    "tue": "Tue",
    "wed": "Wed",
    "thu": "Thu",
    "fri": "Fri",
    "sat": "Sat",
    "sun": "Sun",
        "wallet":"Wallet",
        'month': 'Month',
'twoWeeks': '2 Weeks',
'week': 'Week',


  "power_home_title": "Power your home with clean energy!",
  "total_energy": "Total Energy",
  "get_started_steps": "Get Started in 3 Steps",
  "enter_energy_quantity": "Enter Energy Quantity",
  "enter_quantity_hint": "Enter quantity in KW",
  "equivalent_coins": "Equivalent in Coins: {coin}",
  "enter_code": "Enter your Code",
  "payment_success": "Your payment with coins has been successfully processed. Thank you for choosing clean solar energy!",
  "check_email": "Check your email for the details!",
  "back": "Back",
  "next": "Next",

   "purchase_successful": "Purchase Successful",
  "purchased_amount": "You have purchased {amount} kWh of solar energy.",
  "energy_generating": "Your energy is being generated...",
  "back_to_home": "Back to Home",
    'setEnergySalePercentage': 'Set the percentage of your energy reserved for sale',

  "titleall": "All our Packs and Offers",

"view_all_packs_offers": "View all packs & offers",
   "energy_intro_1": "For too long, energy has been controlled by ",
  "energy_intro_2": "monopoly.",

  // Deuxième paragraphe
  "energy_what_if_1": "What if ",
  "energy_what_if_2": "YOU",
  "energy_what_if_3": " could ",
  "energy_what_if_4": "produce, sell, trade",
  "energy_what_if_5": " renewable energy ",
  "energy_what_if_6": "freely and securely ?",

  // Troisième paragraphe
  "green_energy_tagline": "⚡ GreenEnergy makes it possible ! ",

  // Quatrième paragraphe
  "tech_description_1": "With ",
  "tech_description_2": "smart grids + blockchain ",
  "tech_description_3": ", we are ",
  "tech_description_4": "decentralizing ",
  "tech_description_5": "Tunisia's energy market, empowering individuals and businesses to ",
  "tech_description_6": "take control.",
  "feature_steg": "No more reliance on STEG.",
  "feature_selling": "Sell your excess solar energy directly to others.",
  "feature_ai_iot": "AI + IoT optimize energy flow in real-time.",
  "feature_blockchain": "Blockchain ensures 100% secure & transparent transactions.",
  "feature_green_impact": "Earn certified proof of your green impact & reduce carbon emissions.",
  "energy_revolution_title": "The Energy Revolution Starts Now !",


"power_up_packs": "Power Up with Our Exclusive Packs",
  "choose_perfect_plan": "Choose the Perfect Plan & Take Control of Your Energy!",
  "flexible_solutions": "Flexible, transparent, and built for YOU! Whether you’re an individual, a business, or a large enterprise, GreenEnergyChain offers tailored solutions to maximize your energy efficiency and savings.",
  "ready_to_leap": "Ready to take the leap? Tap \"Account Creation\" and start your energy revolution today!",
  "details": "Details",
  "get_it": "Get It",
  "achievement_section_title": "Our GreenEnergyChain Community and Achievements",
  "regular_users": "Regular Users",
  "enterprise_users": "Enterprise Users",
  "carbon_footprint_certified": "Carbon Footprint Certified",
  "installed_solar_panels": "Installed Solar Panels",
  "whoWeAre": "Who We Are?",
  "aboutUs": "We are a team of passionate engineers committed to creating innovative solutions for a sustainable future. Our mission is to revolutionize the energy landscape in Tunisia by offering a real, impactful solution that supports the environment. Through GreenEnergyChain, we aim to reduce reliance on fossil fuels, promote renewable energy, and empower communities with smart, decentralized energy systems. Together, we are shaping a greener, more sustainable world.",
"contact_us": "Contact Us",
"pack_details": "Pack Details",
  "title": "Title",
  "description": "Description",
  "price": "Price",
  "duration": "Duration",
  "features": "Features",
  "select": "Select",
  "available_packs": "Available Packs",
  "subscribe": "Subscribe",
  "confirm": "Confirm",
  "loading": "Loading...",
  "error_occurred": "An error occurred",
  "try_again": "Try Again",
  "energy_gain": "Energy Gained",
  "co2_saved": "Fossil Fuel Avoided",
  "certification": "Certification",
  "solar_panels": "Solar Panels",
  "pack_details_every": "Everything about {title}!",
  "search_hint": "Search Packs & Offers ...",
  "no_results": "No results found"













  },

  'fr': {
    // Profile Section
    'profileInformation': 'Informations du Profil',
    'personalInformation': 'Informations Personnelles',
    'username': 'Nom d\'utilisateur',
    'email': 'E-mail',
    'phone': 'Téléphone',
    'password': 'Mot de passe',
    'currentPassword': 'Mot de passe actuel',
    'newPassword': 'Nouveau mot de passe',
    'confirmPassword': 'Confirmer le mot de passe',
    
    // Preferences Section
    'preferences': 'Préférences',
    'darkMode': 'Mode Sombre',
    'language': 'Langue',
    'english': 'Anglais',
    'french': 'Français',
    
    // Terms & Privacy Section
    'termsAndPrivacy': 'Conditions et Confidentialité',
    'termsAndConditions': 'Conditions Générales',
    'privacyPolicy': 'Politique de Confidentialité',
    
    // Actions & Buttons
    'save': 'Enregistrer',
    'logout': 'Déconnexion',
    'logoutmsg' : 'Voulez-vous vraiment vous déconnecter?',
    'cancel' : 'Annuler',
    'footerText': 'GreenEnergyChain. Tous droits réservés.',

        // Terms and Conditions Screen
 'termsTitle': 'Conditions Générales',
    'understand': 'J\'ai Compris',
    'termsContent': '''Bienvenue sur GreenEnergyChain, une plateforme basée sur la blockchain dédiée à la gestion et au commerce d'énergie renouvelable. En accédant ou en utilisant notre plateforme, vous acceptez de vous conformer et d'être lié par les Conditions Générales suivantes. Veuillez les lire attentivement avant d'utiliser nos services.

1. Acceptation des Conditions
En utilisant GreenEnergyChain, vous acceptez ces Conditions Générales, notre Politique de Confidentialité et toutes les lois et réglementations applicables en Tunisie. Si vous n'êtes pas d'accord avec une partie de ces conditions, vous ne devez pas utiliser notre plateforme.

2. Description des Services
GreenEnergyChain fournit une place de marché décentralisée pour le commerce d'énergie renouvelable utilisant la technologie blockchain.

3. Comptes Utilisateurs
- Inscription : Pour utiliser nos services, vous devez créer un compte.
- Sécurité : Vous êtes responsable du maintien de la sécurité du compte.
- Éligibilité : Vous devez avoir au moins 18 ans.

4. Confidentialité et Sécurité des Données
Votre confidentialité est importante pour nous. Veuillez consulter notre Politique de Confidentialité.

5. Informations de Contact
Pour toute question ou préoccupation, veuillez contacter support@greenenergychain.com''',


//privacy policy screen

'privacyPolicyContent': '''Politique de Confidentialité de GreenEnergyChain (Tunisie)

Date d'entrée en vigueur : 01-02-2025

GreenEnergyChain s'engage à protéger votre vie privée. Cette Politique de Confidentialité décrit comment nous collectons, utilisons et protégeons vos informations personnelles lorsque vous utilisez notre plateforme.

1. Informations que nous collectons
• Informations personnelles : Nom, adresse e-mail, numéro de téléphone et autres informations fournies lors de l'inscription.
• Données de transaction : Détails des transactions effectuées sur la plateforme, y compris l'énergie échangée et les GEC utilisés.
• Données IoT : Données de production d'énergie en temps réel collectées via des dispositifs IoT.
• Données d'utilisation : Informations sur la manière dont vous interagissez avec la plateforme, y compris les adresses IP, les types de navigateur et les heures d'accès.

2. Utilisation des informations
Nous utilisons les informations collectées pour :
• Fournir et améliorer nos services.
• Faciliter les transactions et les contrats intelligents.
• Suivre et optimiser la production et la consommation d'énergie.
• Assurer la sécurité et l'intégrité de la plateforme.
• Communiquer avec vous sur les mises à jour, promotions et support.

3. Partage des données
Nous ne vendons ni ne louons vos informations personnelles à des tiers. Cependant, nous pouvons partager des informations avec :
• Prestataires de services : Fournisseurs tiers qui assistent dans les opérations de la plateforme.
• Autorités légales : Lorsque requis par la loi ou pour protéger nos droits et notre sécurité.
• Transferts d'entreprise : En cas de fusion, acquisition ou vente d'actifs.

4. Sécurité des données
Nous mettons en place des mesures de sécurité rigoureuses pour protéger vos données contre tout accès non autorisé, modification ou destruction. Ces mesures comprennent le chiffrement, des serveurs sécurisés et des contrôles d'accès.

5. Droits des utilisateurs
• Accès : Vous pouvez demander l'accès aux informations personnelles que nous détenons sur vous.
• Correction : Vous pouvez demander des corrections pour toute information inexacte ou incomplète.
• Suppression : Vous pouvez demander la suppression de vos informations personnelles, sous réserve des obligations légales.

6. Cookies et suivi
Nous utilisons des cookies et des technologies similaires pour améliorer votre expérience sur notre plateforme. Vous pouvez gérer vos préférences en matière de cookies via les paramètres de votre navigateur.

7. Transferts internationaux
Vos informations peuvent être transférées et traitées dans des pays hors de la Tunisie, où les lois sur la protection des données peuvent être différentes. Nous veillons à ce que des garanties appropriées soient en place pour protéger vos données.

8. Modifications de la Politique de Confidentialité
Nous pouvons mettre à jour cette Politique de Confidentialité de temps en temps. Toute modification sera publiée sur la plateforme, et votre utilisation continue constitue une acceptation de la politique révisée.

9. Informations de contact
Pour toute question ou préoccupation concernant cette Politique de Confidentialité, veuillez nous contacter à [Insérer les informations de contact].

En utilisant GreenEnergyChain, vous reconnaissez avoir lu, compris et accepté ces Conditions Générales et cette Politique de Confidentialité. Merci de choisir GreenEnergyChain pour vos besoins en énergie renouvelable.''',

// Profile Selection Screen
  'selectProfile': 'Sélectionner un profil',
  'recentUsers': 'Utilisateurs récents',
  'noRecentUsers': 'Aucun utilisateur récent',
  'unknownUser': 'Utilisateur inconnu',
  'unknownEmail': 'Email inconnu',
  'lastSeen': 'Dernière connexion',
  'daysAgo': 'Il y a {} jour(s)',
  'hoursAgo': 'Il y a {} heure(s)',
  'minutesAgo': 'Il y a {} minute(s)',
  'switchProfileConfirm': 'Voulez-vous vraiment passer au profil "{}" ?',
'createNewProfile': 'Créer un nouveau profil',

'viewAllProfiles': 'Voir tous les profils',
    'welcomeBack': 'Bienvenue',


     "energyUsages": "Consommation d'énergie",
    "totalEnergy": "Énergie totale",
    "consumed": "Consommée",
    "capacity": "Capacité",
    "co2Reduction": "Réduction de CO2",
    "electricityGenerated": "Électricité générée par le solaire",
    "kwh": "kWh",
    "today": "Aujourd'hui",
    "location": "Localisation",
     "wallet" : "Portefeuille",
    "walletOverview": "Aperçu du portefeuille",
    "listOfTransaction": "Liste des transactions",
    "coinsActivityTracking": "Suivi d'activité des jetons",
    "send": "Envoyer",
    "receive": "Recevoir",
    "buy": "Acheter",
    "less": "Moins",
    "more": "Plus",
    "mon": "Lun",
    "tue": "Mar",
    "wed": "Mer",
    "thu": "Jeu",
    "fri": "Ven",
    "sat": "Sam",
    "sun": "Dim",
    'month': 'Mois',
'twoWeeks': '2 Semaines',
'week': 'Semaine',

 "power_home_title": "Alimentez votre maison avec de l'énergie propre !",
  "total_energy": "Énergie Totale",
  "get_started_steps": "Commencez en 3 étapes",
  "enter_energy_quantity": "Entrez la quantité d'énergie",
  "enter_quantity_hint": "Entrez la quantité en KW",
  "equivalent_coins": "Équivalent en Pièces : {coin}",
  "enter_code": "Entrez votre code",
  "payment_success": "Votre paiement a été traité avec succès. Merci d'avoir choisi l'énergie solaire propre !",
  "check_email": "Vérifiez votre email pour les détails !",
  "back": "Retour",
  "next": "Suivant",
  "purchase_successful": "Achat Réussi",
  "purchased_amount": "Vous avez acheté {amount} kWh d'énergie solaire.",
  "energy_generating": "Votre énergie est en cours de génération...",
  "back_to_home": "Retour à l'Accueil",
    'setEnergySalePercentage': 'Définissez le pourcentage de votre énergie réservé à la vente',

    "view_all_packs_offers": "Voir tous les packs et offres",
  "energy_intro_1": "Pendant trop longtemps, l'énergie a été contrôlée par un ",
  "energy_intro_2": "monopole.",

  // Deuxième paragraphe
  "energy_what_if_1": "Et si ",
  "energy_what_if_2": "VOUS",
  "energy_what_if_3": " pouviez ",
  "energy_what_if_4": "produire, vendre, échanger",
  "energy_what_if_5": " de l'énergie renouvelable ",
  "energy_what_if_6": "librement et en toute sécurité ?",

  // Troisième paragraphe
  "green_energy_tagline": "⚡ GreenEnergy rend cela possible ! ",

  // Quatrième paragraphe
  "tech_description_1": "Avec les ",
  "tech_description_2": "réseaux intelligents + la blockchain ",
  "tech_description_3": ", nous ",
  "tech_description_4": "décentralisons ",
  "tech_description_5": "le marché de l'énergie en Tunisie, permettant aux individus et aux entreprises de ",
  "tech_description_6": "prendre le contrôle.",
 "feature_steg": "Plus de dépendance à la STEG.",
  "feature_selling": "Vendez votre excédent d'énergie solaire directement à d'autres.",
  "feature_ai_iot": "L'IA + l'IoT optimisent le flux d'énergie en temps réel.",
  "feature_blockchain": "La blockchain garantit des transactions 100% sécurisées et transparentes.",
  "feature_green_impact": "Obtenez une preuve certifiée de votre impact écologique et réduisez les émissions de carbone.",
  "energy_revolution_title": "La Révolution Énergétique Commence Maintenant !",
"power_up_packs": "Boostez votre énergie avec nos packs exclusifs",
  "choose_perfect_plan": "Choisissez le plan parfait et prenez le contrôle de votre énergie !",
  "flexible_solutions": "Flexible, transparent et conçu pour VOUS ! Que vous soyez un particulier, une entreprise ou une grande société, GreenEnergyChain propose des solutions adaptées pour maximiser votre efficacité énergétique et vos économies.",
  "ready_to_leap": "Prêt à franchir le pas ? Appuyez sur \"Création de compte\" et commencez votre révolution énergétique dès aujourd'hui !",
  "details": "Détails",
  "get_it": "Obtenez-le",
  
  "achievement_section_title": "Notre communauté GreenEnergyChain et ses réalisations",
  "regular_users": "Utilisateurs réguliers",
  "enterprise_users": "Entreprises",
  "carbon_footprint_certified": "Empreinte carbone certifiée",
  "installed_solar_panels": "Panneaux solaires installés",
    "whoWeAre": "Qui sommes-nous ?",
  "aboutUs": "Nous sommes une équipe d'ingénieurs passionnés, engagés à créer des solutions innovantes pour un avenir durable. Notre mission est de révolutionner le paysage énergétique en Tunisie en proposant une solution réelle et impactante qui soutient l’environnement. Grâce à GreenEnergyChain, nous visons à réduire la dépendance aux combustibles fossiles, promouvoir les énergies renouvelables et autonomiser les communautés avec des systèmes énergétiques intelligents et décentralisés. Ensemble, nous façonnons un monde plus vert et plus durable.",
"contact_us": "Contactez-nous",
"pack_details": "Détails du Pack",
  "title": "Titre",
  "description": "Description",
  "price": "Prix",
  "duration": "Durée",
  "features": "Caractéristiques",
  "select": "Sélectionner",
  "available_packs": "Packs Disponibles",
  "subscribe": "S'abonner",
  "confirm": "Confirmer",
  "energy_gain": "Énergie Gagnée",
  "co2_saved": "Fossile Évitée",
  "certification": "Certification",
    "solar_panels": "Panneaux Solaires",
  "pack_details_every": "Tout sur {title} !",
 "search_hint": "Rechercher des Packs et Offres ...",
  "no_results": "Aucun résultat trouvé",
    "titleall": "Tous nos Packs et Offres",


},
};

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['en']?[key] ?? 
           key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return Future.value(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}