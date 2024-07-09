import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeConnectPage extends StatelessWidget {
  final String userId;

  StripeConnectPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Connect Onboarding'),
      ),
      body: WebView(
        initialUrl: 'http://192.168.1.10:3000?userId=$userId',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (request.url
              .startsWith('http://192.168.1.10:3000/return')) {
            // Handle successful onboarding
            Navigator.of(context).pop(); // Close the WebView
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
