
import 'package:flutter/material.dart';

class EnergySettingsSheet extends StatefulWidget {
  final double initialPercentage;
  final Function(double) onSave;

  const EnergySettingsSheet({
    Key? key,
    this.initialPercentage = 0.0,
    required this.onSave,
  }) : super(key: key);

  static void show(BuildContext context, {
    double initialPercentage = 0.0,
    required Function(double) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 16, 34, 26),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(
color: Colors.white.withOpacity(0.11),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Set Your Energy Sale Percentage',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                onPressed: () {
                  setState(() {
                    if (_energyPercentage > 0) {
                      _energyPercentage -= 5;
                    }
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_energyPercentage.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.white),
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
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF29E33C),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              widget.onSave(_energyPercentage);
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}