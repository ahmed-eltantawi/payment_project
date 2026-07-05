import 'dart:developer';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/payment/payment_interface.dart';
import 'package:payment_project/core/services/payment/stripe/payment_intent_model/payment_intent_model.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';

part "stripe_manager_interface.dart";

class StripeManager extends StripeManagerInterface {
  @override
  Future<PaymentIntentModel> _createPaymentIntent(
      {required double amount, required String currency}) async {
    log("create Payment Intent starts");
    final response = await getIt
        .get<DioConsumer>()
        .post("https://api.stripe.com/v1/payment_intents", data: {
      "amount": (amount * 100).toInt(),
      "currency": currency
    }, headers: {
      'Authorization': "Bearer ${Constants.stripeSecretKey}",
      "Content-Type": "application/x-www-form-urlencoded"
    });
    log("create Payment Intent ends");
    return PaymentIntentModel.fromJson(response);
  }

  @override
  Future<void> _initPaymentSheet(
      {required String paymentIntentClientSecret,
      required String merchantDisplayName}) async {
    log("init payment sheet starts");
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: merchantDisplayName));
    log("init payment sheet ends");
  }

  @override
  Future<void> _displayPaymentSheet() async {
    log("display payment sheet starts");
    await Stripe.instance.presentPaymentSheet();
    log("display payment sheet ends");
  }

  @override
  Future<void> makePayment({
    required context,
    required double amount,
    required String currency,
  }) async {
    log("========================make payment starts");
    final paymentIntentModel =
        await _createPaymentIntent(amount: amount, currency: currency);
    await _initPaymentSheet(
        paymentIntentClientSecret: paymentIntentModel.clientSecret!,
        merchantDisplayName: "Ahmed");
    await _displayPaymentSheet();
    log("======================make payment ends");
  }
}
