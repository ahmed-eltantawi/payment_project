import 'package:dartz/dartz.dart';

abstract class PaymentInterface {
  Future<Either<String, void>> makePayment(
      {required context, required double amount, required String currency});
}
