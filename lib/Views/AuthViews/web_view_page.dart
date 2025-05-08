import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/config/Theme/AuthTheme.dart';
import 'package:piminnovictus/Services/payment_service%20.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:piminnovictus/Views/DashboardClient/Bottom_bar.dart';
import 'package:piminnovictus/main.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String pendingSignupId; // Add pendingSignupId

  const WebViewPage(
      {Key? key, required this.url, required this.pendingSignupId, required String defaultProfileId})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  final PaymentService _paymentService =
      PaymentService(); // Instantiate PaymentService

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
          content: Text(
            "Thank you for your payment!",
            style: TextStyle(
              color: _theme.textColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Call the finalizeSignup method when OK is pressed
                await _paymentService.finalizeSignup(widget.pendingSignupId);
                Navigator.of(context).pop(); // Close the popup
                Navigator.of(context).pop(); // Close the WebView

                // Navigate to the LoginView page
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => BottomNavBarExample()),
                );
              },
              child: Text("OK"),
            ),
          ],
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
