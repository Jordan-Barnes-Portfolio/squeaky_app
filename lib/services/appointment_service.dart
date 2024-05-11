import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/chat_service.dart';

class AppointmentService extends ChangeNotifier {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  // sign in with email and password
  void createAppointment(Appointment appointment, AppUser user) async {
    try {
      final appointments =
          FirebaseFirestore.instance.collection('appointments');
      DocumentReference docRef = await appointments.add(appointment.toMap());
      String appointmentId = docRef.id;

      appointment.uid = appointmentId;

      ChatService().sendMessage(
          appointment.invoice!.cleanerEmail,
          'System: Your appointment has been confirmed for ${appointment.formattedDate}, please check your upcoming appointments section for more details..',
          user,
          false,
          false,
          true,
          null);

      await _firebase
          .collection('users')
          .doc(appointment.invoice!.cleanerEmail)
          .collection('appointments')
          .doc(appointmentId)
          .set(appointment.toMap());
      await _firebase
          .collection('users')
          .doc(appointment.invoice!.customerEmail)
          .collection('appointments')
          .doc(appointmentId)
          .set(appointment.toMap());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  void deleteAllAppointments() async {
    try {
      print('starting appointment deletion...');
      try {
        await FirebaseFirestore.instance
            .collection('appointments')
            .snapshots()
            .forEach((element) {
          for (var doc in element.docs) {
            print('Deleted appointment: ${doc.id}');
            doc.reference.delete();
          }
        });
      } catch (e) {
        print('error deleting appointments: $e');
      }

      print('starting user appointment deletion...');
      await FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .forEach((element) {
        for (var doc in element.docs) {
          doc.reference.collection('appointments').snapshots().forEach((appts) {
            for (var appt in appts.docs) {
              print('Deleted appointment: ${appt.id}');
              appt.reference.delete();
            }
          });
        }
      });
    } on Exception catch (e) {
      print('exception thrown..');
      throw Exception(e.toString());
    }
  }

  void cancelAppointment(Appointment appointment, AppUser user) async {
    try {
      ChatService().sendMessage(
          appointment.invoice!.cleanerEmail,
          'System: Your appointment has been canceled for ${appointment.formattedDate}, please check your past appointments section in account details for more information..',
          user,
          false,
          false,
          true,
          null);

      await _firebase
          .collection('appointments')
          .doc(appointment.uid)
          .update(appointment.toMap());

      await _firebase
          .collection('users')
          .doc(appointment.invoice!.cleanerEmail)
          .collection('appointments')
          .doc(appointment.uid)
          .update(appointment.toMap());

      await _firebase
          .collection('users')
          .doc(appointment.invoice!.customerEmail)
          .collection('appointments')
          .doc(appointment.uid)
          .update(appointment.toMap());
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  void completeAppointment(Appointment appointment, AppUser user) async {
    try {
      appointment.status = 'completed';

      ChatService().sendMessage(
          appointment.invoice!.customerEmail,
          'System: Your appointment scheduled appointment on ${appointment.formattedDate} was completed! Thank you! please check your past appointments section in account details for more information..',
          user,
          false,
          false,
          true,
          null);

      await _firebase
          .collection('appointments')
          .doc(appointment.uid)
          .update(appointment.toMap());

      await _firebase
          .collection('users')
          .doc(appointment.invoice!.cleanerEmail)
          .collection('appointments')
          .doc(appointment.uid)
          .update(appointment.toMap());

      await _firebase
          .collection('users')
          .doc(appointment.invoice!.customerEmail)
          .collection('appointments')
          .doc(appointment.uid)
          .update(appointment.toMap());

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
            'hasNotification': true,
          });
        }
      });
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTodaysAppointments(
      String email) {
    try {
      var now = DateTime.now();
      var endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final appointments = _firebase
          .collection('users')
          .doc(email)
          .collection('appointments')
          .orderBy('sortByDate')
          .where('sortByDate', isLessThanOrEqualTo: endOfDay)
          .where('status', isEqualTo: 'scheduled')
          .snapshots();
      return appointments;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCompletedAppointments(String email) {
    try {
      final appointments = _firebase
          .collection('users')
          .doc(email)
          .collection('appointments')
          .orderBy('sortByDate')
          .where('status', isEqualTo: 'completed')
          .snapshots();
      return appointments;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUpcomingAppointments(
      String email) {
    try {
      var now = DateTime.now();
      var endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final appointments = _firebase
          .collection('users')
          .doc(email)
          .collection('appointments')
          .orderBy('sortByDate')
          .where('sortByDate', isGreaterThanOrEqualTo: endOfDay)
          .where('status', isEqualTo: 'scheduled')
          .snapshots();
      return appointments;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNextAppointment(String email) {
    try {
      final appointments = _firebase
          .collection('users')
          .doc(email)
          .collection('appointments')
          .orderBy('sortByDate')
          .limit(1)
          .snapshots();
      return appointments;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllPendingAppointments(
      String email) {
    try {
      final appointments = _firebase
          .collection('users')
          .doc(email)
          .collection('appointments')
          .orderBy('sortByDate')
          .where('status', isEqualTo: 'scheduled')
          .snapshots();

      return appointments;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllNonPendingAppointments(
      String email) {
    try {
      final appointments = _firebase
          .collection('users')
          .doc(email)
          .collection('appointments')
          .orderBy('sortByDate')
          .where('status', isNotEqualTo: 'scheduled')
          .snapshots();

      return appointments;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
