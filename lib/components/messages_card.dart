// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';

class MessagesCard extends StatelessWidget {
  MessagesCard(
      {super.key,
      required this.name,
      required this.lastMessage,
      required this.time,
      required this.customFunction});

  final String name;
  final String lastMessage;
  final String time;
  var customFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: customFunction,
      child: SizedBox(
        width: double.infinity, // Set the desired width
        height: 100, // Set the desired height
        child: Card(
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          elevation: 2,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.black54,
              radius: 25,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              lastMessage,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
