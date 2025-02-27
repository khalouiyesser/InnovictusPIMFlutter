import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Services/payment_service%20.dart';
import 'package:piminnovictus/Views/Visitor/card_content.dart';
import 'package:piminnovictus/Views/Visitor/flip_card.dart';
import 'package:piminnovictus/viewmodels/Auth/subscription_view_model.dart';
import 'package:piminnovictus/views/AuthViews/welcome_view.dart';

class SubscriptionCarousel extends StatefulWidget {
  final String? preselectedPackId;
  final String pendingSignupId; // Make sure this is not nullable

  const SubscriptionCarousel(
      {Key? key, this.preselectedPackId, required this.pendingSignupId})
      : super(key: key);

  @override
  State<SubscriptionCarousel> createState() => _SubscriptionCarouselState();
}

class _SubscriptionCarouselState extends State<SubscriptionCarousel> {
  final List<Pack> packs = [
    Pack(
      id: '67bbcb92c538c6915580df58',
      title: 'Basic Pack',
      image: 'assets/panel.png',
      description: 'Unlock energy potential...',
      price: 999,
      panelsCount: '4',
      energyGain: '400kW',
      co2Saved: '200kg',
      certification: 'ISO Certified',
    ),
    Pack(
      id: '67bbcb92c538c6915580df58',
      title: 'Advanced Pack',
      image: 'assets/background.jpg',
      description: 'Track energy live.',
      price: 1999,
      panelsCount: '8',
      energyGain: '800kW',
      co2Saved: '400kg',
      certification: 'ISO Certified',
    ),
    Pack(
      id: '67bbcb92c538c6915580df58',
      title: 'Advanced Pack',
      image: 'assets/background.jpg',
      description: 'Track energy live.',
      price: 1999,
      panelsCount: '8',
      energyGain: '800kW',
      co2Saved: '400kg',
      certification: 'ISO Certified',
    ),
    Pack(
      id: '67bbcb92c538c6915580df58',
      title: 'Advanced Pack',
      image: 'assets/background.jpg',
      description: 'Track energy live.',
      price: 1999,
      panelsCount: '8',
      energyGain: '800kW',
      co2Saved: '400kg',
      certification: 'ISO Certified',
    ),
  ];
  late final SubscriptionViewModel _viewModel;

  String? _selectedPackId;
  @override
  void initState() {
    super.initState();
    _viewModel = SubscriptionViewModel(pendingSignupId: widget.pendingSignupId);
    if (widget.preselectedPackId != null) {
      _viewModel.selectedPackId = widget.preselectedPackId;
    }
  }

  void _selectPack(String packId) {
    setState(() {
      _selectedPackId = _selectedPackId == packs ? null : packId;
    });
  }

  void _proceedToPayment() async {
    if (_viewModel.selectedPackId != null) {
      try {
        // First try to find the pack
        Pack? selectedPack;
        try {
          selectedPack = packs.firstWhere(
            (pack) => pack.id == _viewModel.selectedPackId,
          );
        } catch (e) {
          print('Selected pack ID: ${_viewModel.selectedPackId}');
          print('Available pack IDs: ${packs.map((p) => p.id).toList()}');
          // If pack not found, show error
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 8, 16, 9),
                title: Text(
                  AppLocalizations.of(context).translate('error'),
                  style: TextStyle(color: Colors.white),
                ),
                content:  Text(
                  AppLocalizations.of(context).translate('packNotFound'),
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 31, 219, 59),
                    ),
                    child:  Text(
                      AppLocalizations.of(context).translate('ok'),
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        }

        // If we found the pack, proceed with the API call
        final success = await _viewModel.updatePackForPendingSignup();

        if (success) {
          String packId = "67bbcbabc538c6915580df5a";
          String pendingSignupId = widget.pendingSignupId;
          PaymentService.openPayment(context, packId, pendingSignupId);
        } else {
          // Check if it's the email verification error
          if (_viewModel.error == "EMAIL_VERIFICATION_REQUIRED") {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 8, 16, 9),
                  title: Text(
                    AppLocalizations.of(context).translate('emailConfirmation'),
                  textAlign: TextAlign.center,
                    style:const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      
                      
                    ),
                  ),
                  content:  Text(
                    AppLocalizations.of(context).translate('emailVerificationRequired'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 31, 219, 59),
                      ),
                      child:  Text(
                        AppLocalizations.of(context).translate('ok'),
                        style:const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            // Handle other errors
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: const Color.fromARGB(255, 8, 16, 9),
                  title: Text(
                    AppLocalizations.of(context).translate('error'),
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text(
                    _viewModel.error ?? AppLocalizations.of(context).translate('genericError'),
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 31, 219, 59),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('ok'),
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      } catch (e) {
        print('Error in _proceedToPayment: $e');
      }
    } else {
      // No pack selected dialog remains the same
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 8, 16, 9),
            title:  Text(
              AppLocalizations.of(context).translate('noPackSelected'),
              style: const TextStyle(color: Colors.white),
            ),
            content:  Text(
              AppLocalizations.of(context).translate('selectPackPrompt'),
              style: const TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 31, 219, 59),
                ),
                child: Text(
                        AppLocalizations.of(context).translate('ok'),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                "assets/Pulse.png",
                fit: BoxFit.cover,
              ),
            ),

            // Safe area wrapper for content
            SafeArea(
              child: Column(
                children: [
                  // Header section with fixed padding
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.05,
                      screenWidth * 0.05,
                      0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          AppLocalizations.of(context).translate('selectPack'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Instructions with icons
                        _buildInstructionRow(
                          icon: Icons.flip,
                          text: AppLocalizations.of(context).translate('flipCardInstruction'),
                          screenWidth: screenWidth,
                        ),
                        SizedBox(height: 8),
                        _buildInstructionRow(
                          icon: Icons.touch_app,
                          text: AppLocalizations.of(context).translate('clickSelectInstruction'),
                          screenWidth: screenWidth,
                        ),
                        SizedBox(height: 8),
                        _buildInstructionRow(
                          icon: Icons.check_circle_outline,
                          text: AppLocalizations.of(context).translate('borderIndicationInstruction'),
                          screenWidth: screenWidth,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // GridView with 2 cards per line
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth * 0.04,
                        mainAxisSpacing: screenHeight * 0.02,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: packs.length,
                      itemBuilder: (context, index) {
                        final pack = packs[index];
                        final translatedTitle = AppLocalizations.of(context).translate(pack.title);
                        final translatedDescription = AppLocalizations.of(context).translate(pack.description);
                        
                        return GestureDetector(
                          onTap: () => _selectPack(pack.id),
                          child: FlipCard(
                            front: CardContent(
                              image: pack.image,
                              title: translatedTitle,
                              text: pack.price.toString(),
                              pack: pack,
                              isSelected: _selectedPackId == pack.id,
                            ),
                            back: CardContent(
                              text: translatedDescription,
                              selectButtont: AppLocalizations.of(context).translate('select'),
                              pack: pack,
                              isSelected: _selectedPackId == pack.id,
                              onSelectPressed: () => _selectPack(pack.id),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.05),

                  // Bottom button with responsive padding
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.03,
                      screenWidth * 0.05,
                      screenHeight * 0.05,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.05,
                      child: ElevatedButton(
                        onPressed: _proceedToPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 31, 219, 59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context).translate('proceedToPayment'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionRow({
    required IconData icon,
    required String text,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: screenWidth * 0.05),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
