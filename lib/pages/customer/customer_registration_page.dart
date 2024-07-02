// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neatfreak/components/my_button.dart';
import 'package:neatfreak/components/my_drop_down_field.dart';
import 'package:neatfreak/components/my_number_field.dart';
import 'package:neatfreak/components/my_text_field.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/pages/customer/customer_registration_page_2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';

class CustomerRegistrationPage extends StatelessWidget {
  const CustomerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Controllers
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final firstnameController = TextEditingController();
    final lastnameController = TextEditingController();
    final addressController = TextEditingController();
    final address2Controller = TextEditingController();
    final zipCodeController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();

    bool isEmail(String em) {
      String p =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      RegExp regExp = RegExp(p);

      return regExp.hasMatch(em);
    }

    Future predictAddress(String input) async {
      String apiKey = dotenv.env['GOOGLE_PLACES_API_KEY']!;
      String groundURL = "https://places.googleapis.com/v1/places:autocomplete";

      var response = await http.post(Uri.parse(groundURL),
          headers: {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": apiKey
          },
          body: json.encode({
            "input": input,
            "includedRegionCodes": ["us"]
          }));
      var resultData = response.body.toString();

      if (response.statusCode == 200) {
        try {
          var data = json.decode(resultData);
          var predictions = data["suggestions"];
          var structuredAddress =
              predictions[0]['placePrediction']['text']['text'];
          return structuredAddress as String;
        } catch (e) {
          return [];
        }
      } else {
        throw Exception('Failed to load predictions');
      }
    }


    //Functions
    Future<void> handleNextSubmit() async {
      if (passwordController.text != confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Your passwords do not match.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // dismisses only the dialog and returns nothing
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (firstnameController.text.length > 12) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Sorry, your first name is longer than 12 characters.. can you shorten it?'),
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

      if (isEmail(emailController.text) == false) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a valid email address.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pop(); // dismisses only the dialog and returns nothing
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      if (passwordController.text.isEmpty ||
          emailController.text.isEmpty ||
          phoneController.text.isEmpty ||
          firstnameController.text.isEmpty ||
          addressController.text.isEmpty ||
          lastnameController.text.isEmpty ||
          cityController.text.isEmpty ||
          stateController.text.isEmpty ||
          zipCodeController.text.isEmpty) {
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

      if (passwordController.text.length < 8) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Password must be at least 8 characters long.'),
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

      AppUser user = AppUser(
        email: emailController.text,
        password: passwordController.text,
        phoneNumber: phoneController.text,
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        address: "${addressController.text} ${address2Controller.text} ${cityController.text}, ${stateController.text} ${zipCodeController.text}",
        isAdmin: false,
        isCleaner: false,
        isCustomer: true,
        impInformation: "None",
      );

      var prediction = await predictAddress(user.address);
      print(prediction);

      try {
        List<Location> locations = await locationFromAddress(prediction.toString());
        GeoPoint location = GeoPoint(locations[0].latitude, locations[0].longitude);
        user.location = location;
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Please enter a valid united states address, we need it to send a cleaner to your home!'),
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

      final users = FirebaseFirestore.instance.collection('users');
      var doc = await users.doc(user.email).get();

      if (doc.exists) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Email is already registered, choose a different one or recover your password.'),
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

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomerRegistrationPage2(user: user)),
      );
    }

    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
            child: SafeArea(
                child: Column(
          children: [
            const SizedBox(height: 45),
            const Text(
              textAlign: TextAlign.center,
              "Let's clean your home!",
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
            MyTextField(
              controller: emailController,
              hintText: 'Your preferred email address',
              obscureText: false,
              label: "Email",
            ),
            MyTextField(
              controller: passwordController,
              hintText: 'Your desired password',
              obscureText: true,
              label: "Password",
            ),
            MyTextField(
              controller: confirmPasswordController,
              hintText: 'Confirm password',
              obscureText: true,
              label: "Confirm Password",
            ),
            MyTextField(
              controller: firstnameController,
              hintText: 'First Name',
              obscureText: false,
              label: "First Name",
            ),
            MyTextField(
              controller: lastnameController,
              hintText: 'Last Name',
              obscureText: false,
              label: "Last Name",
            ),
            MyNumberField(
              controller: phoneController,
              hintText: 'Your preferred contact phone number',
              obscureText: false,
              label: "Phone",
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 5, bottom: 15),
              child: TextField(
                onTapOutside: (PointerDownEvent event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: addressController,
                obscureText: false,
                decoration: const InputDecoration(
                  label: Text('Address Line 1'),
                  border: OutlineInputBorder(),
                  hintText: 'Address line 1',
                ),
              ),
            ),
            MyTextField(
              controller: address2Controller,
              hintText: 'Address line 2 (optional)',
              obscureText: false,
              label: "Address Line 2",
            ),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: cityController,
                    hintText: 'City',
                    obscureText: false,
                    label: "City",
                  ),
                ),
                Expanded(
                  child: MyDropDownField(
                    controller: stateController,
                    hintText: 'State',
                    obscureText: false,
                    label: "State",
                    options: const <String>[
                      'AL',
                      'AK',
                      'AZ',
                      'AR',
                      'CA',
                      'CO',
                      'CT',
                      'DE',
                      'FL',
                      'GA',
                      'HI',
                      'ID',
                      'IL',
                      'IN',
                      'IA',
                      'KS',
                      'KY',
                      'LA',
                      'ME',
                      'MD',
                      'MA',
                      'MI',
                      'MN',
                      'MS',
                      'MO',
                      'MT',
                      'NE',
                      'NV',
                      'NH',
                      'NJ',
                      'NM',
                      'NY',
                      'NC',
                      'ND',
                      'OH',
                      'OK',
                      'OR',
                      'PA',
                      'RI',
                      'SC',
                      'SD',
                      'TN',
                      'TX',
                      'UT',
                      'VT',
                      'VA',
                      'WA',
                      'WV',
                      'WI',
                      'WY'
                    ],
                  ),
                ),
                Expanded(
                  child: MyNumberField(
                    controller: zipCodeController,
                    hintText: 'Zip Code',
                    obscureText: false,
                    label: "Zip Code",
                  ),
                ),
              ],
            ),
            MyButton(
                text: "Next",
                onPressed: handleNextSubmit,
                color: Colors.blue[300]!),
            const SizedBox(height: 25),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                  child: const Text('Go Back'),
                  onTap: () => Navigator.pop(context))
            ]),
            const SizedBox(height: 25),
          ],
        ))));
  }
}
