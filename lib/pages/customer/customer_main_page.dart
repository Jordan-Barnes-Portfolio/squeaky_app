// ignore_for_file: unused_local_variable, must_be_immutable, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_cleaner_card.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';

class CustomerMainPage extends StatefulWidget {
  final AppUser user; // AppUser object
  var currentPageIndex = 0;
  CustomerMainPage({super.key, required this.user});

  @override
  _CustomerMainPage createState() => _CustomerMainPage();

  final _fireStore = FirebaseFirestore.instance;
  final ref = FirebaseFirestore.instance.collection('users').snapshots();
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _fireStore.collection('users').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}

class _CustomerMainPage extends State<CustomerMainPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshData() async {
    // Add your logic to refresh the data here
    // For example, you can call the getData() method again
    await widget.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(user: widget.user),
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: MyGnavBar(
          currentPageIndex: widget.currentPageIndex, user: widget.user),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.black,
        child: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.center, child: _buildCurrentAppointment()),
            const SizedBox(height: 10),
            const Divider(),
            _buildCleanerList(),
          ]),
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
        return Expanded(
            child: ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            if (documents.length <= 1) {
              return const Center(child: Text('No cleaners available in your area.. yet.'));
            } else {
              print(documents);
              final document = documents[index];
              final data = document.data() as Map<String, dynamic>;
              if (data['isCleaner'] != true) {
                return const SizedBox.shrink();
              }
              return CleanerCard(
                cleaner: AppUser.fromMap(data),
                user: widget.user,
              );
            }
          },
        ));
      },
    );
  }

  Widget _buildCurrentAppointment() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Current Appointments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'You have no upcoming appointments',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
