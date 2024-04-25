// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});
  final emailController = TextEditingController();

  // sign in method
  void handlePasswordReset() {
    //TODO: Edit log in function to handle against backend
    final email = emailController.text;

    if (email == 'admin') {
      print('Email sent successfully');
    } else {
      print('Failed, you suck');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),

            //logo
            const Icon(
              //TODO: \/\/\/ replace with our logo eventually
              Icons.account_circle,
              size: 100,
            ),

            const SizedBox(height: 25),

            //welcome text
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                  "Enter the email address associated with your account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 25),

            //username
            MyTextField(
              controller: emailController,
              hintText: 'Enter your email address',
              obscureText: false,
              label: 'Email Address',
            ),

            const SizedBox(height: 25),

            MyButton(
              text: "Recover",
              onPressed: handlePasswordReset,
              color: Colors.blue[300]!,
            ),

            const SizedBox(height: 25),

            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                  child: const Text('Go Back'),
                  onTap: () => Navigator.pop(context))
            ])
          ],
        ))));
  }
}
