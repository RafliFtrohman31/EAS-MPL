import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_mobile_lanjut/core/di/injection.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/cubit/news_cubit.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/pages/home_page.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/pages/news_detail_page.dart'; // 🛠️ Tambahkan impor ini
import 'package:uas_mobile_lanjut/features/settings/presentation/pages/profile_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => locator<NewsCubit>()..loadNewsPortal(),
          child: const HomePage(),
        ),
      ),
      // 🛠️ DAFTARKAN RUTE DETAIL DI SINI
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          // Menangkap objek artikel yang dikirim lewat parameter 'extra' dari HomePage
          final article = state.extra; 
          return NewsDetailPage(article: article);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}