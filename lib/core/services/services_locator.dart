// Create a global instance (or use GetIt.instance)
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // all objects you want to use only on time in your app

  getIt.registerSingleton<Dio>(Dio());
}
