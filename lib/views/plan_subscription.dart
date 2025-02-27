// import 'package:flutter/material.dart';
// import 'package:piminnovictus/Models/packs.dart';
// import 'package:piminnovictus/Views/Visitor/card_content.dart';
// import 'package:piminnovictus/Views/Visitor/flip_card.dart';
//
// class SubscriptionCarousel extends StatefulWidget {
//   final String? preselectedPackId;
//
//   const SubscriptionCarousel({Key? key, this.preselectedPackId}) : super(key: key);
//
//   @override
//   State<SubscriptionCarousel> createState() => _SubscriptionCarouselState();
// }
//
// class _SubscriptionCarouselState extends State<SubscriptionCarousel> {
//   final List<Pack> packs = [
//     Pack(
//       id: '1',
//       title: 'Basic Pack',
//       image: 'assets/panel.png',
//       description: 'Unlock energy potential...',
//       price: '999',
//       panelsCount: '4',
//       energyGain: '400kW',
//       co2Saved: '200kg',
//       certification: 'ISO Certified',
//     ),
//     Pack(
//       id: '2',
//       title: 'Advanced Pack',
//       image: 'assets/background.jpg',
//       description: 'Track energy live.',
//       price: '1999',
//       panelsCount: '8',
//       energyGain: '800kW',
//       co2Saved: '400kg',
//       certification: 'ISO Certified',
//     ),
//     Pack(
//       id: '3',
//       title: 'Advanced Pack',
//       image: 'assets/background.jpg',
//       description: 'Track energy live.',
//       price: '1999',
//       panelsCount: '8',
//       energyGain: '800kW',
//       co2Saved: '400kg',
//       certification: 'ISO Certified',
//     ),
//     Pack(
//       id: '4',
//       title: 'Advanced Pack',
//       image: 'assets/background.jpg',
//       description: 'Track energy live.',
//       price: '1999',
//       panelsCount: '8',
//       energyGain: '800kW',
//       co2Saved: '400kg',
//       certification: 'ISO Certified',
//     ),
//   ];
//
//   String? _selectedPackId;
//
//   @override
//   void initState() {
//     super.initState();
//     _selectedPackId = widget.preselectedPackId;
//   }
//
//   void _selectPack(String packId) {
//     setState(() {
//       _selectedPackId = _selectedPackId == packId ? null : packId;
//     });
//   }
//
//   void _proceedToPayment() {
//     if (_selectedPackId != null) {
//       print('Proceeding to payment with pack ID: $_selectedPackId');
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             backgroundColor: const Color.fromARGB(255, 8, 16, 9),
//             title: const Text(
//               'No Pack Selected',
//               style: TextStyle(color: Colors.white),
//             ),
//             content: const Text(
//               'You must select a pack before proceeding to payment.',
//               style: TextStyle(color: Colors.white),
//             ),
//             actions: <Widget>[
//               TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: Color.fromARGB(255, 31, 219, 59),
//                 ),
//                 child: const Text(
//                   'OK',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//     final screenHeight = screenSize.height;
//     final screenWidth = screenSize.width;
//
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             // Background image
//             Positioned.fill(
//               child: Image.asset(
//                 "assets/Pulse.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             // Safe area wrapper for content
//             SafeArea(
//               child: Column(
//                 children: [
//                   // Header section with fixed padding
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(
//                       screenWidth * 0.05,
//                       screenHeight * 0.05,
//                       screenWidth * 0.05,
//                       0,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Title
//                         Text(
//                           "Select the pack you want to buy",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.06,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         SizedBox(height: screenHeight * 0.03),
//
//                         // Instructions with icons
//                         _buildInstructionRow(
//                           icon: Icons.flip,
//                           text: 'Flip a pack card to see more details',
//                           screenWidth: screenWidth,
//                         ),
//                         SizedBox(height: 8),
//                         _buildInstructionRow(
//                           icon: Icons.touch_app,
//                           text: 'Click the "Select" button to choose a pack',
//                           screenWidth: screenWidth,
//                         ),
//                         SizedBox(height: 8),
//                         _buildInstructionRow(
//                           icon: Icons.check_circle_outline,
//                           text: 'Selected pack will have a green border',
//                           screenWidth: screenWidth,
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   SizedBox(height: screenHeight * 0.03),
//
//                   // GridView with 2 cards per line
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
//                     child: GridView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: screenWidth * 0.04,
//                         mainAxisSpacing: screenHeight * 0.02,
//                         childAspectRatio: 0.75,
//                       ),
//                       itemCount: packs.length,
//                       itemBuilder: (context, index) {
//                         final pack = packs[index];
//                         return GestureDetector(
//                           onTap: () => _selectPack(pack.id),
//                           child: FlipCard(
//                             front: CardContent(
//                               image: pack.image,
//                               title: pack.title,
//                               text: pack.price,
//                               pack: pack,
//                               isSelected: _selectedPackId == pack.id,
//                             ),
//                             back: CardContent(
//                               text: pack.description,
//                               selectButtont: 'Select',
//                               pack: pack,
//                               isSelected: _selectedPackId == pack.id,
//                               onSelectPressed: () => _selectPack(pack.id),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 SizedBox(height: screenHeight * 0.05),
//
//                   // Bottom button with responsive padding
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(
//                       screenWidth * 0.05,
//                       screenHeight * 0.03,
//                       screenWidth * 0.05,
//                       screenHeight * 0.05,
//                     ),
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: screenHeight * 0.05,
//                       child: ElevatedButton(
//                         onPressed: _proceedToPayment,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color.fromARGB(255, 31, 219, 59),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: Text(
//                           "Proceed to Payment",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: screenWidth * 0.045,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInstructionRow({
//     required IconData icon,
//     required String text,
//     required double screenWidth,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.white, size: screenWidth * 0.05),
//         SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: screenWidth * 0.04,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Services/payment_service%20.dart';
import 'package:piminnovictus/Views/Visitor/card_content.dart';
import 'package:piminnovictus/Views/Visitor/flip_card.dart';
import 'package:piminnovictus/Views/stripe.dart';
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
      id: '67bf583d11b99e1b6875689f',
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
      id: '67bf583d11b99e1b6875689f',
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
      id: '67bf583d11b99e1b6875689f',
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
      id: '67bf583d11b99e1b6875689f',
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
                title: const Text(
                  'Error',
                  style: TextStyle(color: Colors.white),
                ),
                content: const Text(
                  'Selected pack not found in available packs.',
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 31, 219, 59),
                    ),
                    child: const Text(
                      'OK',
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
          String packId = "67bf583d11b99e1b6875689f";
          String pendingSignupId = widget.pendingSignupId;
          PaymentService.openPayment(context, packId, pendingSignupId);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 8, 16, 9),
                title: const Text(
                  'Error',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  _viewModel.error ?? 'An error occurred',
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 31, 219, 59),
                    ),
                    child: const Text(
                      'OK',
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
      } catch (e) {
        print('Error in _proceedToPayment: $e');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 8, 16, 9),
            title: const Text(
              'No Pack Selected',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'You must select a pack before proceeding to payment.',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 31, 219, 59),
                ),
                child: const Text(
                  'OK',
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
                          "Select the pack you want to buy",
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
                          text: 'Flip a pack card to see more details',
                          screenWidth: screenWidth,
                        ),
                        SizedBox(height: 8),
                        _buildInstructionRow(
                          icon: Icons.touch_app,
                          text: 'Click the "Select" button to choose a pack',
                          screenWidth: screenWidth,
                        ),
                        SizedBox(height: 8),
                        _buildInstructionRow(
                          icon: Icons.check_circle_outline,
                          text: 'Selected pack will have a green border',
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
                        return GestureDetector(
                          onTap: () => _selectPack(pack.id),
                          child: FlipCard(
                            front: CardContent(
                              image: pack.image,
                              title: pack.title,
                              text: pack.price.toString(),
                              pack: pack,
                              isSelected: _selectedPackId == pack.id,
                            ),
                            back: CardContent(
                              text: pack.description,
                              selectButtont: 'Select',
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
                          "Proceed to Payment",
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
