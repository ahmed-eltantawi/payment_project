part of 'paymob_manager.dart';

abstract class Payment {
  Future<String> getPaymentKey(
      {required double amount, required String currency});

  Future<String> _getAuthenticationToken();
}
