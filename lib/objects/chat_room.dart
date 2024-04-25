import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final Map<String, String> userEmails;
  final List<String> users;
  final String cleanerFirstName;
  final String customerFirstName;
  final String lastMessage;
  final String formattedTime;
  final Timestamp unformattedTime; 

  Chat({
    required this.userEmails,
    required this.users,
    required this.cleanerFirstName,
    required this.customerFirstName,
    required this.unformattedTime,
    this.lastMessage = "",
    this.formattedTime = "",
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'userEmails': userEmails,
      'users': users,
      'cleanerFirstName': cleanerFirstName,
      'customerFirstName': customerFirstName,
      'lastMessage': lastMessage,
      'unformattedTime': unformattedTime,
      'formattedTime': formattedTime,
    };
  }
}
