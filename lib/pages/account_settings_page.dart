// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/authentication_gate.dart';
import 'package:squeaky_app/services/authentication_service.dart';


class AccountSettingsPage extends StatefulWidget {
  final AppUser user; // AppUser object

  const AccountSettingsPage({super.key, required this.user}); // Constructor

  @override
  _AccountSettingsPage createState() =>
      _AccountSettingsPage();
}

class _AccountSettingsPage extends State<AccountSettingsPage> {

  @override
  Widget build(BuildContext context) {
    var currentPageIndex = 2;
    return Scaffold(
        appBar: MyAppBar(user: widget.user),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: MyGnavBar(currentPageIndex: currentPageIndex, user: widget.user),
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            const Text('Account Settings',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 25),
            Text('Email: ${widget.user.email}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 25),
            Text('First Name: ${widget.user.firstName}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 25),
            Text('Last Name: ${widget.user.lastName}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 25),
            Text('Phone Number: ${widget.user.phoneNumber}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 25),
            Text('Address: ${widget.user.address}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () {
                AuthenticationService().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AuthenticationGate()),
                    (route) => false);
              },
              child: const Text('Sign out'),
            ),

          ],
        ))));
  }
}