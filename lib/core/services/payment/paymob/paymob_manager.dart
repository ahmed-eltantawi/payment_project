import 'package:dartz/dartz.dart';
import 'package:payment_project/core/functions/snak_bar.dart';
import 'package:payment_project/core/networking/api_end_points.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/payment/payment_interface.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

part 'paymob_manager_interface.dart';

class PaymobManager extends PaymobManagerInterface {
  static const _baseUrl = "https://accept.paymob.com/api/";
  @override
  Future<Either<String, String>> _getPaymentToken(
      {required double amount, required String currency}) async {
    try {
      // -- we have to get three things from the api --

      //* -- 1- Authentication Token --
      final String authenticationToken = await _getAuthenticationToken();
      //* -- 2- Order Id --
      final int orderId = await _getOrderId(
          amount: (amount * 100)
              .toString(), // we multiply by 100 to get amount in cents
          currency: currency,
          authenticationToken: authenticationToken);
      //* -- 3- Payment Key --
      final String paymentKey = await _getPaymentKey(
          authenticationToken: authenticationToken,
          orderId: orderId.toString(),
          amount: (amount * 100)
              .toString(), // we multiply by 100 to get amount in cents,
          currency: currency);

      //* Then we return the payment key
      return right(paymentKey);
    } catch (e) {
      return left(
          "Something went wrong in paymob manager, please try again later\n $e");
    }
  }

  @override
  Future<String> _getAuthenticationToken() async {
    final response = await getIt.get<DioConsumer>().post(
        "${_baseUrl}auth/tokens",
        data: {ApiKey.apiKey: Constants.apiKey});

    return response[ApiKey.token];
  }

  @override
  Future<int> _getOrderId(
      {required String authenticationToken,
      required String amount,
      required String currency}) async {
    final response = await getIt.get<DioConsumer>().post(
      "${_baseUrl}ecommerce/orders",
      data: {
        "auth_token": authenticationToken,
        "amount_cents": amount, // >> String <<
        "currency": currency, // Not required
        "delivery_needed": "false", // >> String <<
        "items": [],
      },
    );
    return response["id"]; // integer
  }

  @override
  Future<String> _getPaymentKey(
      {required String authenticationToken,
      required String orderId,
      required String amount,
      required String currency}) async {
    final response = await getIt
        .get<DioConsumer>()
        .post("${_baseUrl}acceptance/payment_keys", data: {
      // ALL OF THEM ARE REQUIRED
      "expiration": 3600,

      "auth_token": authenticationToken, //From First Api
      "order_id": orderId, //From Second Api  >>(STRING)<<
      "integration_id": Constants
          .cardPaymentMethodIntegrationId, //Integration Id Of The Payment Method

      "amount_cents": amount,
      "currency": currency,

      "billing_data": {
        //!============  Have To Be Values ==========
        "first_name": "Clifford",
        "last_name": "Nicolas",
        "email": "claudette09@exa.com",
        "phone_number": "+201020101740",

        //Can Set "NA"
        "apartment": "NA",
        "floor": "NA",
        "street": "NA",
        "building": "NA",
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "state": "NA"
      },
    });

    return response[ApiKey.token];
  }

  @override
  Future<Either<String, void>> makePayment(
      {required context,
      required double amount,
      required String currency}) async {
    try {
      final paymentKey =
          await _getPaymentToken(amount: amount, currency: currency);
      paymentKey.fold((failure) => showSnackBar(context, failure),
          (paymentKey) async {
        await launchUrl(Uri.parse(
            "${_baseUrl}acceptance/iframes/1057330?payment_token=$paymentKey"));
      });

      return right(null);
    } on Exception catch (e) {
      return left(e.toString());
    }
  }
}
