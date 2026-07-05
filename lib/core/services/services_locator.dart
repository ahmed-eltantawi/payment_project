// Create a global instance (or use GetIt.instance)
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_it/get_it.dart';
import 'package:payment_project/core/utils/constants.dart';

import '../networking/dio_consumer.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  Stripe.publishableKey = Constants.stripePublishableKey;

  getIt.registerSingleton<Dio>(Dio());

  getIt.registerLazySingleton<DioConsumer>(
    () => DioConsumer(
      dio: getIt<Dio>(),
    ),
  );
}
