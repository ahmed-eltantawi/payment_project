import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/payment/stripe/payment_intent_model/payment_intent_model.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';

part "stripe_manager_interface.dart";

class StripeManager extends StripeManagerInterface {
  @override
  Future<PaymentIntentModel> createPaymentIntent(
      {required double amount, required String currency}) async {
    final response = await getIt.get<DioConsumer>().post(
        "https://api.stripe.com/v1/payment_intents",
        data: {"amount": amount, "currency": currency},
        headers: {'Authorization': "Bearer ${Constants.stripeSecretKey}"});
    return PaymentIntentModel.fromJson(response);
  }

  @override
  Future<void> initPaymentSheet(
      {required String paymentIntentClientSecret,
      required String merchantDisplayName}) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: merchantDisplayName));
  }
}
