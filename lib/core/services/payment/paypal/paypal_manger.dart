import 'package:payment_project/core/services/payment/payment_interface.dart';

class PayPalManger extends PaymentInterface {
  @override
  Future<void> makePayment(
      {required context, required double amount, required String currency}) {
    // TODO: implement makePayment
    throw UnimplementedError();
  }
}
