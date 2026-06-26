import '../../domain/entities/article.dart';

abstract class NewsRepository {
  // Menyesuaikan dengan error compiler Anda
  Stream<List<Article>> getNewsStream();
  Future<void> fetchAndRefreshNews();
}