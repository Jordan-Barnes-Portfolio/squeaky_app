// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/cleaner/cleaner_main_page.dart';
import 'package:squeaky_app/pages/customer/customer_main_page.dart';
import 'package:squeaky_app/pages/login_page.dart';
import 'package:squeaky_app/services/authentication_service.dart';

class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    void directUser(var email) async {
      final users = FirebaseFirestore.instance.collection('users');
      var doc = await users.doc(email).get();
      if (doc.exists && doc.data()?['isCleaner'] == false) {
        AppUser user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerMainPage(
                      user: user,
                    )));
      } else {
        try {
          AppUser user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CleanerMainPage(
                        user: user,
                      )));
        } catch (e) {
          AuthenticationService().signOut();
          print(e.toString());
        }
      }
    }

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            directUser(snapshot.data?.email);
            return const Center(child: CircularProgressIndicator());
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
