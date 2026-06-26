part of 'news_cubit.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}
class NewsSuccess extends NewsState {
  final List<Article> articles;
  const NewsSuccess({required this.articles});

  @override
  List<Object?> get props => [articles];
}
class NewsFailure extends NewsState {
  final String message;
  const NewsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}