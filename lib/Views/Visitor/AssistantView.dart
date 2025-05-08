import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'dart:async';

class AssistantView extends StatefulWidget {
  const AssistantView({Key? key}) : super(key: key);

  @override
  State<AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends State<AssistantView>
    with WidgetsBindingObserver {
  late AuthScreenTheme _theme;
  int _currentImageIndex = 0;
  late Timer _imageTimer;

  final List<String> _images = [
    'assets/assist1.jpg',
    'assets/assist2.jpg',
    'assets/assist3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _updateTheme();
    // S'enregistre pour écouter les changements de luminosité du système
    WidgetsBinding.instance.addObserver(this);

    // Démarre le timer pour changer l'image toutes les 5 secondes
    _imageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _currentImageIndex = (_currentImageIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    // Annuler le timer avant de détruire le widget
    _imageTimer.cancel();
    // Supprimer l'observateur avant la destruction
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Mettre à jour le thème quand la luminosité du système change
    if (mounted) {
      setState(() {
        _updateTheme();
      });
    }
  }

  void _updateTheme() {
    _theme = AuthScreenThemeDetector.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _theme.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background avec dégradé - identique à LoginView
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _theme.backgroundGradientColors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: isDarkMode
                  ? Image.asset("assets/Pulse.png", fit: BoxFit.cover)
                  : null, // Utilise l'image uniquement en mode sombre
            ),
          ),

          // Contenu de la page
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Espace pour l'AppBar
              SizedBox(
                  height: AppBar().preferredSize.height +
                      MediaQuery.of(context).padding.top),

              // Carrousel d'images
              SizedBox(
                height: screenHeight * 0.35, // 35% de la hauteur de l'écran
                width: screenWidth,
                child: Stack(
                  children: [
                    // Image actuelle
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: Container(
                        key: ValueKey<int>(_currentImageIndex),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            _images[_currentImageIndex],
                            fit: BoxFit.cover,
                            // Utiliser une image par défaut en cas d'erreur
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Indicateurs de position
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _images.length,
                          (index) => Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? const Color(0xFF29E33C) // Vert actif
                                  : Colors.white.withOpacity(
                                      0.5), // Blanc semi-transparent
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Titre de bienvenue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Text(
                  "Welcome to GreenEnergy Assistant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _theme.textColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: _theme.textColor.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}
