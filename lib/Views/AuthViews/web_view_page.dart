import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Services/payment_service%20.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String pendingSignupId;
  final String defaultProfileId;
  final String userEmail;
  final String packId; // Add packId parameter
  
  const WebViewPage({
    Key? key,
    required this.url,
    required this.pendingSignupId,
    required this.defaultProfileId,
    required this.userEmail,
    required this.packId, // Required packId parameter
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  final PaymentService _paymentService = PaymentService();
  bool _isLoading = false;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('success')) {
              _showSuccessPopup();
              return NavigationDecision.prevent; // Prevent navigation
            }
            return NavigationDecision.navigate; // Allow other navigation
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
      barrierDismissible: false, // Prevent clicking outside the popup
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: isDarkMode
                  ? const Color.fromARGB(255, 8, 16, 9)
                  : Colors.white.withOpacity(0.7),
              title: Text(
                "Payment Successful",
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
                    "Thank you for your payment!",
                    style: TextStyle(
                      color: _theme.textColor,
                    ),
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
                              "Processing your registration...",
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
                            _statusMessage = "";
                          });
                          
                          // Use the packId directly from widget
                          final String packId = widget.packId;
                          
                          print("🔍 Using packId: $packId for confirmation");
                          
                          // Finalize signup
                          await _paymentService.finalizeSignup(
                            widget.pendingSignupId,
                            widget.defaultProfileId
                          );
                          
                          setState(() {
                            _statusMessage = "Registration finalized. Sending confirmation email...";
                          });
                          
                          // Send confirmation email with proper packId
                          final result = await _paymentService.sendConfirmationEmail(
                            packId,
                            widget.userEmail,
                            "Jean Dupont" // You might want to pass this as a parameter too
                          );
                          
                          setState(() {
                            _isLoading = false;
                            _statusMessage = result["success"] 
                                ? "✅ " + result["message"] 
                                : "❌ " + result["message"];
                          });
                          
                          // Wait a moment to show the status message
                          await Future.delayed(Duration(seconds: 1));
                          
                          // Close dialogs and navigate
                          Navigator.of(context).pop(); // Close the popup
                          Navigator.of(context).pop(); // Close the WebView
                          
                          // Navigate to the BottomNavBarExample page
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => BottomNavBarExample()
                            ),
                          );
                        },
                  child: Text("OK"),
                ),
              ],
            );
          }
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
          "Stripe Payment",
          style: TextStyle(
            color: _theme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 8, 16, 9)
            : Colors.white.withOpacity(0.7),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}