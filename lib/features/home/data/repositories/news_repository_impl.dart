import 'package:isar/isar.dart';
import '../../../../core/network/api_service.dart';
import '../../domain/repositories/news_repository.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final ApiService _apiService;
  final Isar _isar;

  NewsRepositoryImpl(this._apiService, this._isar);

  @override
  Stream<List<ArticleModel>> getNewsStream() {
    // (Aturan Emas 2a & 2d): UI otomatis berubah sendiri dari Stream reaktif Isar
    return _isar.articleModels.where().watch(fireImmediately: true);
  }

  @override
  Future<void> fetchAndRefreshNews() async {
    try {
      // (Aturan Emas 2b): Minta Cubit/Repo menembak API via Dio di background
      final response = await _apiService.getNews();
      
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        
        // Parsing data dari API ke bentuk Model Isar
        List<ArticleModel> fetchedArticles = results
            .map((json) => ArticleModel.fromJson(json))
            .toList();

        // TANTANGAN ANTI-AI: Sort data dari A ke Z (Ascending) berdasarkan judul (NPM GENAP: 8)
        fetchedArticles.sort((a, b) => a.title.compareTo(b.title));

        // (Aturan Emas 2c): Jika ada data baru, simpan ke Isar secara lokal
        await _isar.writeTxn(() async {
          // Bersihkan cache lama terlebih dahulu agar data tetap sinkron
          await _isar.articleModels.clear();
          // Simpan data baru yang sudah di-sorting Ascending
          await _isar.articleModels.putAll(fetchedArticles);
        });
      }
    } catch (e) {
      // Jika internet mati/error, biarkan UI tetap membaca data lama dari Isar (Fail-Safe)
      rethrow;
    }
  }
}