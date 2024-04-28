// ignore_for_file: unused_local_variable, must_be_immutable, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:squeaky_app/components/messages_card.dart';
import 'package:squeaky_app/components/my_appbar.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/chat_page.dart';
import 'package:squeaky_app/services/chat_service.dart';

class CleanerMessagesPage extends StatefulWidget {
  final AppUser user; // AppUser object
  var currentPageIndex = 1;

  CleanerMessagesPage({super.key, required this.user}); // Constructor

  @override
  _CleanerMessagesPage createState() => _CleanerMessagesPage();
  Future<void> getData() async {
    final users = FirebaseFirestore.instance.collection('users');
    var doc = await users.doc(user.email).get();
  }
}

class _CleanerMessagesPage extends State<CleanerMessagesPage> {
  Future<void> _refreshData() async {
    // Add your logic to refresh the data here
    // For example, you can call the getData() method again
    await widget.getData();
    ChatService().updateChatRoomTimes(widget.user.email);
  }

  @override
  initState(){
    super.initState();
    widget.getData();
    ChatService().updateChatRoomTimes(widget.user.email);
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
          child: StreamBuilder<QuerySnapshot>(
            stream: ChatService().getChatRooms(widget.user.email),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('No messages..'));
              }
              final documents = snapshot.data!.docs;

              // Sort the documents by closest time to now
              documents.sort((a, b) {
                final aTime = a['unformattedTime'] as Timestamp;
                final bTime = b['unformattedTime'] as Timestamp;
                final now = Timestamp.now();

                final aDifference = (aTime.seconds - now.seconds).abs();
                final bDifference = (bTime.seconds - now.seconds).abs();

                return aDifference.compareTo(bDifference);
              });

              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final data = documents[index].data() as Map<String, dynamic>;
                  return MessagesCard(
                    customFunction: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                  receiverFirstName: data['customerFirstName'],
                                  recieverUserEmail: data['userEmails']
                                      ['customer'],
                                  user: widget.user)));
                    },
                    name: data['customerFirstName'],
                    lastMessage: data['lastMessage'],
                    time: data['formattedTime'],
                    recieverEmail: data['userEmails']['customer']
                  );
                },
              );
            },
          ),
        ));
  }
}
