import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../network/api_service.dart'; // Import ApiService baru

final locator = GetIt.instance; // Sesuai Modul 15

void setupLocator() {
  // 1. Register Dio (Network) - Sudah ada dari Modul 15
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 2. Register ApiService baru
  locator.registerLazySingleton<ApiService>(() => ApiService(locator<Dio>()));
}