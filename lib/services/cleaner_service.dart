import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/review.dart';
import 'package:squeaky_app/objects/user.dart';

class CleanerService extends ChangeNotifier {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  //Add a review to the cleaners profile
  void addReview(Appointment appointment, Review review) async {
    try {
      appointment.hasReview = true;

      final cleanerRef = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: appointment.invoice!.cleanerEmail)
          .get();

      await cleanerRef.then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({
            'ratings': FieldValue.increment(1),
            'reviews': FieldValue.arrayUnion([review.toMap()]),
          });
        }
      });

      final users = FirebaseFirestore.instance.collection('users');
      var doc = await users.doc(appointment.invoice!.cleanerEmail).get();

      calculateRating(AppUser.fromMap(doc.data() as Map<String, dynamic>));

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: appointment.invoice!.customerEmail)
          .get();

      await userRef.then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(element.id)
              .update({
            'hasNotification': false,
          });
        }
      });

      await _firebase
          .collection('users')
          .doc(appointment.invoice!.cleanerEmail)
          .collection('appointments')
          .doc(appointment.uid)
          .set(appointment.toMap());

      await _firebase
          .collection('users')
          .doc(appointment.invoice!.customerEmail)
          .collection('appointments')
          .doc(appointment.uid)
          .set(appointment.toMap());

      await _firebase
          .collection('appointments')
          .doc(appointment.uid)
          .set(appointment.toMap());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  void calculateRating(AppUser cleaner) async {
    num totalRating = 0;
    for (var review in cleaner.reviews) {
      totalRating = totalRating + review.rating;
    }
    cleaner.rating = totalRating / cleaner.ratings;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: cleaner.email)
        .get();

    await userRef.then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance.collection('users').doc(element.id).update({
          'rating': cleaner.rating,
        });
      }
    });
  }
}
