// Create a global instance (or use GetIt.instance)
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../networking/dio_consumer.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<Dio>(Dio());

  getIt.registerLazySingleton<DioConsumer>(
    () => DioConsumer(
      dio: getIt<Dio>(),
    ),
  );
}
