import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Views/DashboardClient/ConnectWallet.dart';
import 'package:piminnovictus/Views/DashboardClient/Dashboard.dart';
import 'package:piminnovictus/Views/DashboardClient/Wallet.dart';
import 'package:piminnovictus/Views/Users/EditProfile.dart';
import 'package:provider/provider.dart';
import 'buyEnergie.dart';
import 'energy_settings_sheet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBarExample(),
    );
  }
}

class BottomNavBarExample extends StatefulWidget {
  final String? googleId; // Paramètre googleId ajouté
  const BottomNavBarExample({Key? key, this.googleId}) : super(key: key);

  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  double _currentEnergyPercentage = 0.0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List _pages = [
    DashboardPage(),
    ConnectWalletPage(),
    BuyEnergiePage(),
    Container(),
    EditProfile(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _startLoopAnimation();
  }

  void _startLoopAnimation() {
    Future.doWhile(() async {
      await _animationController.forward();
      await _animationController.reverse();
      await Future.delayed(const Duration(seconds: 3));
      return true;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      EnergySettingsSheet.show(
        context,
        initialPercentage: _currentEnergyPercentage,
        onSave: (newPercentage) {
          setState(() {
            _currentEnergyPercentage = newPercentage;
          });
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildFloatingButton() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
              0,
              -10 *
                  _scaleAnimation
                      .value), // Ajustez le -30 pour modifier la hauteur
          child: Container(
            height: 55 * _scaleAnimation.value, // Taille augmentée
            width: 55 * _scaleAnimation.value, // Taille augmentée
            decoration: BoxDecoration(
              color: _selectedIndex == 2
                  ? const Color(0xFF29E33C).withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                _selectedIndex == 2
                    ? Icons.electric_bolt
                    : Icons.electric_bolt_outlined,
                size: 35, // Taille de l'icône augmentée
                color:
                    _selectedIndex == 2 ? const Color(0xFF29E33C) : Colors.grey,
              ),
              onPressed: () => _onItemTapped(2),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      extendBody: true,
      backgroundColor: isDarkMode ? const Color(0xFF0A140C) : Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        height: 80, // Ajuste selon la taille désirée
        child: Stack(
          clipBehavior: Clip.none, // Important pour laisser le bouton déborder
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(33),
                  topRight: Radius.circular(33),
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor:
                      isDarkMode ? Colors.grey[850] : const Color(0xFFDDECE3),
                  selectedItemColor: const Color(0xFF29E33C),
                  unselectedItemColor: isDarkMode ? Colors.white : Colors.grey,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.wallet),
                      activeIcon: Icon(Icons.account_balance_wallet),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox(
                          height: 30), // Espace réservé pour le bouton flottant
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.percent_sharp),
                      activeIcon: Icon(Icons.percent),
                      label: '',
                    ),
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: '',
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20, // Ajustez cette valeur pour positionner le bouton
              child: Center(
                child: _buildFloatingButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
