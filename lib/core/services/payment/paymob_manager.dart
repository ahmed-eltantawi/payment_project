import 'dart:typed_data';

import 'package:payment_project/core/networking/api_end_points.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/services_locator.dart';

part 'payment.dart';

class PaymobManager extends Payment {
  @override
  Future<String> getPaymentKey(
      {required double amount, required String currency}) async {
    String authenticationToken = await _getAuthenticationToken();
  }

  @override
  Future<String> _getAuthenticationToken() async {
    final response = await getIt.get<DioConsumer>().post("auth/token",data: {
      ApiKey.apiKey: kConstatns.apiKey;
    });
  }
}
