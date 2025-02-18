import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:piminnovictus/Models/packs.dart';
import 'package:piminnovictus/Services/AuthController.dart';

class PaymentView extends StatefulWidget {
  final Pack pack;

  const PaymentView({super.key, required this.pack});

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  final _formKey = GlobalKey<FormState>();
  final String currency = "usd";

  // Contrôleurs pour récupérer les entrées utilisateur
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  @override
  void dispose() {
    // Nettoyer les contrôleurs pour éviter les fuites de mémoire
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  Future<void> _makePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    AuthController authController = AuthController();
    try {
      int amount = widget.pack.price.toInt();
      if (amount <= 0) {
        throw Exception("Le montant du pack est invalide !");
      }

      // Obtenir le client_secret depuis le backend
      String? clientSecret = await authController.createPaymentIntent(amount, currency);

      if (clientSecret == null) {
        throw Exception('Impossible de récupérer le client_secret');
      }

      // Initialiser le paiement
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Green Energy',
        ),
      );

      // Afficher le formulaire de paiement Stripe
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paiement réussi ! 🎉")),
      );
    } catch (e) {
      print("Erreur de paiement : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du paiement : ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement Green Energy')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Montant : ${widget.pack.price} USD",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Champ Nom du Titulaire
              TextFormField(
                controller: _cardHolderController,
                decoration: const InputDecoration(labelText: "Nom du titulaire"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer le nom du titulaire";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Champ Numéro de Carte
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: "Numéro de carte"),
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.length != 16) {
                    return "Veuillez entrer un numéro de carte valide (16 chiffres)";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    // Champ Date d'expiration
                    child: TextFormField(
                      controller: _expiryDateController,
                      decoration: const InputDecoration(labelText: "Date d'expiration (MM/AA)"),
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || !RegExp(r"^(0[1-9]|1[0-2])\/\d{2}$").hasMatch(value)) {
                          return "Format invalide (MM/AA)";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    // Champ CVV
                    child: TextFormField(
                      controller: _cvvController,
                      decoration: const InputDecoration(labelText: "CVV"),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.length != 3) {
                          return "CVV invalide (3 chiffres)";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Bouton de paiement
              ElevatedButton(
                onPressed: _makePayment,
                child: const Text("Payer maintenant"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
