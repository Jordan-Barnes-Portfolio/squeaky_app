import 'package:squeaky_app/objects/appointment.dart';

class Message {
  final String senderEmail;
  final String recieverEmail;
  final String cleanerEmail;
  final String customerEmail;
  final String message;
  final bool containsQuote;
  final bool containsInvoice;
  final bool systemMessage;
  final DateTime timestamp;
  final Appointment ?appointment;

  Message({
    required this.senderEmail,
    required this.recieverEmail,
    required this.cleanerEmail,
    required this.customerEmail,
    required this.message,
    required this.timestamp,
    this.containsQuote = false,
    this.containsInvoice = false,
    this.systemMessage = false,
    this.appointment,
    
  });

  // convert to a map
  Map<String, dynamic> toMap() {
    return {
      'recieverEmail': recieverEmail,
      'senderEmail': senderEmail,
      'cleanerEmail': cleanerEmail,
      'customerEmail': customerEmail,
      'message': message,
      'timestamp': timestamp,
      'containsQuote': containsQuote,
      'containsInvoice': containsInvoice,
      'systemMessage': systemMessage,
      'appointment': appointment?.toMap()
    };
  }
}
