// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:squeaky_app/components/my_button.dart';
import 'package:squeaky_app/components/my_gnav_bar.dart';
import 'package:squeaky_app/objects/appointment.dart';
import 'package:squeaky_app/objects/user.dart';
import 'package:squeaky_app/pages/chat_page.dart';

class PastAppointmentDetailsPage extends StatefulWidget {
  final AppUser user; // AppUser object
  final Appointment appointment;
  var currentPageIndex = -1;

  PastAppointmentDetailsPage(
      {super.key,
      required this.user,
      required this.appointment}); // Constructor

  @override
  _PastAppointmentDetailsPage createState() => _PastAppointmentDetailsPage();
}

class _PastAppointmentDetailsPage extends State<PastAppointmentDetailsPage> {
  TextEditingController detailsController = TextEditingController();
  TextEditingController appointmentTimeController = TextEditingController();
  TextEditingController appointmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String subTotal = (widget.appointment.invoice!.pricing *
            widget.appointment.invoice!.hours)
        .toStringAsFixed(2);
    String taxesString = widget.appointment.invoice!.taxes.toStringAsFixed(2);
    String totalString = widget.appointment.invoice!.total.toStringAsFixed(2);
    String neatFreakGuaranteeString =
        widget.appointment.invoice!.neatFreakGuarantee.toStringAsFixed(2);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: widget.user.isCustomer
              ? Text(
                  'Cleaning with ${widget.appointment.invoice!.cleanerName}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              : const Text(
                  'Appointment Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
          backgroundColor: Colors.grey[100],
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 5,
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: MyGnavBar(
            currentPageIndex: widget.currentPageIndex, user: widget.user),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            const Text(
              'Appointment Time',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Divider(),
            //show the appointment time
            Text(widget.appointment.formattedDate),
            const SizedBox(height: 15),
            const Text(
              'Appointment Message',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Divider(),
            //show the appointment details
            Text(widget.appointment.details),
            const SizedBox(height: 15),
            const Text(
              'Appointment Status',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Divider(),
            //show the appointment status
            Text(widget.appointment.status),
            const SizedBox(height: 15),
            const Text(
              'Appointment Cost',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Divider(),
            //show the appointment cost
            Text(
              '${widget.appointment.invoice!.pricing} per hour * (${widget.appointment.invoice!.hours}): $subTotal\nNeat Freak Guarantee: \$$neatFreakGuaranteeString\nTaxes and Fees: \$$taxesString\nTotal: \$$totalString',
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 10),
            widget.user.isCleaner
                ? MyButton(
                    onPressed: () => {
                      //navigate to the cleaner chat page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: widget.user,
                            appointment: widget.appointment,
                            receiverFirstName:
                                widget.appointment.invoice!.customerName,
                            recieverUserEmail:
                                widget.appointment.invoice!.customerEmail,
                            initialMessage: '',
                          ),
                        ),
                      ),
                    },
                    text: 'Chat with Customer',
                    color: Colors.blue,
                  )
                : MyButton(
                    onPressed: () => {
                      //navigate to the cleaner chat page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            user: widget.user,
                            appointment: widget.appointment,
                            receiverFirstName:
                                widget.appointment.invoice!.cleanerName,
                            recieverUserEmail:
                                widget.appointment.invoice!.cleanerEmail,
                            initialMessage: '',
                          ),
                        ),
                      ),
                    },
                    text: 'Chat with Cleaner',
                    color: Colors.blue,
                  )
          ],
        ))));
  }
}
