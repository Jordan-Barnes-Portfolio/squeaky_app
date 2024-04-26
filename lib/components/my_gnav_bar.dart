import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/cleaner_main_page.dart';
import 'package:squeaky_app/pages/customer_main_page.dart';
import 'package:squeaky_app/pages/messages_cleaner.dart';
import 'package:squeaky_app/pages/messages_customer.dart';
import 'package:squeaky_app/pages/profile_page.dart';

class MyGnavBar extends StatelessWidget {
  final AppUser user;
  final int currentPageIndex;

  const MyGnavBar({
    super.key,
    required this.user,
    required this.currentPageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return
    GNav(
          backgroundColor: (Colors.grey[100]!),
          tabMargin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          gap: 8,
          activeColor: Colors.black,
          iconSize: 24,
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 16),
          duration: const Duration(milliseconds: 800),
          tabs: [
            GButton(
              icon: currentPageIndex == 0 ? Icons.home : Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: currentPageIndex == 1 ? Icons.message : Icons.message_outlined,
              text: 'Messages',
            ),
            GButton(
              icon: currentPageIndex == 2 ? Icons.person : Icons.person_outlined,
              text: 'Profile',
            ),
          ],
          selectedIndex: currentPageIndex,
          onTabChange: (index) {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => user.isCleaner ? CleanerMainPage(user: user) : CustomerMainPage(user: user)));
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => user.isCleaner ? CleanerMessagesPage(user: user) : CustomerMessagesPage(user: user)));
            } else if (index == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(user: user)));
            }
          },
        );
  }
  
  void setState(Null Function() param0) {}
}