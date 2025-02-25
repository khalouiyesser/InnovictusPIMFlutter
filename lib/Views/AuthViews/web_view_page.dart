import 'package:flutter/material.dart';
import 'package:piminnovictus/Services/payment_service.dart';
import 'package:piminnovictus/Views/AuthViews/login_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String pendingSignupId; // Add pendingSignupId

  const WebViewPage({Key? key, required this.url, required this.pendingSignupId}) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  final PaymentService _paymentService = PaymentService(); // Instantiate PaymentService

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
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent clicking outside the popup
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Payment Successful"),
          content: Text("Thank you for your payment!"),
          actions: [
            TextButton(
          onPressed: () async {
    // Call the finalizeSignup method when OK is pressed
    await _paymentService.finalizeSignup(widget.pendingSignupId);
    Navigator.of(context).pop(); // Close the popup
    Navigator.of(context).pop(); // Close the WebView

    // Navigate to the LoginView page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stripe Payment"),
        backgroundColor: const Color.fromARGB(255, 3, 36, 12),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}