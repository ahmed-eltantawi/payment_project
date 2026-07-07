part of 'paymob_interface.dart';

class PaymobManager implements PaymobInterface {
  static const String _baseUrl = "https://accept.paymob.com/";
  static final DioConsumer _dioConsumer = getIt.get<DioConsumer>();

  @override
  Future<Either<String, void>> makePayment({
    required context,
    required double amount,
    required String currency,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<String> _getAuthenticationToken() async {
    final response = await _dioConsumer.post(
      "${_baseUrl}api/auth/tokens",
      data: {"api_key": Constants.paymobApiKey},
    );
    return response["token"];
  }

  @override
  Future<String> _getClientSecret(
      {required double amount,
      required String currency,
      required List<int> paymentMethodsIds}) async {
    final response = await _dioConsumer.post(
      "${_baseUrl}v1/intention/",
      data: {"api_key": Constants.paymobApiKey},
      headers: {"Authorization": "Token ${Constants.}"},
    );
    return response["token"];
  }

  @override
  Future<void> _launchThePaymentSDK({required String clientSecret}) {
    // TODO: implement _launchThePaymentSDK
    throw UnimplementedError();
  }
}
