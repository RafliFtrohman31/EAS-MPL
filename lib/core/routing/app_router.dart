import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uas_mobile_lanjut/core/di/injection.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/cubit/news_cubit.dart';
import 'package:uas_mobile_lanjut/features/home/presentation/pages/home_page.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        // Menggunakan BlocProvider di level routing agar NewsCubit bisa diakses oleh HomePage
        builder: (context, state) => BlocProvider(
          create: (context) => locator<NewsCubit>(),
          child: const HomePage(),
        ),
      ),
    ],
  );
}