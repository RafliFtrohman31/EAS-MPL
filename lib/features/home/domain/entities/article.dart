import 'package:equatable/equatable';

class Article extends Equatable {
  final String id;
  final String title;
  final String content;
  final String urlToImage;
  final String publishedAt;

  const Article({
    required this.id,
    required this.title,
    required this.content,
    required this.urlToImage,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [id, title, content, urlToImage, publishedAt];
}