import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neatfreak/api/firebase_api.dart';
import 'package:neatfreak/objects/appointment.dart';
import 'package:neatfreak/objects/chat_room.dart';
import 'package:neatfreak/objects/message.dart';
import 'package:neatfreak/objects/user.dart';

class ChatService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SENDING A MESSAGE
  Future<void> sendMessage(
      String recieverEmail,
      String message,
      AppUser user,
      bool containsQuote,
      bool containsInvoice,
      bool systemMessage,
      Appointment? appointment) async {
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
      cleanerEmail: usersList['cleaner']!,
      customerEmail: usersList['customer']!,
      message: message,
      timestamp: timestamp,
      containsQuote: containsQuote,
      containsInvoice: containsInvoice,
      systemMessage: systemMessage,
      appointment: appointment,
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
    QuerySnapshot snapshot = await _firestore.collection('users').get();

    var customer = snapshot.docs
        .firstWhere((element) => element.id == usersList['customer']);
    var cleaner = snapshot.docs
        .firstWhere((element) => element.id == usersList['cleaner']);

    if (user.fcmToken != customer['fcmToken']) {
      await FirebaseApi().sendNotification(customer['fcmToken']);
    } else {
      await FirebaseApi().sendNotification(cleaner['fcmToken']);
    }

    bool seenByCleaner = user.isCleaner;
    bool seenByCustomer = user.isCustomer;

    if (!chatRoom.exists) {
      Chat newChat = Chat(
        userEmails: usersList,
        users: [user.email, recieverEmail],
        customerFirstName: customer['firstName'],
        cleanerFirstName: cleaner['firstName'],
        lastMessage: message,
        formattedTime: readTimestamp(timestamp.millisecondsSinceEpoch),
        unformattedTime: Timestamp.now(),
        seenByCleaner: seenByCleaner,
        seenByCustomer: seenByCustomer,
      );
      await chats.set(newChat.toMap());
    } else {
      var time = readTimestamp(timestamp.millisecondsSinceEpoch);
      updateChatRoom(chatRoom, message, time, customer['firstName'],
          cleaner['firstName'], seenByCleaner, seenByCustomer);
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
        .orderBy('orderBy')
        .snapshots();
  }

  //GETTING ALL CHATS
  Stream<QuerySnapshot> getChatRooms(String userId) {
    return _firestore
        .collection('chats')
        .where('users', arrayContains: userId)
        .snapshots();
  }

  void updateChatRoom(
      DocumentSnapshot<Map<String, dynamic>> chatRoom,
      String message,
      String timestamp,
      String customerFirstName,
      String cleanerFirstName,
      bool seenByCleaner,
      bool seenByCustomer) {
    chatRoom.reference.update({
      'customerFirstName': customerFirstName,
      'cleanerFirstName': cleanerFirstName,
      'lastMessage': message,
      'formattedTime': timestamp.toString(),
      'unformattedTime': Timestamp.now(),
      'seenByCleaner': seenByCleaner,
      'seenByCustomer': seenByCustomer,
    });
  }

  void updateChatRoomSeenBy(String type, String chatRoomId) {
    _firestore.collection('chats').doc(chatRoomId).get().then((value) {
      if (type == 'customer') {
        value.reference.update({'seenByCustomer': true});
      } else {
        value.reference.update({'seenByCleaner': true});
      }
    });
  }

  String readTimestamp(int timestamp) {
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
    var now = DateTime.now();
    var yesterday = DateTime(now.year, now.month, now.day - 1);
    var twoDaysAgo = DateTime(now.year, now.month, now.day - 2);

    if (date.day == now.day &&
        date.month == now.month &&
        date.year == now.year) {
      return format.format(date);
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday';
    } else if (date.isAfter(twoDaysAgo)) {
      return DateFormat('EEEE, dd MMMM').format(date);
    } else if (date.year != now.year) {
      return DateFormat('EEEE, dd MMMM yyyy').format(date);
    } else {
      return DateFormat('EEEE, dd MMMM').format(date);
    }
  }

  void deleteAllChats() async {
    try {
      print('starting hat deletion...');
      try {
        await FirebaseFirestore.instance
            .collection('chats')
            .snapshots()
            .forEach((element) {
          for (var doc in element.docs) {
            print('Deleted chat: ${doc.id}');
            doc.reference.delete();
          }
        });
      } catch (e) {
        print('error deleting chat: $e');
      }

    } on Exception catch (e) {
      print('exception thrown..');
      throw Exception(e.toString());
    }
  }

  Future<void> updateChatRoomTimes(String userId) async {
    QuerySnapshot snapshot = await _firestore.collection('chats').get();
    for (var element in snapshot.docs) {
      if (element['users'].contains(userId)) {
        element.reference.update({
          'formattedTime':
              readTimestamp(element['unformattedTime'].millisecondsSinceEpoch),
        });
      }
    }
  }
}
