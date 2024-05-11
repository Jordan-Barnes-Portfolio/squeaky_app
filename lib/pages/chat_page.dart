// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_chat_bubble.dart';
import 'package:squeaky_app/components/my_chat_button.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/invoice.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/services/appointment_service.dart';
import 'package:squeaky_app/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;
  final String receiverFirstName;
  final AppUser user;
  final String initialMessage;
  final Appointment appointment;

  const ChatPage(
      {super.key,
      required this.receiverFirstName,
      required this.recieverUserEmail,
      required this.user,
      required this.initialMessage,
      required this.appointment});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final ScrollController _controller = ScrollController();
  TextEditingController quoteController = TextEditingController();
  TextEditingController appointmentController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  int? selectedHours = 1;

  @override
  void initState() {
    super.initState();

    if (widget.initialMessage.isNotEmpty) {
      if (widget.appointment.formattedDate != '') {
        _chatService.sendMessage(widget.recieverUserEmail,
            widget.initialMessage, widget.user, true, false, false, null);
        return;
      }

      _chatService.sendMessage(widget.recieverUserEmail, widget.initialMessage,
          widget.user, false, false, false, null);
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.animateTo(0.0,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      }
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final String message = _messageController.text;
      await _chatService.sendMessage(widget.recieverUserEmail, message,
          widget.user, false, false, false, null);
      _messageController.clear();
    }
  }

  void createInvoice(Appointment appointment) async {
    String subTotal =
        (appointment.invoice!.pricing * appointment.invoice!.hours)
            .toStringAsFixed(2);
    String taxesString = appointment.invoice!.taxes.toStringAsFixed(2);
    String totalString = appointment.invoice!.total.toStringAsFixed(2);
    String neatFreakGuaranteeString =
        appointment.invoice!.neatFreakGuarantee.toStringAsFixed(2);

    showModalBottomSheet(
      barrierColor: Color(const Color.fromARGB(196, 238, 238, 238).value),
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      backgroundColor: Colors.grey[200],
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) => Scaffold(
          backgroundColor: Colors.grey[200],
          body: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'View invoice',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: TextField(
                        controller: TextEditingController.fromValue(
                            TextEditingValue(
                                text: appointment.formattedDate,
                                selection: TextSelection.collapsed(
                                    offset: appointment.formattedDate.length))),
                        onTapOutside: (event) => FocusManager
                            .instance.primaryFocus
                            ?.unfocus(), //close keyboard when tapped outside
                        readOnly: true,
                        onTap: () => {},
                        decoration: const InputDecoration(
                          labelText: 'Date and Time of Appointment',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        'Quote:\n${appointment.invoice!.pricing} per hour * (${appointment.invoice!.hours}): $subTotal\nNeat Freak Guarantee: \$$neatFreakGuaranteeString\nTaxes and Fees: \$$taxesString\nTotal: \$$totalString',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 20),
                    widget.user.isCleaner
                        ? const SizedBox()
                        : MyButton(
                            onPressed: () {
                              Navigator.pop(context);
                              appointment.invoice?.customerName =
                                  '${widget.user.firstName} ${widget.user.lastName[0]}.';
                              appointment.invoice?.cleanerName =
                                  widget.receiverFirstName;
                              AppointmentService()
                                  .createAppointment(appointment, widget.user);
                            },
                            text: 'Continue to payment',
                            color: Colors.blue[300]!,
                          ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void createQuote(Appointment appointment) async {
    detailsController.text = appointment.details;
    appointmentController.text = appointment.formattedDate;

    num? currentPrice = widget.user.pricing * selectedHours!;
    num? neatFreakGuarantee = currentPrice * 0.15;
    num? total = currentPrice + neatFreakGuarantee;
    num? taxes = total * 0.065;
    String taxesString = taxes.toStringAsFixed(2);
    String totalString = total.toStringAsFixed(2);
    String neatFreakGuaranteeString = neatFreakGuarantee.toStringAsFixed(2);

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day, now.hour + 1);

    DateTime initialDateTime = DateTime.parse(appointment.unformattedDate);
    initialDateTime = DateTime(date.year, initialDateTime.month,
        initialDateTime.day, initialDateTime.hour, initialDateTime.minute);
    appointment.unformattedDate = initialDateTime.toString();

    showModalBottomSheet(
      barrierColor: Color(const Color.fromARGB(196, 238, 238, 238).value),
      isScrollControlled: true,
      showDragHandle: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      backgroundColor: Colors.grey[200],
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setState) => Scaffold(
          backgroundColor: Colors.grey[200],
          body: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Create Quote',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: TextField(
                        onTapOutside: (event) => FocusManager
                            .instance.primaryFocus
                            ?.unfocus(), //close keyboard when tapped outside
                        controller: appointmentController,
                        readOnly: false,
                        onTap: () => {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    surfaceTintColor: Colors.transparent,
                                    child: SizedBox(
                                        height: 200,
                                        width: 300,
                                        child: CupertinoDatePicker(
                                            initialDateTime: initialDateTime,
                                            minimumDate: date,
                                            maximumDate: date
                                                .add(const Duration(days: 31)),
                                            onDateTimeChanged:
                                                (DateTime newDateTime) {
                                              setState(() {
                                                appointmentController.text =
                                                    '${DateFormat('EEEE, MMMM dd').format(newDateTime)} at ${DateFormat('hh:mm a').format(newDateTime)}';
                                                appointment.unformattedDate =
                                                    newDateTime.toString();
                                                appointment.formattedDate =
                                                    appointmentController.text;
                                              });
                                            },
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            minuteInterval: 15,
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    195, 238, 238, 238))),
                                  ))
                        },
                        decoration: const InputDecoration(
                          labelText: 'Date and Time of Appointment',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        const Text('Estimated time to complete:',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 20),
                        DropdownButton<int>(
                          menuMaxHeight: 150,
                          value: selectedHours,
                          onChanged: (value) {
                            setState(() {
                              selectedHours = value;
                              currentPrice =
                                  widget.user.pricing * selectedHours!;

                              neatFreakGuarantee = (currentPrice! * 0.15);
                              neatFreakGuaranteeString =
                                  neatFreakGuarantee!.toStringAsFixed(2);

                              total = currentPrice! + neatFreakGuarantee!;
                              totalString = total!.toStringAsFixed(2);

                              taxes = total! * 0.065;
                              taxesString = taxes!.toStringAsFixed(2);
                            });
                          },
                          items: List.generate(12, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: index < 1
                                  ? Text("${index + 1} hour")
                                  : Text("${index + 1} hours"),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        'Quote: \n\$${widget.user.pricing} per hour * ($selectedHours) = \$$currentPrice \nNeat Freak Guarantee = \$$neatFreakGuaranteeString\nTaxes and Fees: \$$taxesString\nTotal: \$$totalString',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                      onPressed: () {
                        Navigator.pop(context);
                        //Create appointment and send quote here
                        Invoice invoice = Invoice(
                            total: total!,
                            taxes: taxes!,
                            neatFreakGuarantee: neatFreakGuarantee!,
                            tip: 0,
                            customerEmail: widget.recieverUserEmail,
                            cleanerEmail: widget.user.email,
                            hours: selectedHours!,
                            pricing: widget.user.pricing,
                            cleaner: widget.user);

                        appointment.invoice = invoice;

                        _chatService.sendMessage(widget.recieverUserEmail, '',
                            widget.user, false, true, false, appointment);
                      },
                      text: 'Send Quote',
                      color: Colors.blue[300]!,
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyGnavBar(currentPageIndex: 1, user: widget.user),
      appBar: AppBar(
        title: Text(widget.receiverFirstName),
        backgroundColor: Colors.grey[100],
        shadowColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 5,
      ),
      body: Column(
          //messages
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _chatService.getMessages(
                    widget.user.email, widget.recieverUserEmail),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(reverse: true, children: [
                    for (var document in snapshot.data!.docs.reversed)
                      document['containsQuote'] || document['containsInvoice']
                          ? _designateBuildItem(document)
                          : _buildMessageItem(document),
                  ]);
                },
              ),
            ),
            //user input
            Padding(
                padding: const EdgeInsets.all(8), child: _buildMessageInput())
          ]),
    );
  }

  Widget _designateBuildItem(DocumentSnapshot document) {
    if (document['containsQuote']) {
      return _buildMessageItemWithQuoteButton(document);
    } else {
      return _buildMessageItemWithInvoiceButton(document);
    }
  }

  Widget _buildMessageItemWithInvoiceButton(document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
          child: MyChatButton(
            text: 'View Quote',
            color: const Color.fromARGB(255, 33, 177, 243),
            onPressed: () {
              try{
              Invoice invoice = Invoice(
                  total: data['appointment']['invoice']['total'],
                  hours: data['appointment']['invoice']['hours'],
                  pricing: data['appointment']['invoice']['pricing'],
                  taxes: data['appointment']['invoice']['taxes'],
                  neatFreakGuarantee: data['appointment']['invoice']['neatFreakGuarantee'],
                  tip: data['appointment']['invoice']['tip'],
                  customerEmail: data['appointment']['invoice']['customerEmail'],
                  cleanerEmail: data['appointment']['invoice']['cleanerEmail'],
                  customerName: data['appointment']['invoice']['customerName'],
                  cleanerName: data['appointment']['invoice']['cleanerName'],
                  cleaner: AppUser.fromMap(data['appointment']['invoice']['cleaner'])
              );


              Appointment appointment = Appointment(
                  unformattedDate: data['appointment']['unformattedDate'],
                  formattedDate: data['appointment']['formattedDate'],
                  details: data['appointment']['details'],
                  sortByDate: Timestamp.fromDate(
                      DateTime.parse(data['appointment']['unformattedDate'])),
                  invoice: invoice,
                  status: 'scheduled');

              createInvoice(appointment);
              } catch(e){
                print('${e} HEHEEEEERRRRRRRRRRRRRRREEEEEEEEEE');
              }
            },
          ),
        ),
      ],
    );
  }

  //build the message items
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align messages to the right and left
    var alignment = data['senderEmail'] == widget.user.email
        ? Alignment.centerRight
        : Alignment.centerLeft;

    if (data['systemMessage'] != null && data['systemMessage'] == true) {
      return Container(
        alignment: alignment,
        child: Column(
          children: [
            ChatBubble(
              message: data['message'],
              color: Colors.grey,
            ),
          ],
        ),
      );
    }

    Color bubbleColor = alignment == Alignment.centerRight
        ? const Color.fromARGB(255, 33, 177, 243)
        : const Color.fromARGB(255, 62, 62, 62);
    return Container(
      alignment: alignment,
      child: Column(
        children: [
          ChatBubble(
            message: data['message'],
            color: bubbleColor,
          ),
        ],
      ),
    );
  }

  //build the message items
  Widget _buildMessageItemWithQuoteButton(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align messages to the right and left
    var alignment = data['senderEmail'] == widget.user.email
        ? Alignment.centerRight
        : Alignment.centerLeft;

    //set different colors for different alignments
    Color bubbleColor = alignment == Alignment.centerRight
        ? const Color.fromARGB(255, 33, 177, 243)
        : const Color.fromARGB(255, 62, 62, 62);

    if (widget.user.email != data['cleanerEmail']) {
      return Container(
        alignment: alignment,
        child: Column(
          children: [
            ChatBubble(
              message: data['message'],
              color: bubbleColor,
            ),
          ],
        ),
      );
    }

    String checkAgainst =
        data['message'].toString().split('Date: ')[1].split('. ')[0];
    checkAgainst =
        '${checkAgainst.split('at ')[0]}${checkAgainst.split('at ')[1].split(' ')[0]} ${checkAgainst.split('at ')[1].split(' ')[1]}';
    DateTime unformattedDateTime =
        DateFormat('EEEE, MMMM dd hh:mm a').parse(checkAgainst);

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(data['message'],
              style: const TextStyle(fontSize: 14, color: Colors.white)),
          const SizedBox(height: 10),
          MyChatButton(
            text: 'Create Quote',
            color: const Color.fromARGB(255, 33, 177, 243),
            onPressed: () {
              Appointment appointment = Appointment(
                  unformattedDate: unformattedDateTime.toString(),
                  formattedDate: data['message']
                      .toString()
                      .split('Date: ')[1]
                      .split('. ')[0],
                  details: data['message'].toString(),
                  sortByDate: null,
                  invoice: null,
                  status: 'scheduled');
              createQuote(appointment);
            },
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  //build the input field for messages
  Widget _buildMessageInput() {
    return Row(children: [
      Expanded(
        child: TextField(
          textAlign: TextAlign.left,
          onTapOutside: (PointerDownEvent event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          controller: _messageController,
          decoration: const InputDecoration(
              hintText: 'Type a message',
              contentPadding: EdgeInsets.fromLTRB(15, 5, 5, 5),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)))),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.send),
        onPressed: sendMessage,
      ),
    ]);
  }
}

extension DateTimeFromTimeOfDay on DateTime {
  DateTime appliedFromTimeOfDay(TimeOfDay timeOfDay) {
    return DateTime.utc(year, month, day, timeOfDay.hour, timeOfDay.minute);
  }
}
