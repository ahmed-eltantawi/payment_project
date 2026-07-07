import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_project/core/cache/cache_helper.dart';
import 'package:payment_project/core/cache/cache_keys.dart';
import 'package:payment_project/core/networking/dio_consumer.dart';
import 'package:payment_project/core/services/payment/payment_interface.dart';
import 'package:payment_project/core/services/payment/stripe/customer_session_model.dart';
import 'package:payment_project/core/services/payment/stripe/payment_intent_model/payment_intent_model.dart';
import 'package:payment_project/core/services/services_locator.dart';
import 'package:payment_project/core/utils/constants.dart';

part "stripe_manager_interface.dart";

///* Stripe payment service implementation.
/// Handles creating customers, payment intents,
/// ephemeral keys, and presenting the PaymentSheet.
class StripeManager extends StripeManagerInterface {
  //* -- some variables will be used later in this class --
  static const String _baseUrl = "https://api.stripe.com/v1/";
  static const String _stripeVersion = "2026-06-24.dahlia";
  static final DioConsumer _dioConsumer = getIt.get<DioConsumer>();

  //* -- headers in every request to stripe --
  final Map<String, String> headers = {
    'Authorization': "Bearer ${Constants.stripeSecretKey}",
    'Stripe-Version': _stripeVersion,
    Headers.contentTypeHeader: Headers.formUrlEncodedContentType
  };

  @override

  ///! Creates a PaymentIntent on Stripe.
  ///
  /// The amount is converted from the major currency unit
  /// (e.g. USD, EGP) to the smallest currency unit (cents).
  /// If a customer exists, the PaymentIntent is associated with it.
  Future<PaymentIntentModel> _createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    final response = await _dioConsumer.post("${_baseUrl}payment_intents",
        data: {
          "amount": (amount * 100).round(),
          "currency": currency,
          "customer": await getIt
              .get<CacheHelper>()
              .getSecureData(key: CacheKeys.stripeCustomerId),
        },
        headers: headers);
    return PaymentIntentModel.fromJson(response);
  }

  @override

  ///! Initializes the Stripe PaymentSheet.
  ///
  /// If a customer session is provided, the PaymentSheet
  /// will be configured for that customer.
  Future<void> _initPaymentSheet(
      {required String paymentIntentClientSecret,
      required String merchantDisplayName,
      CustomerSessionModel? customerSessionModel}) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: merchantDisplayName,
            customerId: customerSessionModel?.customerId,
            customerEphemeralKeySecret:
                customerSessionModel?.customerEphemeralKeySecret));
  }

  @override

  ///! Presents the Stripe PaymentSheet to the user.
  ///
  /// Throws a [StripeException] if the payment fails
  /// or the user cancels the payment.
  Future<void> _displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  ///! Creates a new Stripe Customer.
  ///
  /// The generated customer ID is stored securely and reused
  /// in future payment operations.
  @override
  Future<String> _createCustomer(
      {String? email, String? name, String? phone}) async {
    final response = await _dioConsumer.post("${_baseUrl}customers",
        data: {"email": email, "name": name, "phone": phone}, headers: headers);
    final String id = response["id"];
    await getIt
        .get<CacheHelper>()
        .saveSecureData(key: CacheKeys.stripeCustomerId, value: id);
    return id;
  }

  ///* Creates an Ephemeral Key for the current Stripe customer.
  ///
  /// If no customer ID exists in secure storage, a new customer
  /// is created before requesting the Ephemeral Key.
  @override
  Future<CustomerSessionModel> _getEphemeralKey() async {
    String? customerId = await getIt
        .get<CacheHelper>()
        .getSecureData(key: CacheKeys.stripeCustomerId);
    customerId ??= await _createCustomer();

    final response = await _dioConsumer.post("${_baseUrl}ephemeral_keys",
        data: {
          "customer": customerId,
        },
        headers: headers);
    return CustomerSessionModel(
        customerEphemeralKeySecret: response["secret"], customerId: customerId);
  }

  @override

  ///! Executes the complete Stripe payment flow.
  ///
  /// Steps:
  /// 1. Get or create a Stripe customer.
  /// 2. Generate an Ephemeral Key.
  /// 3. Create a PaymentIntent.
  /// 4. Initialize the PaymentSheet.
  /// 5. Present the PaymentSheet to the user.
  ///
  /// Returns:
  /// - Right(null) if the payment succeeds.
  /// - Left(errorMessage) if an error occurs.
  Future<Either<String, void>> makePayment({
    required double amount,
    required String currency,
  }) async {
    try {
      final CustomerSessionModel customerSessionModel =
          await _getEphemeralKey();
      final paymentIntentModel =
          await _createPaymentIntent(amount: amount, currency: currency);
      await _initPaymentSheet(
          paymentIntentClientSecret: paymentIntentModel.clientSecret!,
          merchantDisplayName: "Ahmed",
          customerSessionModel: customerSessionModel);
      await _displayPaymentSheet();
      return right(null);
    } on Exception catch (e) {
      return left(e.toString());
    }
  }
}
