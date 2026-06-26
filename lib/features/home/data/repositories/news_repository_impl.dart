import 'package:dio/dio.dart';
import 'package:isar/isar.dart';

import 'package:uas_mobile_lanjut/features/home/domain/entities/article.dart';
import 'package:uas_mobile_lanjut/features/home/domain/repositories/news_repository.dart';
import 'package:uas_mobile_lanjut/features/home/data/models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final Dio _dio;
  final Isar _isar;

  NewsRepositoryImpl(this._dio, this._isar);

  @override
  Stream<List<Article>> getNewsStream() {
    return _isar.articleModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> fetchAndRefreshNews() async {
    try {
      // 🛠️ PERBAIKAN: Cukup panggil endpoint tanpa query string apiKey manual
      // Menggunakan endpoint everything dengan query pencarian agar datanya dijamin keluar banyak
      final response = await _dio.get('everything?q=indonesia&language=id');

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

        // 🌟 TANTANGAN ANTI-AI: Sort A-Z (Ascending) berdasarkan judul berita
        articles.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );

        // Tulis ulang ke database lokal Isar
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
