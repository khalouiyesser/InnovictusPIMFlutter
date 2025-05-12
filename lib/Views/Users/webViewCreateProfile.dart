import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Services/payment_service.dart';
import 'package:piminnovictus/Services/session_manager.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../viewmodels/profile_switcher_view_model.dart';

class WebViewPageYesser extends StatefulWidget {
  final String url;
  final String name;
  final String imagePath;
  final String? packId;

  const WebViewPageYesser({
    Key? key,
    required this.url,
    required this.name,
    required this.imagePath,
    required this.packId,
    // required String userEmail,
  }) : super(key: key);

  @override
  State<WebViewPageYesser> createState() => _WebViewPageYesserState();
}

class _WebViewPageYesserState extends State<WebViewPageYesser> {
  late final WebViewController _controller;
  final PaymentService _paymentService = PaymentService();
  final SessionManager _sessionManager = SessionManager();

  bool _isLoading = false;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success')) {
              _showSuccessPopup();
              return NavigationDecision.prevent;
            } else if (request.url.contains('cancel')) {
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _showSuccessPopup() {
    final _theme = AuthScreenThemeDetector.getTheme();
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDarkMode
                  ? const Color.fromARGB(255, 8, 16, 9)
                  : Colors.white.withOpacity(0.7),
              title: Text(
                "Paiement réussi",
                style: TextStyle(
                  color: _theme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Merci pour votre paiement!",
                    style: TextStyle(color: _theme.textColor),
                  ),
                  if (_isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _theme.textColor,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Finalisation du profil...",
                              style: TextStyle(
                                color: _theme.textColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _statusMessage,
                        style: TextStyle(
                          color: _theme.textColor,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    setState(() {
                      _isLoading = true;
                      _statusMessage = '';
                    });

                    final result = await _paymentService.createProfile(
                      packId: widget.packId ?? '',
                      name: widget.name,
                      imagePath: widget.imagePath,
                    );

                    if (result['success'] == true) {
                      setState(() {
                        _isLoading = false;
                        _statusMessage = result['message'] ?? 'Profil créé avec succès';
                      });

                      // ✅ Correction ici : on récupère le ViewModel depuis le Provider
                      final profileSwitcherViewModel = Provider.of<ProfileSwitcherViewModel>(context, listen: false);

                      // ✅ On recharge les profils
                      await profileSwitcherViewModel.loadProfiles();

                      // ✅ Navigation propre (tu peux garder la tienne sinon)
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => BottomNavBarExample()),
                      );
                    } else {
                      setState(() {
                        _isLoading = false;
                        _statusMessage = result['message'] ?? "Une erreur est survenue";
                      });
                    }
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _theme = AuthScreenThemeDetector.getTheme();
    final isDarkMode = AuthScreenThemeDetector.isSystemDarkMode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Paiement sécurisé",
          style: TextStyle(
            color: _theme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 8, 16, 9)
            : Colors.white.withOpacity(0.7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: _theme.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}


// CreateProfileService.openPaymentProfile(context,
// _selectedPack?.id,
// _nameController.text,
// SessionManager().getEmail() as String,
// SessionManager().getUserId() as String
// );