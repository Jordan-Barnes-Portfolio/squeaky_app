class Message {
  final String senderEmail;
  final String recieverEmail;
  final String message;
  final DateTime timestamp;

  Message({
    required this.senderEmail,
    required this.recieverEmail,
    required this.message,
    required this.timestamp,
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'recieverEmail': recieverEmail,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
