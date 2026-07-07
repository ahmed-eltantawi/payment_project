import 'package:dartz/dartz.dart';
import 'package:payment_project/core/services/payment/payment_interface.dart';

class PayPalManger extends PaymentInterface {
  @override
  Future<Either<String, void>> makePayment(
      {required double amount, required String currency}) {
    // TODO: implement makePayment
    throw UnimplementedError();
  }
}
