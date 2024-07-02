import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:neatfreak/objects/appointment.dart';
import 'package:neatfreak/objects/user.dart';
import 'package:neatfreak/services/appointment_service.dart';

class PaymentService {
  Map<String, dynamic>? paymentIntent;

  Future<void> stripeMakeCreditPayment(num amount, String currency, BuildContext context, Appointment appointment, AppUser user) async {
    try {
      paymentIntent =
          await createPaymentIntent(amount.toStringAsFixed(2), 'usd');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Neat Freak'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet(context, appointment, user);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  displayPaymentSheet(BuildContext context, Appointment appointment, AppUser user) async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment succesfully completed');
      
      Navigator.pop(context);

      AppointmentService().createAppointment(appointment, user);

    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      print('Trying to create payment post request');
      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount.split('.')[0]) * 100) +
        int.parse(amount.split('.')[1]);
    return calculatedAmount.toString();
  }
}
