import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_mobile_lanjut/core/di/injection.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/cubit/news_cubit.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/pages/home_page.dart';
import 'package:uas_mobile_lanjut/features/settings/presentation/pages/profile_page.dart'; // Impor Halaman Profil

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
          create: (context) => locator<NewsCubit>(),
          child: const HomePage(),
        ),
      ),
      // Tambahkan route khusus ke halaman profil untuk pemanggilan navigasi UI
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}