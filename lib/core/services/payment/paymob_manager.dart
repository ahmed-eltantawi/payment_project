import 'package:dartz/dartz.dart';
import 'package:payment_project/core/networking/api_end_points.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';

part 'paymob_manager_interface.dart';

class PaymobManager extends PaymobManagerInterface {
  @override
  Future<Either<String, String>> getPaymentKey(
      {required double amount, required String currency}) async {
    try {
      // -- we have to get three things from the api --

      //* -- 1- Authentication Token --
      String authenticationToken = await _getAuthenticationToken();
      //* -- 2- Order Id --
      int orderId = await _getOrderId(
          amount: (amount * 100)
              .toString(), // we multiply by 100 to get amount in cents
          currency: currency,
          authenticationToken: authenticationToken);
      //* -- 3- Payment Key --
      String paymentKey = await _getPaymentKey(
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
    final response = await getIt
        .get<DioConsumer>()
        .post("auth/tokens", data: {ApiKey.apiKey: Constants.apiKey});

    return response[ApiKey.token];
  }

  @override
  Future<int> _getOrderId(
      {required String authenticationToken,
      required String amount,
      required String currency}) async {
    final response = await getIt.get<DioConsumer>().post(
      "ecommerce/orders",
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
    final response =
        await getIt.get<DioConsumer>().post("acceptance/payment_keys", data: {
      // ALL OF THEM ARE REQIERD
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
}
