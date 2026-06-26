import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart'; // Dibutuhkan untuk mencari direktori HP

// Import target layer fitur Anda
import 'package:uas_mobile_lanjut/features/home/data/models/article_model.dart'; // Impor skema Isar model Anda
import 'package:uas_mobile_lanjut/features/home/domain/repositories/news_repository.dart';
import 'package:uas_mobile_lanjut/features/home/data/repositories/news_repository_impl.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/cubit/news_cubit.dart';

final locator = GetIt.instance;

// MODIFIKASI: Ubah void menjadi Future<void> dan tambahkan kata kunci async
Future<void> setupLocator() async {
  
  // 1. Inisialisasi & Buka Isar Database secara Asinkron sebelum diakses Repositori
  if (!locator.isRegistered<Isar>()) {
    final dir = await getApplicationDocumentsDirectory(); // Mencari folder internal HP
    final isar = await Isar.open(
      [ArticleModelSchema], // Membuka skema tabel hasil build_runner
      directory: dir.path,
    );
    locator.registerSingleton<Isar>(isar); // Daftarkan instance Isar ke GetIt
  }

  // 2. Registrasi Dio (Network) dengan LogInterceptor bawaan Modul 15
// 2. Registrasi Dio (Network) dengan global API Key baru Anda
  if (!locator.isRegistered<Dio>()) {
    locator.registerLazySingleton<Dio>(() {
      final dio = Dio(BaseOptions(
        baseUrl: 'https://newsapi.org/v2/',
        // Menyisipkan apiKey secara global ke setiap query parameter request
        queryParameters: {
          'apiKey': '3fbcf51a13124a5a986074c14810a4ad',
        },
      ));
      dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
      return dio;
    });
  }

  // 3. Registrasi NewsRepositoryImpl dengan menyuntikkan Dio dan Isar
  if (!locator.isRegistered<NewsRepository>()) {
    locator.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(
        locator<Dio>(),   
        locator<Isar>(),  
      ),
    );
  }

  // 4. Daftarkan Factory untuk NewsCubit (Presentation Layer)
  if (!locator.isRegistered<NewsCubit>()) {
    locator.registerFactory(() => NewsCubit(locator<NewsRepository>()));
  }
}