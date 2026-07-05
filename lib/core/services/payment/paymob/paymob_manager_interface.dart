part of 'paymob_manager.dart';

abstract class PaymobManagerInterface {
  Future<Either<String, String>> _getPaymentToken(
      {required double amount, required String currency});

  Future<String> _getAuthenticationToken();

  Future<int> _getOrderId({
    required String authenticationToken,
    required String amount,
    required String currency,
  });

  Future<String> _getPaymentKey(
      {required String authenticationToken,
      required String orderId,
      required String amount,
      required String currency});
}
