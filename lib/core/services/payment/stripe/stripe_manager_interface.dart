part of "stripe_manager.dart";

abstract class StripeManagerInterface {
  Future<PaymentIntentModel> createPaymentIntent(
      {required double amount, required String currency});

  Future<void> initPaymentSheet(
      {required String paymentIntentClientSecret,
      required String merchantDisplayName});

  Future<void> displayPaymentSheet();
}
