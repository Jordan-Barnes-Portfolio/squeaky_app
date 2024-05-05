// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/components/my_large_text_field.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/chat_page.dart';

class CustomerBookingPage extends StatefulWidget {
  final AppUser user; // AppUser object
  final AppUser cleaner;
  var currentPageIndex = -1;

  CustomerBookingPage(
      {super.key, required this.user, required this.cleaner}); // Constructor

  @override
  _CustomerBookingPage createState() => _CustomerBookingPage();
}

class _CustomerBookingPage extends State<CustomerBookingPage> {
  TextEditingController appointmentController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day, now.hour + 1);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Booking with ${widget.cleaner.firstName} ${widget.cleaner.lastName[0]}.',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.grey[100],
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 5,
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: MyGnavBar(
            currentPageIndex: widget.currentPageIndex, user: widget.user),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            SizedBox(
              height: 200,
              width: 300,
              child: CupertinoDatePicker(
                  initialDateTime: date,
                  minimumDate: date,
                  maximumDate: date.add(const Duration(days: 31)),
                  onDateTimeChanged: (DateTime newDateTime) {
                    setState(() {
                      appointmentController.text =
                          '${DateFormat('EEEE, MMMM dd').format(newDateTime)} at ${DateFormat('hh:mm a').format(newDateTime)}';
                    });
                  },
                  mode: CupertinoDatePickerMode.dateAndTime,
                  minuteInterval: 15,
                  backgroundColor: Colors.grey[200]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
              child: TextField(
                controller: appointmentController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Appointment Date and Time',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyLargeTextField(
                controller: detailsController,
                hintText:
                    'Enter any additional details about your cleaning request here.. \n\nExample: I just want my closet cleaned, I have a pet, etc.',
                obscureText: false,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                    text: 'Continue booking',
                    color: Colors.blue[300]!,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ChatPage(
                            user: widget.user,
                            recieverUserEmail: widget.cleaner.email,
                            receiverFirstName: widget.cleaner.firstName,
                            initialMessage: 'I would like to book a cleaning appointment with you. Date: ${appointmentController.text}. Here are some additional details: ${detailsController.text}',
                          )));
                    })),
            Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
                child: Text(
                    'Note: this will open a chat with your cleaner to discuss further details and get an offficial quote.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]))),
          ],
        ))));
  }
}
