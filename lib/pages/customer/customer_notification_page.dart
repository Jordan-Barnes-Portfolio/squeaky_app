// ignore_for_file: unused_local_variable, must_be_immutable, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/customer_completed_appointment_card.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/appointment_service.dart';

class CustomerNotificationPage extends StatefulWidget {
  final AppUser user; // AppUser object
  var currentPageIndex = -1;
  CustomerNotificationPage({super.key, required this.user});

  @override
  _CustomerNotificationPage createState() => _CustomerNotificationPage();

  final _fireStore = FirebaseFirestore.instance;
  final ref = FirebaseFirestore.instance.collection('users').snapshots();
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _fireStore.collection('users').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final pastAppointments =
        AppointmentService().getAllCompletedAppointments(user.email);
  }
}

class _CustomerNotificationPage extends State<CustomerNotificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.grey[100],
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 5,
      ),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: MyGnavBar(
          currentPageIndex: widget.currentPageIndex, user: widget.user),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
        children: [
          _buildCurrentAppointmentList(),
        ],
      ))),
    );
  }

  Widget _buildCurrentAppointmentList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          AppointmentService().getAllNonReviewedAppointments(widget.user.email),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final documents = snapshot.data!.docs;
        if (documents.isEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No notifications..',
                      style: TextStyle(fontSize: 16))));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            final data = document.data() as Map<String, dynamic>;
            return CustomerCompletedAppointmentCard(
              appointment: Appointment.fromMap(data),
              user: widget.user,
            );
          },
        );
      },
    );
  }
}
