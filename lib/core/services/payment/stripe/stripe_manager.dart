import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_project/core/cache/cache_helper.dart';
import 'package:payment_project/core/cache/cache_keys.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/payment/payment_interface.dart';
import 'package:payment_project/core/services/payment/stripe/payment_intent_model/payment_intent_model.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';

part "stripe_manager_interface.dart";

class StripeManager extends StripeManagerInterface {
  static const String _baseUrl = "https://api.stripe.com/v1/";
  @override
  Future<PaymentIntentModel> _createPaymentIntent(
      {required double amount, required String currency}) async {
    log("create Payment Intent starts");
    final response = await getIt
        .get<DioConsumer>()
        .post("${_baseUrl}payment_intents", data: {
      "amount": (amount * 100).toInt(),
      "currency": currency
    }, headers: {
      'Authorization': "Bearer ${Constants.stripeSecretKey}",
      Headers.contentTypeHeader: Headers.formUrlEncodedContentType
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
  Future<Either<String, void>> makePayment({
    required context,
    required double amount,
    required String currency,
  }) async {
    try {
      final paymentIntentModel =
          await _createPaymentIntent(amount: amount, currency: currency);
      await _initPaymentSheet(
          paymentIntentClientSecret: paymentIntentModel.clientSecret!,
          merchantDisplayName: "Ahmed");
      await _displayPaymentSheet();
      return right(null);
    } on Exception catch (e) {
      return left(e.toString());
    }
  }

  /// Get Customer Id from Stripe API
  /// Use it in Sing up, and log in and save it in Secure Storage
  Future<void> createCustomerId(
      {String? email, String? name, String? phone}) async {
    final response =
        await getIt.get<DioConsumer>().post("${_baseUrl}customers", data: {
      "email": email,
      "name": name,
      "phone": phone
    }, headers: {
      'Authorization': "Bearer ${Constants.stripeSecretKey}",
      Headers.contentTypeHeader: Headers.formUrlEncodedContentType
    });
    final String id = response["id"];
    await getIt
        .get<CacheHelper>()
        .saveSecureData(key: CacheKeys.customerId, value: id);
  }
}
