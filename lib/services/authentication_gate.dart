// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:neatfreak/api/firebase_api.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/pages/admin_page.dart';
import 'package:neatfreak/pages/cleaner/cleaner_main_page.dart';
import 'package:neatfreak/pages/customer/customer_main_page.dart';
import 'package:neatfreak/pages/login_page.dart';
import 'package:neatfreak/services/authentication_service.dart';

class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    void directUser(var email) async {
      final users = FirebaseFirestore.instance.collection('users');
      var doc = await users.doc(email).get();

      if (doc.exists && doc.data()?['isAdmin'] == true) {
        AppUser user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AdminPage(user: user)));
        return;
      }

      if (doc.exists && doc.data()?['isCleaner'] == false) {
        AppUser user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
        user.fcmToken = await FirebaseApi().getFCMToken();
        doc.reference.update({'fcmToken': user.fcmToken});

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerMainPage(
                      user: user,
                    )));
      } else {
        try {
          AppUser user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
          user.fcmToken = await FirebaseApi().getFCMToken();
          doc.reference.update({'fcmToken': user.fcmToken});
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
