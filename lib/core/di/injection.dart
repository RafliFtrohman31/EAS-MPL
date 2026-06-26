import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../config/env_config.dart';
import '../network/api_service.dart';
import 'package:uas_mobile_lanjut/features/home/data/models/article_model.dart';
import 'package:uas_mobile_lanjut/features/home/data/repositories/news_repository_impl.dart';
import 'package:uas_mobile_lanjut/features/home/domain/repositories/news_repository.dart';

final locator = GetIt.instance;

// Ubah fungsi menjadi async karena pembukaan Isar membutuhkan await
Future<void> setupLocator() async {
  // Inisialisasi Isar Database lokal
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ArticleModelSchema], // Schema hasil generate build_runner sebelumnya
    directory: dir.path,
  );
  locator.registerSingleton<Isar>(isar);

  // 1. Register Dio (Network)
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 2. Register ApiService
  locator.registerLazySingleton<ApiService>(() => ApiService(locator<Dio>()));

  // 3. Register NewsRepository (Injeksi ApiService & Isar)
  locator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(locator<ApiService>(), locator<Isar>()),
  );
}