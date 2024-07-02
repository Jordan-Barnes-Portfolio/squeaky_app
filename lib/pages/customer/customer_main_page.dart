// ignore_for_file: unused_local_variable, must_be_immutable, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:intl/intl.dart';
import 'package:neatfreak/components/customer_appointment_card.dart';
import 'package:neatfreak/components/my_appbar.dart';
import 'package:neatfreak/components/my_cleaner_card.dart';
import 'package:neatfreak/components/my_gnav_bar.dart';
import 'package:neatfreak/objects/appointment.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/services/appointment_service.dart';

class CustomerMainPage extends StatefulWidget {
  AppUser user; // AppUser object
  var currentPageIndex = 0;
  var availCleaners = 0;
  var flipped = false;
  CustomerMainPage({super.key, required this.user});

  @override
  _CustomerMainPage createState() => _CustomerMainPage();

  final _fireStore = FirebaseFirestore.instance;
  final ref = FirebaseFirestore.instance.collection('users').snapshots();
  Future<void> getData() async {
    final users = FirebaseFirestore.instance.collection('users');
    var doc = await users.doc(user.email).get();
    user = AppUser.fromMap(doc.data() as Map<String, dynamic>);
    QuerySnapshot querySnapshot = await _fireStore.collection('users').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final todaysAppointments =
        AppointmentService().getTodaysAppointments(user.email);
    final upcomingAppointments =
        AppointmentService().getUpcomingAppointments(user.email);
  }
}

class _CustomerMainPage extends State<CustomerMainPage> {
  @override
  void initState() {
    super.initState();
    widget.getData();
    _buildCleanerList();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      widget.getData();
    });

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
                  Tab(text: 'Cleaner\s in your area'),
                  Tab(text: 'Upcoming Appointments'),
                ],
              ),
              const SizedBox(height: 20),
              SingleChildScrollView(
                child: SizedBox(
                  height: 550,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    children: [
                      _buildCleanerList(),
                      _buildCurrentAppointmentList(),
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

  Widget _buildCleanerList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.ref,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final documents = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            if (documents.length <= 1) {
              return const Center(
                  child: Text('No cleaners available in your area.. yet.'));
            } else {
              widget.flipped = true;
              final document = documents[index];
              final data = document.data() as Map<String, dynamic>;
              if (data['isCleaner'] == true && data['maxDistance'] > calculateDistance(data['location'] as GeoPoint, widget.user.location)) {
                widget.availCleaners++;
                return CleanerCard(
                  cleaner: AppUser.fromMap(data),
                  user: widget.user,
                );
            } else {
              if(widget.flipped){
                return const SizedBox.shrink();
              } else {
                widget.flipped = true;
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('No cleaners available in your area.. yet.'),
                  ),
                );
              }
              }
            }
          },
        );
      },
    );
  }

  Widget _buildCurrentAppointmentList() {
    var today = DateFormat('EEEE').format(DateTime.now());
    return StreamBuilder<QuerySnapshot>(
      stream: AppointmentService().getAllPendingAppointments(widget.user.email),
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
            var now = DateTime.now();
            var yesterday =
                DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
            DateTime date = data['sortByDate'].toDate();

            if (data['formattedDate'].toString().contains(today.toString())) {
              var formattedDate =
                  data['formattedDate'].toString().split('at')[1];
              data['formattedDate'] = 'Today at$formattedDate';
              return CustomerAppointmentCard(
                appointment: Appointment.fromMap(data),
                user: widget.user,
              );
            } else if (date.isBefore(yesterday)) {
              return CustomerAppointmentCard(
                appointment: Appointment.fromMap(data),
                user: widget.user,
                pastDue: true,
              );
            } else {
              return CustomerAppointmentCard(
                appointment: Appointment.fromMap(data),
                user: widget.user,
              );
            }
          },
        );
      },
    );
  }

  num calculateDistance(GeoPoint location1, GeoPoint location2) {
    return FlutterMapMath().distanceBetween(location1.latitude,
        location1.longitude, location2.latitude, location2.longitude, "miles");
  }
}
