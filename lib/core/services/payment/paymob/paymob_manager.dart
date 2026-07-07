part of 'paymob_interface.dart';

class PaymobManager implements PaymobInterface {
  static const String _baseUrl = "https://accept.paymob.com/";
  static final DioConsumer _dioConsumer = getIt.get<DioConsumer>();

  final _service = PaymobService();

  @override
  Future<Either<String, void>> makePayment({
    required context,
    required double amount,
    required String currency,
  }) async {
    try {
      final clientSecret = await _getClientSecret(
          amount: amount, currency: currency, paymentMethodsIds: []);

      await _launchThePaymentSDK(clientSecret: clientSecret);

      return right(null);
    } on Exception catch (e) {
      return left(e.toString());
    }
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
    String? clientSecret = await getIt
        .get<CacheHelper>()
        .getSecureData(key: CacheKeys.paymobClientId);
    if (clientSecret != null) {
      return clientSecret;
    } else {
      final response = await _dioConsumer.post(
        "${_baseUrl}v1/intention/",
        data: {
          "amount": amount,
          "currency": currency,
          "payment_methods": paymentMethodsIds
        },
        headers: {"Authorization": "Token ${Constants.paymobSecretKey}"},
      );
      clientSecret = response["client_secret"];
      getIt
          .get<CacheHelper>()
          .saveSecureData(key: CacheKeys.paymobClientId, value: clientSecret!);
      return clientSecret;
    }
  }

  @override
  Future<Either<String, void>> _launchThePaymentSDK(
      {required String clientSecret}) async {
    final result = await _service.payWithPaymob(
      publicKey: Constants.paymobPublicKey,
      clientSecret: clientSecret,
      customization: const PaymobCustomization(
        appName: 'My Store',
        // buttonBackgroundColor: Colors.blue,
        // buttonTextColor: Colors.white,
        showSaveCard: true,
        saveCardDefault: false,
      ),
    );

    if (result.isSuccessful) {
      return right(null);
    } else if (result.isFailure) {
      return left(result.errorMessage ?? "Something went wrong");
    }

    return left("Something went wrong");
  }
}
