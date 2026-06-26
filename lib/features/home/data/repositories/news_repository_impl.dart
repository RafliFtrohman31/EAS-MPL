import 'package:isar/isar.dart';
import 'package:uas_mobile_lanjut/core/network/api_service.dart';
import 'package:uas_mobile_lanjut/features/home/domain/repositories/news_repository.dart';

// GANTI IMPORT MODEL KELAS DENGAN BERIKUT INI:
import 'package:uas_mobile_lanjut/features/home/data/models/article_model.dart'; 

class NewsRepositoryImpl implements NewsRepository {
  final ApiService _apiService;
  final Isar _isar;

  NewsRepositoryImpl(this._apiService, this._isar);

  @override
  Stream<List<ArticleModel>> getNewsStream() {
    // Membaca data reaktif dari Isar
    return _isar.articleModels.where().watch(fireImmediately: true);
  }

  @override
  Future<void> fetchAndRefreshNews() async {
    try {
      final response = await _apiService.getNews();
      
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'] ?? [];
        
        List<ArticleModel> fetchedArticles = results
            .map((json) => ArticleModel.fromJson(json))
            .toList();

        // TANTANGAN ANTI-AI: Sort data dari A ke Z (NPM GENAP: 8) [cite: 195, 205, 207]
        fetchedArticles.sort((a, b) => a.title.compareTo(b.title));

        await _isar.writeTxn(() async {
          await _isar.articleModels.clear();
          await _isar.articleModels.putAll(fetchedArticles);
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}