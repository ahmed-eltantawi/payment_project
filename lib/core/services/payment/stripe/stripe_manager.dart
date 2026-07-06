import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_project/core/cache/cache_helper.dart';
import 'package:payment_project/core/cache/cache_keys.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/payment/payment_interface.dart';
import 'package:payment_project/core/services/payment/stripe/customer_session_model.dart';
import 'package:payment_project/core/services/payment/stripe/payment_intent_model/payment_intent_model.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';

part "stripe_manager_interface.dart";

class StripeManager extends StripeManagerInterface {
  static const String _baseUrl = "https://api.stripe.com/v1/";
  static const String _stripeVersion = "2026-06-24.dahlia";
  final headers = {
    'Authorization': "Bearer ${Constants.stripeSecretKey}",
    'Stripe-Version': _stripeVersion,
    Headers.contentTypeHeader: Headers.formUrlEncodedContentType
  };
  @override
  Future<PaymentIntentModel> _createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    log("create Payment Intent starts");
    final response =
        await getIt.get<DioConsumer>().post("${_baseUrl}payment_intents",
            data: {
              "amount": (amount * 100).toInt(),
              "currency": currency,
              "customer": await getIt
                  .get<CacheHelper>()
                  .getSecureData(key: CacheKeys.customerId),
            },
            headers: headers);
    log("create Payment Intent ends");
    return PaymentIntentModel.fromJson(response);
  }

  @override
  Future<void> _initPaymentSheet(
      {required String paymentIntentClientSecret,
      required String merchantDisplayName,
      CustomerSessionModel? customerSessionModel}) async {
    log("init payment sheet starts");
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: merchantDisplayName,
            customerId: customerSessionModel?.customerId,
            customerEphemeralKeySecret:
                customerSessionModel?.customerEphemeralKeySecret));
    log("init payment sheet ends");
  }

  @override
  Future<void> _displayPaymentSheet() async {
    log("display payment sheet starts");
    await Stripe.instance.presentPaymentSheet();
    log("display payment sheet ends");
  }

  /// Get Customer Id from Stripe API
  /// Use it in Sing up, and log in and save it in Secure Storage
  Future<String> _createCustomer(
      {String? email, String? name, String? phone}) async {
    final response = await getIt.get<DioConsumer>().post("${_baseUrl}customers",
        data: {"email": email, "name": name, "phone": phone}, headers: headers);
    final String id = response["id"];
    await getIt
        .get<CacheHelper>()
        .saveSecureData(key: CacheKeys.customerId, value: id);
    return id;
  }

  Future<CustomerSessionModel> _getEphemeralKey() async {
    final String customerId = await _createCustomer();

    final response =
        await getIt.get<DioConsumer>().post("${_baseUrl}ephemeral_keys",
            data: {
              "customer": customerId,
            },
            headers: headers);
    return CustomerSessionModel(
        customerEphemeralKeySecret: response["secret"], customerId: customerId);
  }

  @override

  /// This is the main function to make payment
  Future<Either<String, void>> makePayment({
    required context,
    required double amount,
    required String currency,
  }) async {
    try {
      final CustomerSessionModel customerSessionModel =
          await _getEphemeralKey();
      final paymentIntentModel =
          await _createPaymentIntent(amount: amount, currency: currency);
      await _initPaymentSheet(
          paymentIntentClientSecret: paymentIntentModel.clientSecret!,
          merchantDisplayName: "Ahmed",
          customerSessionModel: customerSessionModel);
      await _displayPaymentSheet();
      return right(null);
    } on Exception catch (e) {
      return left(e.toString());
    }
  }
}
