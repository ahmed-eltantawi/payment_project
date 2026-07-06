// ignore_for_file: unused_element

part of "stripe_manager.dart";

abstract class StripeManagerInterface extends PaymentInterface {
  Future<PaymentIntentModel> _createPaymentIntent(
      {required double amount, required String currency});

  Future<void> _initPaymentSheet(
      {required String paymentIntentClientSecret,
      required String merchantDisplayName});

  Future<void> _displayPaymentSheet();

  Future<CustomerSessionModel> _getEphemeralKey();

  Future<String> _createCustomer({String? email, String? name, String? phone});
}
