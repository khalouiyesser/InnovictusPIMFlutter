import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:piminnovictus/Models/ClientModels/packs.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Models/config/language/translations.dart';
import 'package:piminnovictus/Services/payment_service%20.dart';
import 'package:piminnovictus/Views/Visitor/card_content.dart';
import 'package:piminnovictus/Views/Visitor/flip_card.dart';
import 'package:piminnovictus/viewmodels/Auth/subscription_view_model.dart';
import 'package:piminnovictus/viewmodels/packs_view_model.dart';
import 'package:piminnovictus/views/AuthViews/welcome_view.dart';
import 'package:provider/provider.dart';

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
  List<Pack> packs = [];

  late final SubscriptionViewModel _viewModel;
  late final PacksViewModel _packsViewModel;

  String? _selectedPackId;
  bool _isLoading = false;
  bool _isLoadingPacks = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _viewModel = SubscriptionViewModel(pendingSignupId: widget.pendingSignupId);
    if (widget.preselectedPackId != null) {
      _viewModel.selectedPackId = widget.preselectedPackId;
    }
    _packsViewModel = Provider.of<PacksViewModel>(context, listen: false);
    _loadPacks();
  }

  Future<void> _loadPacks() async {
    setState(() {
      _isLoadingPacks = true;
      _errorMessage = null;
    });

    try {
      await _packsViewModel.getAllPacks();

      setState(() {
        packs = _packsViewModel.packs;
        _isLoadingPacks = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingPacks = false;
      });
    }
  }

  void _selectPack(String packId) {
    setState(() {
      _selectedPackId = _selectedPackId == packs ? null : packId;
      _viewModel.selectedPackId = _selectedPackId;
    });
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 8, 16, 9),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 31, 219, 59),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _proceedToPayment() async {
    if (_viewModel.selectedPackId != null) {
      try {
        setState(() {
          _isLoading = true;
        });

        // Show loading dialog
        _showLoadingDialog(context,
            AppLocalizations.of(context).translate('processingPayment'));

        // First try to find the pack
        Pack? selectedPack;
        try {
          selectedPack = packs.firstWhere(
            (pack) => pack.id == _viewModel.selectedPackId,
          );
        } catch (e) {
          // Close loading dialog
          Navigator.of(context).pop();

          print('Selected pack ID: ${_viewModel.selectedPackId}');
          print('Available pack IDs: ${packs.map((p) => p.id).toList()}');
          // If pack not found, show error
          final _theme = AuthScreenThemeDetector.getTheme();
          final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: isDarkMode
                    ? const Color.fromARGB(255, 8, 16, 9)
                    : Colors.white.withOpacity(0.7),
                title: Text(
                  AppLocalizations.of(context).translate('error'),
                  style: TextStyle(
                    color: _theme.textColor,
                  ),
                ),
                content: Text(
                  AppLocalizations.of(context).translate('packNotFound'),
                  style: TextStyle(
                    color: _theme.textColor,
                  ),
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
          setState(() {
            _isLoading = false;
          });
          return;
        }

        // If we found the pack, proceed with the API call
        final success = await _viewModel.updatePackForPendingSignup();
        final AuthScreenTheme _theme = AuthScreenThemeDetector.getTheme();

        // Close loading dialog
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        if (success) {
          String packId = _viewModel.selectedPackId!;
          String pendingSignupId = widget.pendingSignupId;
          PaymentService.openPayment(context, packId, pendingSignupId);
        } else {
          // Check if it's the email verification error
          if (_viewModel.error == "EMAIL_VERIFICATION_REQUIRED") {
            final _theme = AuthScreenThemeDetector.getTheme();
            final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: isDarkMode
                      ? const Color.fromARGB(255, 8, 16, 9)
                      : Colors.white.withOpacity(0.8), // Blanc avec opacité
                  title: Text(
                    AppLocalizations.of(context).translate('emailConfirmation'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _theme.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  content: Text(
                    AppLocalizations.of(context)
                        .translate('emailVerificationRequired'),
                    style: TextStyle(
                      color: _theme.textColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 31, 219, 59),
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate('ok'),
                        style: const TextStyle(color: Colors.white),
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
            final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

            // Handle other errors
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: isDarkMode
                      ? const Color.fromARGB(255, 8, 16, 9)
                      : Colors.white.withOpacity(0.7),
                  title: Text(
                    AppLocalizations.of(context).translate('error'),
                    style: TextStyle(
                      color: _theme.textColor,
                    ),
                  ),
                  content: Text(
                    _viewModel.error ??
                        AppLocalizations.of(context).translate('genericError'),
                    style: TextStyle(
                      color: _theme.textColor,
                    ),
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
        // Close loading dialog if it's open
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        print('Error in _proceedToPayment: $e');
        final _theme = AuthScreenThemeDetector.getTheme();
        final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: isDarkMode
                  ? const Color.fromARGB(255, 8, 16, 9)
                  : Colors.white.withOpacity(0.7),
              title: Text(
                AppLocalizations.of(context).translate('error'),
                style: TextStyle(
                  color: _theme.textColor,
                ),
              ),
              content: Text(
                e.toString(),
                style: TextStyle(
                  color: _theme.textColor,
                ),
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
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      final _theme = AuthScreenThemeDetector.getTheme();
      final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();
      // No pack selected dialog remains the same
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: isDarkMode
                ? const Color.fromARGB(255, 8, 16, 9)
                : Colors.white.withOpacity(0.7),
            title: Text(
              AppLocalizations.of(context).translate('noPackSelected'),
              style: TextStyle(
                color: _theme.textColor,
              ),
            ),
            content: Text(
              AppLocalizations.of(context).translate('selectPackPrompt'),
              style: TextStyle(
                color: _theme.textColor,
              ),
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
    final AuthScreenTheme _theme = AuthScreenThemeDetector.getTheme();
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
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
                              AppLocalizations.of(context)
                                  .translate('selectPack'),
                              style: TextStyle(
                                color: _theme.textColor,
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            // Instructions with icons
                            _buildInstructionRow(
                              icon: Icons.flip,
                              text: AppLocalizations.of(context)
                                  .translate('flipCardInstruction'),
                              screenWidth: screenWidth,
                            ),
                            SizedBox(height: 8),
                            _buildInstructionRow(
                              icon: Icons.touch_app,
                              text: AppLocalizations.of(context)
                                  .translate('clickSelectInstruction'),
                              screenWidth: screenWidth,
                            ),
                            SizedBox(height: 8),
                            _buildInstructionRow(
                              icon: Icons.check_circle_outline,
                              text: AppLocalizations.of(context)
                                  .translate('borderIndicationInstruction'),
                              screenWidth: screenWidth,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),
                      if (_isLoadingPacks)
                        Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 31, 219, 59),
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('loading'),
                                style: TextStyle(
                                  color: _theme.textColor,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (_errorMessage != null)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: _theme.textColor,
                                size: screenWidth * 0.1,
                              ),
                              SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('errorLoadingPacks'),
                                style: TextStyle(
                                  color: _theme.textColor,
                                  fontSize: screenWidth * 0.05,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: _theme.textColor,
                                  fontSize: screenWidth * 0.04,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadPacks,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 31, 219, 59),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('retry'),
                                  style: TextStyle(
                                    color: _theme.textColor,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (packs.isEmpty)
                        Center(
                          child: Text(
                            AppLocalizations.of(context)
                                .translate('noPacksAvailable'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        )
                      else
                        // GridView with 2 cards per line
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: screenWidth * 0.04,
                              mainAxisSpacing: screenHeight * 0.02,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: packs.length,
                            itemBuilder: (context, index) {
                              final pack = packs[index];
                              final translatedTitle =
                                  AppLocalizations.of(context)
                                      .translate(pack.title);
                              final translatedDescription =
                                  AppLocalizations.of(context)
                                      .translate(pack.description);

                              return GestureDetector(
                                onTap: () => _selectPack(pack.id ?? ""),
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
                                    selectButtont: AppLocalizations.of(context)
                                        .translate('select'),
                                    pack: pack,
                                    isSelected: _selectedPackId == pack.id,
                                    onSelectPressed: () =>
                                        _selectPack(pack.id ?? ""),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.05),
                      if (!_isLoadingPacks && _errorMessage == null)
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
                              onPressed: _isLoading ? null : _proceedToPayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isLoading
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 31, 219, 59),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: screenHeight * 0.025,
                                      width: screenHeight * 0.025,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                  : Text(
                                      AppLocalizations.of(context)
                                          .translate('proceedToPayment'),
                                      style: TextStyle(
                                        color: _theme.textColor,
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

          // Full screen loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 31, 219, 59),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow({
    required IconData icon,
    required String text,
    required double screenWidth,
  }) {
    final _theme = AuthScreenThemeDetector.getTheme();
    return Row(
      children: [
        Icon(icon, color: _theme.textColor, size: screenWidth * 0.05),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: _theme
                  .textColor, // Utilisation de la couleur du thème au lieu de Colors.white
            ),
          ),
        ),
      ],
    );
  }
}
