part of 'paymob_interface.dart';

class PaymobManager implements PaymobInterface {
  static const String _baseUrl = "https://accept.paymob.com/";
  static final DioConsumer _dioConsumer = getIt.get<DioConsumer>();

  final _service = PaymobService();

  @override
  Future<Either<String, void>> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      final clientSecret = await _getClientSecret(
          amount: amount * 100,
          currency: currency,
          paymentMethodsIds: [
            // Constants.paymobOnlineCardId,
            Constants.paymobMobileWalletId
          ]);

      final launchResult =
          await _launchThePaymentSDK(clientSecret: clientSecret);
      if (launchResult != null) {
        return left(launchResult);
      }
      return right(null);
    } on Exception catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<String> _getClientSecret(
      {required double amount,
      required String currency,
      required List<int> paymentMethodsIds}) async {
    try {
      final response = await _dioConsumer.post(
        "${_baseUrl}v1/intention/",
        data: {
          "amount": amount,
          "currency": currency,
          "payment_methods": paymentMethodsIds,
          "billing_data": {
            "first_name": "Ahmed",
            "last_name": "Hamed",
            "phone_number": "+201020101740"
          },
        },
        headers: {
          "Authorization": "Token ${Constants.paymobSecretKey}",
        },
      );

      final paymobResponse = PaymobIntentionModel.fromJson(response);
      return paymobResponse.clientSecret!;
    } on Exception catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<String?> _launchThePaymentSDK({required String clientSecret}) async {
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
      return null;
    } else {
      return result.errorMessage ?? "Something went wrong";
    }
  }
}
