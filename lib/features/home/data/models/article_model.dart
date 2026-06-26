import 'package:isar/isar.dart';
import '../../domain/entities/article.dart';

part 'article_model.g.dart';

@collection
class ArticleModel {
  Id? isarId; 

  @Index(unique: true, replace: true)
  final String id;
  final String title;
  final String content;
  final String urlToImage;
  final String publishedAt;

  ArticleModel({
    this.isarId,
    required this.id,
    required this.title,
    required this.content,
    required this.urlToImage,
    required this.publishedAt,
  });

  // Mengubah data Entity menjadi Model Database (untuk disimpan)
  factory ArticleModel.fromEntity(Article entity) {
    return ArticleModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      urlToImage: entity.urlToImage,
      publishedAt: entity.publishedAt,
    );
  }

  // Mengubah data Model Database menjadi Entity Bisnis (untuk UI)
  Article toEntity() {
    return Article(
      id: id,
      title: title,
      content: content,
      urlToImage: urlToImage,
      publishedAt: publishedAt,
    );
  }
}