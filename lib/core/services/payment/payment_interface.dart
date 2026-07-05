abstract class PaymentInterface {
  Future<void> makePayment(
      {required context, required double amount, required String currency});
}
