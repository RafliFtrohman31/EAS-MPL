part of 'news_cubit.dart';

abstract class NewsState {
  const NewsState();
}

class NewsInitial extends NewsState {}

// Status 1: Loading Spinner saat menunggu data
class NewsLoading extends NewsState {}

// Status 2: Tampilan Data saat sukses
class NewsSuccess extends NewsState {
  final List<Article> articles;
  const NewsSuccess({required this.articles});
}

// Status 3: Pesan Gagal/Error jika internet mati
class NewsFailure extends NewsState {
  final String message;
  const NewsFailure({required this.message});
}