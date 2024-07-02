// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/pages/error_page.dart';

class CustomerMessagesCard extends StatelessWidget {
  CustomerMessagesCard(
      {super.key,
      required this.user,
      required this.name,
      required this.lastMessage,
      required this.time,
      required this.recieverEmail,
      required this.customFunction,
      required this.seenByCustomer,
      required this.seenByCleaner,});

  final String name;
  final String lastMessage;
  final String time;
  final String recieverEmail;
  final AppUser user;
  bool seenByCustomer;
  bool seenByCleaner;
  var customFunction;

  var document;

  // Rest of the code...

  @override
  Widget build(BuildContext context) {
    try {
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
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(recieverEmail.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    document = snapshot.data;
                    return ListTile(
                      leading: document['profilePhoto'] == 'none'
                          ? const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 30,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 40,
                              ),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  document['profilePhoto'].toString()),
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
                          if (!seenByCustomer)
                            const Icon(
                              Icons.circle,
                              color: Colors.blue,
                              size: 10,
                            ),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
    return const ErrorPage();
  }
}
