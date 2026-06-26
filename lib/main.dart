import 'package:flutter/material.dart';
import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Dependency Injection
  setupLocator(); 
  
  runApp(const FinalProjectApp());
}

class FinalProjectApp extends StatelessWidget {
  const FinalProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Aturan: Sembunyikan banner debug jika berjalan di PROD
      debugShowCheckedModeBanner: !EnvConfig.isProduction,
      
      // Membaca nama aplikasi secara dinamis berdasarkan NIM & Flavor
      title: EnvConfig.appName, 
      
      // Menerapkan tema light mode kustom kita
      theme: AppTheme.lightTheme,
      
      // Konfigurasi Router bawaan Modul 15
      routerConfig: AppRouter.router,
    );
  }
}