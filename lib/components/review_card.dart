// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:neatfreak/objects/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({Key? key, required this.review});

  @override
  Widget build(BuildContext context) {
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
              leading: const Icon(
                Icons.reviews,
              ),
              title: Text(
                review.reviewerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                review.details,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
              left: 20,
              bottom: 10,
              child: Row(
                children: [
                  Text(
                    review.rating.toStringAsFixed(1),
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
    );
  }
}
