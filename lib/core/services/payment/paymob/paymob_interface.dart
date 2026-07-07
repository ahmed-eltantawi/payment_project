// ignore_for_file: unused_element
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_paymob_sdk/flutter_paymob_sdk.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/payment/payment_interface.dart';
import 'package:payment_project/core/services/payment/paymob/paymob_intention_model/paymob_intention_model.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';
part "paymob_manager.dart";

abstract class PaymobInterface extends PaymentInterface {
  @override
  Future<Either<String, void>> makePayment({
    required context,
    required double amount,
    required String currency,
  });

  Future<String> _getClientSecret(
      {required double amount,
      required String currency,
      required List<int> paymentMethodsIds});

  Future<String?> _launchThePaymentSDK({
    required String clientSecret,
  });
}
