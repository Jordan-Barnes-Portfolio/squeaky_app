// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/cleaner/cleaner_viewable_profile_page.dart';
import 'package:squeaky_app/pages/customer/customer_booking_page.dart';

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
      onTap: () => {
        showModalBottomSheet(
            barrierColor: Color(const Color.fromARGB(113, 238, 238, 238).value),
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            context: context,
            builder: (BuildContext context) {
              return CleanerDetailsPage(cleaner: cleaner, user: user);
            }),
      },
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
                leading: cleaner.profilePhoto == 'none'
                    ? const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 40,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(cleaner.profilePhoto),
                      ),
                title: Text(
                  '$name $lastInitial.',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                  child: const Text(
                    'Book',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerBookingPage(
                          user: user,
                          cleaner: cleaner,
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
                        text: '\$${cleaner.pricing.toStringAsFixed(2)}',
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
