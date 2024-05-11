// ignore_for_file: unused_local_variable, must_be_immutable, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeaky_app/components/cleaner_past_appointment_card.dart';
import 'package:squeaky_app/components/customer_past_appointment_card.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/appointment_service.dart';

class PastAppointmentsPage extends StatefulWidget {
  final AppUser user; // AppUser object
  var currentPageIndex = -1;
  PastAppointmentsPage({super.key, required this.user});

  @override
  _PastAppointmentsPage createState() => _PastAppointmentsPage();

  final _fireStore = FirebaseFirestore.instance;
  final ref = FirebaseFirestore.instance.collection('users').snapshots();
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _fireStore.collection('users').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final todaysAppointments =
        AppointmentService().getTodaysAppointments(user.email);
    final upcomingAppointments =
        AppointmentService().getUpcomingAppointments(user.email);
  }
}

class _PastAppointmentsPage extends State<PastAppointmentsPage> {
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
          'Past Appointments',
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
    var today = DateFormat('EEEE').format(DateTime.now());
    return StreamBuilder<QuerySnapshot>(
      stream:
          AppointmentService().getAllNonPendingAppointments(widget.user.email),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final documents = snapshot.data!.docs;
        if (documents.isEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No appointments..',
                      style: TextStyle(fontSize: 16))));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            final data = document.data() as Map<String, dynamic>;
            if (data['formattedDate'].toString().contains(today.toString())) {
              var formattedDate =
                  data['formattedDate'].toString().split('at')[1];
              data['formattedDate'] = 'Today at$formattedDate';
              return widget.user.isCleaner
                  ? CleanerPastAppointmentCard(
                      appointment: Appointment.fromMap(data),
                      user: widget.user,
                    )
                  : CustomerPastAppointmentCard(
                      appointment: Appointment.fromMap(data),
                      user: widget.user,
                    );
            } else {
              return widget.user.isCleaner
                  ? CleanerPastAppointmentCard(
                      appointment: Appointment.fromMap(data),
                      user: widget.user,
                    )
                  : CustomerPastAppointmentCard(
                      appointment: Appointment.fromMap(data),
                      user: widget.user,
                    );
            }
          },
        );
      },
    );
  }
}
