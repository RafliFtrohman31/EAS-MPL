import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uas_mobile_lanjut/features/home/domain/repositories/news_repository.dart';
import 'package:uas_mobile_lanjut/features/home/domain/entities/article.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _repository;
  StreamSubscription? _newsSubscription;

  NewsCubit(this._repository) : super(NewsInitial());

  void loadNewsPortal() {
    emit(NewsLoading());

    _newsSubscription?.cancel();
    _newsSubscription = _repository.getNewsStream().listen(
      (articles) {
        if (articles.isNotEmpty) {
          emit(NewsSuccess(articles: articles));
        }
      },
      onError: (error) {
        emit(NewsFailure(message: error.toString()));
      },
    );

    _repository.fetchAndRefreshNews().then((_) {
      // Data berhasil sinkron ke Isar
    }).catchError((error) {
      if (state is! NewsSuccess) {
        emit(const NewsFailure(message: 'Koneksi internet terputus. Gagal memuat berita baru.'));
      }
    });
  }

  @override
  Future<void> close() {
    _newsSubscription?.cancel();
    return super.close();
  }
}