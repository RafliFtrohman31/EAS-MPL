import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final Dio _dio;
  final Isar _isar;

  NewsRepositoryImpl(this._dio, this._isar);

  @override
  Stream<List<Article>> watchArticles() {
    // Membaca data Isar secara reaktif (Stream) sesuai Aturan Emas 2 Modul 15
    return _isar.articleModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<void> fetchAndCacheArticles() async {
    try {
      // Mengambil data dummy dari endpoint API (Silakan ganti sesuai dengan API Anda)
      final response = await _dio.get('top-headlines?country=id&apiKey=YOUR_KEY');
      
      if (response.statusCode == 200) {
        final List data = response.data['articles'] ?? [];
        
        List<ArticleModel> articles = data.map((json) {
          return ArticleModel(
            id: json['url'] ?? DateTime.now().toString(), // URL unik sebagai cadangan ID
            title: json['title'] ?? 'No Title',
            content: json['description'] ?? 'No Content Available',
            urlToImage: json['urlToImage'] ?? '',
            publishedAt: json['publishedAt'] ?? '',
          );
        }).toList();

        // 🌟 TANTANGAN ANTI-AI EAS: NPM Berakhiran Genap (8) wajib Sort Ascending (A ke Z)
        // Dilakukan pada layer Data/Repository, bukan di UI Widget!
        articles.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

        // Melakukan transaksi tulis lokal ke Isar Database
        await _isar.writeTxn(() async {
          // Opsional: bersihkan cache lama jika ingin data selalu segar setara API
          await _isar.articleModels.clear(); 
          
          for (var article in articles) {
            await _isar.articleModels.put(article);
          }
        });
      }
    } catch (e) {
      // Lempar kembali error agar ditangkap State Management untuk UI Fail-Safe
      rethrow;
    }
  }
}