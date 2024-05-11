import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:squeaky_app/objects/invoice.dart';
import 'package:squeaky_app/objects/user.dart';

class Appointment {
  String formattedDate;
  String unformattedDate;
  String status = 'scheduled';
  
  final String details;
  
  AppUser? cleaner;
  Timestamp? sortByDate;
  String? uid;
  Invoice? invoice;
  bool? hasReview;

  Appointment(
      {required this.formattedDate,
      required this.details,
      required this.unformattedDate,
      required this.invoice,
      required this.sortByDate,
      required this.status,
      this.hasReview = false,
      this.uid});

  Map<String, dynamic> toMap() {
    return {
      'formattedDate': formattedDate,
      'unformattedDate': unformattedDate,
      'details': details,
      'sortByDate': sortByDate,
      'status': status,
      'uid': uid,
      'hasReview': hasReview,
      'invoice': invoice?.toMap()
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
        formattedDate: map['formattedDate'],
        unformattedDate: map['unformattedDate'],
        sortByDate: map['sortByDate'],
        details: map['details'],
        status: map['status'],
        uid: map['uid'],
        hasReview: map['hasReview'],
        invoice: Invoice.fromMap(map['invoice']));
  }
}
