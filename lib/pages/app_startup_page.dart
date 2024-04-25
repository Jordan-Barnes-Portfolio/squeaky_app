import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/pages/cleaner_registration_page.dart';
import 'package:squeaky_app/pages/customer_registration_page.dart';
import 'package:squeaky_app/pages/login_page.dart';

class AppStartupPage extends StatelessWidget {
  const AppStartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    void handleCleanerSelection() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const CleanerRegistrationPage()),
      );
    }

    void handleNeedCleaningSelection() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const CustomerRegistrationPage()),
      );
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            const Icon(
              //TODO: \/\/\/ replace with our logo eventually
              Icons.clean_hands,
              size: 100,
            ),

            const SizedBox(height: 15),

            //welcome text
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                "Select one to get started",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                "Already have an account?",
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ))));
  }
}
