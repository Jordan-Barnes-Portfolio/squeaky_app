// ignore_for_file: unused_local_variable, must_be_immutable, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/cleaner_appointment_card.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/appointment_service.dart';

class CleanerMainPage extends StatefulWidget {
  final AppUser user; // AppUser object
  var currentPageIndex = 0;
  CleanerMainPage({super.key, required this.user});

  @override
  _CleanerMainPage createState() => _CleanerMainPage();

  Future<void> getData() async {
    final todaysAppointments =
        AppointmentService().getTodaysAppointments(user.email);
    final upcomingAppointments =
        AppointmentService().getUpcomingAppointments(user.email);
  }
}

class _CleanerMainPage extends State<CleanerMainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(user: widget.user),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: MyGnavBar(
          currentPageIndex: widget.currentPageIndex, user: widget.user),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                dividerColor: Color(Colors.black.value),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Today\'s Appointments'),
                  Tab(text: 'Upcoming Appointments'),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: SizedBox(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    children: [
                      _buildCurrentAppointmentList(),
                      _buildFutureAppointmentList(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentAppointmentList() {
    return StreamBuilder<QuerySnapshot>(
      stream: AppointmentService().getTodaysAppointments(widget.user.email),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final documents = snapshot.data!.docs;
        if (documents.isEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No appointments today',
                      style: TextStyle(fontSize: 16))));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var now = DateTime.now();
            var yesterday =
                DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
            final document = documents[index];
            final data = document.data() as Map<String, dynamic>;
            DateTime date = data['sortByDate'].toDate();

            if (data['status'] == 'completed' || data['status'] == 'canceled') {
              return const SizedBox.shrink();
            } else if (date.isBefore(yesterday)) {
              return CleanerAppointmentCard(
                appointment: Appointment.fromMap(data),
                user: widget.user,
                pastDue: true,
              );
            } else {
              var formattedDate = data['formattedDate'] as String;
              formattedDate = formattedDate.split('at')[1];
              data['formattedDate'] = 'Today at$formattedDate';
              return CleanerAppointmentCard(
                appointment: Appointment.fromMap(data),
                user: widget.user,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildFutureAppointmentList() {
    return StreamBuilder<QuerySnapshot>(
      stream: AppointmentService().getUpcomingAppointments(widget.user.email),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final documents = snapshot.data!.docs;
        if (documents.isEmpty) {
          return const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No upcoming appointments',
                      style: TextStyle(fontSize: 16))));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final document = documents[index];
            final data = document.data() as Map<String, dynamic>;
            if (data['status'] == 'completed' || data['status'] == 'canceled') {
              return const SizedBox.shrink();
            } else {
              return CleanerAppointmentCard(
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
