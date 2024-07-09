import 'package:flutter/material.dart';
import 'package:neatfreak/components/my_button.dart';
import 'package:neatfreak/pages/cleaner/cleaner_registration_page.dart';
import 'package:neatfreak/pages/customer/customer_registration_page.dart';
import 'package:neatfreak/pages/login_page.dart';

class AppStartupPage extends StatelessWidget {
  const AppStartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    void handleCleanerSelection() {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CleanerRegistrationPage()),
        );
      } catch (error) {
        _showErrorDialog(context, 'Failed to navigate to Cleaner Registration Page');
      }
    }

    void handleNeedCleaningSelection() {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CustomerRegistrationPage()),
        );
      } catch (error) {
        _showErrorDialog(context, 'Failed to navigate to Customer Registration Page');
      }
    }

    void handleLogin() {
      try {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } catch (error) {
        _showErrorDialog(context, 'Failed to navigate to Login Page');
      }
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            const Image(
                image: AssetImage('lib/assets/logo.png'),
                height: 200,
                width: 300),
            const SizedBox(height: 15),
            //welcome text
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "Select one to get started",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                  text: "I am a Cleaner",
                  onPressed: handleCleanerSelection,
                  color: Colors.blue[300]!,
                ),
                MyButton(
                  text: "I need Cleaning",
                  onPressed: handleNeedCleaningSelection,
                  color: Colors.blue[300]!,
                ),
              ],
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.blue[300],
                    ),
                  ),
                ],
              ),
            ),
            //already have an account?
            GestureDetector(
              onTap: handleLogin,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already a member? Tap here to '),
                  Text('login', style: TextStyle(color: Colors.blue[500])),
                ],
              ),
            ),
          ],
        ))));
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
