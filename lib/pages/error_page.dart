// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_button.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error loading page, try again please..'),
            SizedBox(height: 25),
            MyButton(
                text: 'Go back',
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Colors.blue[300]!)
          ],
        ))));
  }
}
