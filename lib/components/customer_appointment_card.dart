// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/view_appointment_details_page.dart';

class CustomerAppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final AppUser user;
  bool pastDue = false;

  CustomerAppointmentCard({
    Key? key,
    required this.appointment,
    required this.user,
    this.pastDue = false,
  });

  @override
  Widget build(BuildContext context) {
    String cleanerName = appointment.invoice!.cleanerName;

    return SizedBox(
      width: double.infinity, // Set the desired width
      height: 125, // Set the desired height
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
              title: Text(
                'Cleaning with: $cleanerName',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              right: 5,
              bottom: -4,
              child: TextButton(
                child: const Text(
                  'View Details',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetailsPage(
                        user: user,
                        appointment: appointment,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              right: 10,
              top: 20,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          '\$${appointment.invoice!.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' total',
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
              left: 16,
              bottom: 10,
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    pastDue
                        ? const TextSpan(
                            text: "Past Due: Contact your cleaner!",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : TextSpan(
                            text: appointment.formattedDate,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
