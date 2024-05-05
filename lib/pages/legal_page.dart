// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';

class LegalPage extends StatelessWidget {
  AppUser user;
  LegalPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Legal'),
          backgroundColor: Colors.grey[100],
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 5,
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: MyGnavBar(currentPageIndex: 2, user: user),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 25),
            Text('Legal Notices', style: TextStyle(fontSize: 20)),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.book),
                    title: Text("The platform and the use of it"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
          ],
        ))));
  }
}
