import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/bachground.dart';
import 'package:provider/provider.dart';
// Import correct pour la classe User personnalisée
import 'package:piminnovictus/Models/User.dart';

const kGreen = Color(0xFF29E33C);
const double padding = 16.0;

class ConnectWalletPage extends StatefulWidget {
  const ConnectWalletPage({Key? key}) : super(key: key);

  @override
  _ConnectWalletPageState createState() => _ConnectWalletPageState();
}

class _ConnectWalletPageState extends State<ConnectWalletPage> {
  final SessionManager _sessionManager = SessionManager();
  User? currentUser;
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _secretKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _secretKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await _sessionManager.getCurrentUser();
    if (user != null) {
      setState(() {
        currentUser = user;
      });
    }
  }

  void _showConnectWalletModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header avec titre
                      Center(
                        child: Container(
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Connect Your Wallet",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: kGreen,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Champ API Key
                      Text(
                        "API Key",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _apiKeyController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: kGreen,
                              width: 2,
                            ),
                          ),
                          hintText: "Enter your API key",
                          prefixIcon: Icon(
                            Icons.vpn_key_rounded,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Champ Secret Key
                      Text(
                        "Secret Key",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _secretKeyController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: kGreen,
                              width: 2,
                            ),
                          ),
                          hintText: "Enter your secret key",
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Bouton de confirmation
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Ajouter ici la logique de connexion au wallet
                            // Vous pouvez traiter _apiKeyController.text et _secretKeyController.text
                            Navigator.pop(context);

                            // Afficher un snackbar de confirmation
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Wallet successfully connected!'),
                                backgroundColor: kGreen,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Confirm",
                            style: TextStyle(
                              backgroundColor: const Color(0xFF29E33C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      // Placer le BlurredRadialBackground directement comme contenu principal
      body: BlurredRadialBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(0),
                ),
                // Header (avatar + nom)
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(
                        'assets/user.jpg',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: currentUser == null
                          ? const CircularProgressIndicator()
                          : Text(
                              currentUser!.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Solde principal centré et responsive (placeholder)
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),

                const SizedBox(height: 24),

                // Titre créatif au-dessus du bouton
                Center(
                  child: Text(
                    "Don't have a Grenno Wallet yet?\nTap here to ignite your digital energy!",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bouton de connexion modifié pour ouvrir le modal
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap:
                          _showConnectWalletModal, // Appel de la fonction pour afficher le modal
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth * 0.7,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              color: theme.cardColor.withOpacity(0.70),
                              border: Border.all(
                                color:
                                    theme.colorScheme.primary.withOpacity(0.11),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "Connect To The Wallet",
                                style: TextStyle(
                                  color: kGreen,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: screenWidth * 0.04,
                              color: theme.textTheme.titleMedium?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Carte documentaire explicative du Grenno Wallet
                Card(
                  color: theme.cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: kGreen, // Couleur de la bordure
                      width: 0, // Épaisseur de la bordure
                    ),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Principe du Grenno Wallet",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 9),
                        Center(
                          child: Text(
                            "1 GRN = 250 millimes = 0.25 DT",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            "Transférez votre énergie et gagnez\n                des coins Grenno !",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Ajouter un espace en bas pour s'assurer que le fond couvre toute la page
                SizedBox(height: MediaQuery.of(context).size.height * 0.5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
