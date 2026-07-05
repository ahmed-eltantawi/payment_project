part of "stripe_manager.dart";

abstract class StripeManagerInterface {
  Future<PaymentIntentModel> createPaymentIntent(
      {required double amount, required String currency});
}
