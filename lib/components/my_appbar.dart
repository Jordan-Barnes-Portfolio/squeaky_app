import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/profile_page.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppUser user;

  const MyAppBar({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey[100],
      shadowColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      elevation: 5,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(user: user),
              ),
            );
          },
        ),
      ],
      leadingWidth: 170,
      leading: Padding(
        padding: const EdgeInsets.fromLTRB(7, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.firstName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(DateFormat('EEEE, d MMMM').format(DateTime.now())),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
