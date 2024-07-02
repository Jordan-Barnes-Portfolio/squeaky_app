// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:neatfreak/components/my_button.dart';
import 'package:neatfreak/components/my_gnav_bar.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/services/appointment_service.dart';
import 'package:neatfreak/services/chat_service.dart';

class AdminPage extends StatelessWidget {
  final AppUser user;
  const AdminPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        bottomNavigationBar: MyGnavBar(user: user, currentPageIndex: -1),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyButton(
                text: 'Delete all appointments',
                onPressed: () => AppointmentService().deleteAllAppointments(),
                color: Colors.red),
            MyButton(
                text: 'Delete all chats',
                onPressed: () => ChatService().deleteAllChats(),
                color: Colors.red),
          ],
        ))));
  }
}
