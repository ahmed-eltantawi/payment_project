import 'package:dartz/dartz.dart';

abstract class PaymentInterface {
  Future<Either<String, void>> makePayment(
      {required double amount, required String currency});
}
