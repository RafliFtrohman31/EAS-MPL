import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';

// Import target layer fitur Anda
import 'package:uas_mobile_lanjut/features/home/domain/repositories/news_repository.dart';
import 'package:uas_mobile_lanjut/features/home/data/repositories/news_repository_impl.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/cubit/news_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Pastikan pendaftaran Dio Anda sudah benar seperti cetakan Modul 15
  if (!locator.isRegistered<Dio>()) {
    locator.registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(baseUrl: 'https://newsapi.org/v2/'));
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
      return dio;
    });
  }

  // 2. PERBAIKAN: Berikan locator<Dio>() pada parameter pertama NewsRepositoryImpl, BUKAN ApiService
  locator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      locator<Dio>(),   // Memanggil instance Dio yang terdaftar di atas
      locator<Isar>(),  // Memanggil instance Isar Anda
    ),
  );

  // 3. Daftarkan Factory untuk NewsCubit (Presentation Layer)
  locator.registerFactory(() => NewsCubit(locator<NewsRepository>()));
}