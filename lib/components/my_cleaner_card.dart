// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/chat_page.dart';

class CleanerCard extends StatelessWidget {
  final AppUser cleaner;
  final AppUser user;

  const CleanerCard({
    Key? key,
    required this.cleaner,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    String name = cleaner.firstName;
    String lastInitial = cleaner.lastName[0];

    return GestureDetector(
      onTap: null,
      child: SizedBox(
        width: double.infinity, // Set the desired width
        height: 150, // Set the desired height
        child: Card(
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          color: Colors.grey[100],
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 5,
          child: Stack(
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  '$name $lastInitial.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  cleaner.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Positioned(
                right: 5,
                bottom: 0,
                child: TextButton(
                  child: const Text('Book', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          user: user,
                          receiverFirstName: cleaner.firstName,
                          recieverUserEmail: cleaner.email,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '\$${cleaner.pricing}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' per hour',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 10,
                child: Row(
                  children: [
                    Text(
                      cleaner.rating.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
