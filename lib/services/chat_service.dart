import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:squeaky_app/objects/chat_room.dart';
import 'package:squeaky_app/objects/message.dart';
import 'package:squeaky_app/objects/user.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SENDING A MESSAGE
  Future<void> sendMessage(
      String recieverEmail, String message, AppUser user) async {
    //get current user info
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final DateTime timestamp = DateTime.now();
    final Map<String, String> usersList;

    if (user.isCleaner) {
      usersList = {
        'cleaner': user.email,
        'customer': recieverEmail,
      };
    } else {
      usersList = {
        'cleaner': recieverEmail,
        'customer': user.email,
      };
    }

    //create a new message
    Message newMessage = Message(
      recieverEmail: recieverEmail,
      senderEmail: currentUserEmail,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room id from current user id and receiver id (sorted to avoid duplicates)
    List<String> ids = [currentUserEmail, recieverEmail];
    ids.sort();
    String chatRoomId = ids.join('_');

    //add message to database=
    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());

    //add chat room to database
    var chats = _firestore.collection('chats').doc(chatRoomId);
    var chatRoom = await chats.get();
    if (!chatRoom.exists) {
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      var customer = snapshot.docs
          .firstWhere((element) => element.id == usersList['customer']);
      var cleaner = snapshot.docs
          .firstWhere((element) => element.id == usersList['cleaner']);

      Chat newChat = Chat(
        userEmails: usersList,
        users: [user.email, recieverEmail],
        customerFirstName: customer['firstName'],
        cleanerFirstName: cleaner['firstName'],
        lastMessage: message,
        formattedTime:readTimestamp(timestamp.millisecondsSinceEpoch),
        unformattedTime: Timestamp.now(),
      );
      await chats.set(newChat.toMap());
    } else {
      var time = readTimestamp(timestamp.millisecondsSinceEpoch);
      updateChatRoom(chatRoom, message, time);
    }
  }

  // GETTING A MESSAGE
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join('_');

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  //GETTING ALL CHATS
  Stream<QuerySnapshot> getChatRooms(String userId) {
    return _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .snapshots();
  }

  void updateChatRoom(DocumentSnapshot<Map<String, dynamic>> chatRoom,
      String message, String timestamp) {
    chatRoom.reference.update({
      'lastMessage': message,
      'formattedTime': timestamp.toString(),
      'unformattedTime': Timestamp.now(),
    });
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = '${diff.inDays}DAY AGO';
      } else {
        time = '${diff.inDays}DAYS AGO';
      }
    }
    return time;
  }
}