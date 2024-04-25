// ignore_for_file: unused_local_variable, must_be_immutable, library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';




class CleanerMainPage extends StatefulWidget {
  final AppUser user; // AppUser object
  var currentPageIndex = 0;
  CleanerMainPage({super.key, required this.user});

  @override
  _CleanerMainPage createState() =>
      _CleanerMainPage();

  final _fireStore = FirebaseFirestore.instance;
  final ref = FirebaseFirestore.instance.collection('users').snapshots();
  Future<void> getData() async {
    QuerySnapshot querySnapshot = await _fireStore.collection('users').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
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
      bottomNavigationBar: MyGnavBar(currentPageIndex: widget.currentPageIndex, user: widget.user),
      body: SafeArea(
        child: Center(child: Text(widget.user.isCleaner.toString())),
        // child: StreamBuilder<QuerySnapshot>(
        //   stream: widget.ref,
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData) {
        //       return const Center(child: CircularProgressIndicator());
        //     }
        //     final documents = snapshot.data!.docs;
        //     return ListView.builder(
        //       itemCount: documents.length,
        //       itemBuilder: (context, index) {
        //         final document = documents[index];
        //         final data = document.data() as Map<String, dynamic>;
        //         if (data['isCleaner'] != true) {
        //           return const SizedBox.shrink();
        //         }
        //         return CleanerCard(
        //           cleaner: AppUser.fromMap(data),
        //         );
        //       },
        //     );
        //   },
        // ),
      ),
    );
  }
}
