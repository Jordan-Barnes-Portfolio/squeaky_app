// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:squeaky_app/components/give_star_reviews.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_large_text_field.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/review.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/cleaner_service.dart';

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

    void reviewCleaner() {
      TextEditingController detailsController = TextEditingController();
      num rating = 0;
      showModalBottomSheet(
          isScrollControlled: true,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          context: context,
          builder: (context) => Scaffold(
                  body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Review $cleanerName',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    'Please rate your cleaner\'s performance.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 1,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      const Text(
                        'Rating: ',
                        style: TextStyle(fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                      MyGiveStarReviews(
                        starData: [
                          MyGiveStarData(
                              size: 30,
                              text: '',
                              onChanged: (rate) {
                                rating = rate;
                              }),
                        ],
                      ),
                    ],
                  ),
                  MyLargeTextField(
                      controller: detailsController,
                      hintText: 'write a review for $cleanerName',
                      obscureText: false),
                  MyButton(
                    onPressed: () {
                      // Save the review
                      Review review = Review(
                        rating: rating,
                        details: detailsController.text,
                        reviewerName: appointment.invoice!.customerName,
                      );
                      CleanerService().addReview(appointment, review);
                      Navigator.pop(context);
                    },
                    text: 'Submit',
                    color: Colors.blue[400]!,
                  ),
                ],
              )));
    }

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
                )),
            Positioned(
              right: 5,
              bottom: -4,
              child: TextButton(
                child: const Text(
                  'Review',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onPressed: () {
                  reviewCleaner();
                },
              ),
            ),
            Positioned(
              left: 5,
              bottom: 7,
              child: Text(
                appointment.formattedDate,
                style: const TextStyle(fontSize: 14, color: Colors.black),
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
