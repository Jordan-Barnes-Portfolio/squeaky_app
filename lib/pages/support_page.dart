// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';

class SupportPage extends StatelessWidget {
  AppUser user;
  SupportPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Support'),
          backgroundColor: Colors.grey[100],
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 5,
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: MyGnavBar(currentPageIndex: 2, user: user),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("How do I switch to being a cleaner?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("How do I switch to being a customer?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("Whats the scrub service fee?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("Overview of trust and safety"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("Whats the scrub trust and support fee?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("How do I pay my cleaner?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text(
                        "What info should I put in my service description?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("Cleaning service tips for customers"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text(
                        "I have a concern about the quality of my completed cleaning service?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("What do cleaners offer?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("Why cant I find a cleaner?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("What supplies will my cleaner have?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text(
                        "What do I need to do after booking my cleaning service?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text(
                        "Do I have to be home during my cleaning service or when its completed?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("What should I do with pets and children?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("How do I leave a review?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("My invoice is incorrect what should I do?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title: Text("How do I hire a cleaner?"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: InkWell(
                onTap: () {},
                child: const Card(
                  elevation: 5,
                  shadowColor: Colors.black12,
                  surfaceTintColor: Colors.transparent,
                  child: ListTile(
                    leading: Icon(CupertinoIcons.question_circle),
                    title:
                        Text("I'd like to understand the fees on my invoice."),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(7),
              child: Text(
                "For any questions not listed here, please contact us at: 818-292-1692 or email us at scrubsupport@gmail.com",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        )))));
  }
}
