import 'package:dio/dio.dart';
import 'package:isar/isar.dart';

// Menggunakan package import absolut agar bebas dari error relative path
import 'package:uas_mobile_lanjut/features/home/domain/entities/article.dart';
import 'package:uas_mobile_lanjut/features/home/domain/repositories/news_repository.dart';
import 'package:uas_mobile_lanjut/features/home/data/models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final Dio _dio;
  final Isar _isar;

  NewsRepositoryImpl(this._dio, this._isar);

  @override
  Stream<List<Article>> getNewsStream() {
    // Membaca data secara reaktif dari koleksi Isar
    return _isar.articleModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> fetchAndRefreshNews() async {
    try {
      final response = await _dio.get('top-headlines?country=id&apiKey=YOUR_KEY');
      
      if (response.statusCode == 200) {
        final List data = response.data['articles'] ?? [];
        
        List<ArticleModel> articles = data.map((json) {
          return ArticleModel(
            id: json['url'] ?? DateTime.now().toString(),
            title: json['title'] ?? 'No Title',
            content: json['description'] ?? 'No Content',
            urlToImage: json['urlToImage'] ?? '',
            publishedAt: json['publishedAt'] ?? '',
          );
        }).toList();

        // 🌟 TANTANGAN ANTI-AI: NPM Rafli berakhiran Genap (8), Sort A-Z (Ascending) [cite: 205, 207]
        articles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

        // Tulis ulang ke database lokal [cite: 22, 210]
        await _isar.writeTxn(() async {
          await _isar.articleModels.clear(); 
          for (var article in articles) {
            await _isar.articleModels.put(article);
          }
        });
      }
    } catch (e) {
      rethrow;
    }
  }
}