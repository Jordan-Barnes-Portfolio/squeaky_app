// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/customer/view_past_appointment_details_page.dart';

class CustomerCompletedAppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final AppUser user;

  const CustomerCompletedAppointmentCard({
    Key? key,
    required this.appointment,
    required this.user,
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
                'Review $cleanerName!',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              subtitle: const Text(
                'Please review your cleaner\'s performance.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              )
            ),
            Positioned(
              right: 5,
              bottom: -4,
              child: TextButton(
                child: const Text(
                  'Review',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PastAppointmentDetailsPage(
                        user: user,
                        appointment: appointment,
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 5,
              bottom: -3,
              child: TextButton(
                child: Text(
                  appointment.formattedDate,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PastAppointmentDetailsPage(
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
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Completed',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
