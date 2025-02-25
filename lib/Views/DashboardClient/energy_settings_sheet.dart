import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:provider/provider.dart';

class EnergySettingsSheet extends StatefulWidget {
  final double initialPercentage;
  final Function(double) onSave;

  const EnergySettingsSheet({
    Key? key,
    this.initialPercentage = 0.0,
    required this.onSave,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    double initialPercentage = 0.0,
    required Function(double) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled:
          true, // Permet à la feuille de s'adapter à la taille de l'écran
      builder: (BuildContext context) {
        return EnergySettingsSheet(
          initialPercentage: initialPercentage,
          onSave: onSave,
        );
      },
    );
  }

  @override
  State<EnergySettingsSheet> createState() => _EnergySettingsSheetState();
}

class _EnergySettingsSheetState extends State<EnergySettingsSheet> {
  late double _energyPercentage;

  @override
  void initState() {
    super.initState();
    _energyPercentage = widget.initialPercentage;
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
  
    final theme = Theme.of(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Facteurs d'échelle pour les polices et les espacements
    final double fontSizeTitle = screenWidth * 0.05;
    final double fontSizePercentage = screenWidth * 0.06;
    final double fontSizeButton = screenWidth * 0.04;
    final double paddingHorizontal = screenWidth * 0.05;
    final double paddingVertical = screenHeight * 0.02;
    final double iconSize = screenWidth * 0.08;
    final double buttonHeight = screenHeight * 0.06;
    final double borderRadius = screenWidth * 0.1;
    return Container(
      width: MediaQuery.of(context).size.width, // 90% of the screen width

      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.light
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF93DAB2).withOpacity(0.9),
                  Colors.white.withOpacity(0.9),
                ],
              )
            : null,
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF0D0F0D)
            : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.11),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
                        AppLocalizations.of(context).translate("setEnergySalePercentage"),
                        textAlign:TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: screenWidth * 0.05,
              ),
            ),
          

          SizedBox(height: screenHeight * 0.03), // 3% de la hauteur de l'écran
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  size: iconSize,
                ),
                onPressed: () {
                  setState(() {
                     if (_energyPercentage > 0) {
        _energyPercentage -= 5;
      }
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: paddingHorizontal,
                ),
                child: Text(
                  '${_energyPercentage.toInt()}%',
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    fontSize: fontSizePercentage,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                  size: iconSize,
                ),
                onPressed: () {
                  setState(() {
                    if (_energyPercentage < 100) {
                      _energyPercentage += 5;
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03), // 3% de la hauteur de l'écran
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF29E33C),
              minimumSize: Size(double.infinity, buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            onPressed: () {
              widget.onSave(_energyPercentage);
              Navigator.pop(context);
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSizeButton,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // 2% de la hauteur de l'écran
        ],
      ),
    );
  }
}
