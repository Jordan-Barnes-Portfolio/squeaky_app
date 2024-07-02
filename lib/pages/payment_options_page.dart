import 'package:flutter/material.dart';
import 'package:neatfreak/components/my_button.dart';
import 'package:neatfreak/components/my_gnav_bar.dart';
import 'package:neatfreak/objects/appointment.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/services/payment_service.dart';

class PaymentOptionsPage extends StatefulWidget {
  final AppUser user;
  final Appointment appointment;

  const PaymentOptionsPage(
      {super.key, required this.user, required this.appointment});

  @override
  State<PaymentOptionsPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentOptionsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String subTotal = (widget.appointment.invoice!.pricing *
            widget.appointment.invoice!.hours)
        .toStringAsFixed(2);
    String stateTaxes = (widget.appointment.invoice!.pricing *
            widget.appointment.invoice!.hours *
            0.07)
        .toStringAsFixed(2);
    String stripeFeeString =
        ((num.parse(subTotal)) * 0.029 + 0.30).toStringAsFixed(2);

    String totalString = widget.appointment.invoice!.total.toStringAsFixed(2);
    String neatFreakGuaranteeString =
        widget.appointment.invoice!.neatFreakGuarantee.toStringAsFixed(2);

    Future<void> initPaymentSheet(BuildContext context) async {
      try {
        PaymentService()
            .stripeMakeCreditPayment(widget.appointment.invoice!.total, 'usd', context, widget.appointment, widget.user);
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        rethrow;
      }
    }

    return Scaffold(
        bottomNavigationBar: MyGnavBar(currentPageIndex: -1, user: widget.user),
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: Colors.grey[100],
          shadowColor: Colors.black,
          surfaceTintColor: Colors.transparent,
          elevation: 5,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          //logo
          const Image(
              image: AssetImage('lib/assets/logo.png'),
              height: 200,
              width: 300),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: TextField(
              controller: TextEditingController.fromValue(TextEditingValue(
                  text: widget.appointment.formattedDate,
                  selection: TextSelection.collapsed(
                      offset: widget.appointment.formattedDate.length))),
              onTapOutside: (event) => FocusManager.instance.primaryFocus
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
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Text(
              '${widget.appointment.invoice!.pricing} per hour * ${widget.appointment.invoice!.hours} hr/s: \$$subTotal\nTaxes and Fees: \n    Neat Freak Guarantee: \$$neatFreakGuaranteeString\n    Stripe: \$${stripeFeeString} \n    State/Local: \$${stateTaxes}\nTotal: \$$totalString',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 10),
          MyButton(
            onPressed: () async {
              try {
                await initPaymentSheet(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            text: 'Checkout with Stripe',
            color: Colors.blue,
          ),
        ]));
  }
}
