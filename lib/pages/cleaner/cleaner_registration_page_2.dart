// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_large_text_field.dart';
import 'package:squeaky_app/objects/user.dart';

// ignore: must_be_immutable
class CleanerRegistrationPage2 extends StatelessWidget {
  CleanerRegistrationPage2({super.key, required this.user});
  AppUser user;

  @override
  Widget build(BuildContext context) {
    //Controllers
    final pphController = TextEditingController();
    final bioController = TextEditingController();
    final skillsController = TextEditingController();

    //Functions
    void handleNextSubmit() async {
      if (pphController.text.isEmpty ||
          bioController.text.isEmpty ||
          skillsController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Please fill in every box, we need it for your account!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // dismisses only the dialog and returns nothing
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
        return;
      }

      user.pricing = double.parse(pphController.text);
      user.bio = bioController.text;
      user.skills = skillsController.text;
      user.uuid = UniqueKey().toString();

      user.firstName = user.firstName[0].toUpperCase() +
          user.firstName.substring(1); // Capitalize the first letter

      user.lastName =
          user.lastName[0].toUpperCase() + user.lastName.substring(1);

      final users = FirebaseFirestore.instance.collection('users');
      await users.doc(user.email).set(user.toMap());

      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: user.email, password: user.password);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'There was an error registering your account, please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // dismisses only the dialog and returns nothing
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text(
              'You\'ve successfully registered! Welcome to Squeaky!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
            child: SafeArea(
                child: Center(
                    child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            const Text(
              "Registering as a Cleaner",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
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
                  const Text('Enter your information below'),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.blue[300],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 15),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: pphController,
                obscureText: false,
                decoration: const InputDecoration(
                  suffix: Text('\$/hr',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.left),
                  label: Text('Price per hour'),
                  border: OutlineInputBorder(),
                  hintText: 'Price per hour in \$',
                ),
              ),
            ),
            const Text("Write a little about yourself!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            MyLargeTextField(
              controller: bioController,
              hintText:
                  "I'm detail oriented, I love to walk my doggy, and I play video games!",
              obscureText: false,
            ),
            const Text("Tell us your experience and skills!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            MyLargeTextField(
              controller: skillsController,
              hintText:
                  "I've been cleaning for 5 years with various reputable cleaning companies, I'm extremely detail oriented, and love to make homes sparkle!",
              obscureText: false,
            ),
            MyButton(
                text: "Register",
                onPressed: handleNextSubmit,
                color: Colors.blue[300]!),
            const SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                  child: const Text('Go Back'),
                  onTap: () => Navigator.pop(context))
            ])
          ],
        )))));
  }
}
