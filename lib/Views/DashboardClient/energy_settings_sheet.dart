import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/theme_provider.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Providers/language_provider.dart';
import 'package:piminnovictus/viewmodels/profile_switcher_view_model.dart';
import 'package:provider/provider.dart';

class EnergySettingsSheet extends StatefulWidget {
  final double initialPercentage;
  final Function(double) onSave;

  const EnergySettingsSheet({
    Key? key,
    this.initialPercentage = 0.0,
    required this.onSave,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required Function(double) onSave,
  }) async {
    // Afficher un indicateur de chargement pendant la récupération des données
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Récupérer le profileSwitcherViewModel
      final profileSwitcherViewModel = 
          Provider.of<ProfileSwitcherViewModel>(context, listen: false);
      
      // Récupérer le pourcentage de vente actuel via l'API
      final currentPercentage = await profileSwitcherViewModel.getEnergySalePercentage();
      
      // Fermer le dialogue de chargement
      Navigator.pop(context);
      
      // Afficher la bottom sheet avec la valeur récupérée
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return EnergySettingsSheet(
            initialPercentage: currentPercentage,
            onSave: onSave,
          );
        },
      );
    } catch (e) {
      // Fermer le dialogue de chargement en cas d'erreur
      Navigator.pop(context);
      
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la récupération du pourcentage de vente: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  State<EnergySettingsSheet> createState() => _EnergySettingsSheetState();
}

class _EnergySettingsSheetState extends State<EnergySettingsSheet> {
  late double _energyPercentage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _energyPercentage = widget.initialPercentage;
  }

  // Method to save energy sale percentage
  Future<void> _saveEnergySalePercentage(BuildContext context) async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Get the profile switcher view model
      final profileSwitcherViewModel = 
          Provider.of<ProfileSwitcherViewModel>(context, listen: false);
      
      // Call the API to update energy sale percentage
      final success = await profileSwitcherViewModel.updateEnergySalePercentage(_energyPercentage);
      
      if (success) {
        // Call the onSave callback to update UI in parent component
        widget.onSave(_energyPercentage);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Energy sale percentage updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Close the bottom sheet
        Navigator.pop(context);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update energy sale percentage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error saving energy sale percentage: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while updating energy sale percentage'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
  
    final theme = Theme.of(context);

    final themeProvider = Provider.of<ThemeProvider>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Scale factors for fonts and spacing
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
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: screenWidth * 0.05,
            ),
          ),
          

          SizedBox(height: screenHeight * 0.03), // 3% of screen height
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
          SizedBox(height: screenHeight * 0.03), // 3% of screen height
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF29E33C),
              minimumSize: Size(double.infinity, buttonHeight),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            onPressed: _isSaving 
                ? null 
                : () => _saveEnergySalePercentage(context),
            child: _isSaving
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSizeButton,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          SizedBox(height: screenHeight * 0.02), // 2% of screen height
        ],
      ),
    );
  }
}