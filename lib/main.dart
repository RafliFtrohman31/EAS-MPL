import 'package:flutter/material.dart';
import 'core/config/env_config.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';

void main() async {
  // 1. Wajib dipanggil pertama kali jika menggunakan async di fungsi main (Modul 15)
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 2. PERBAIKAN: Gunakan await jika setupLocator diubah menjadi Future
    await setupLocator(); 
  } catch (e) {
    debugPrint("Error saat inisialisasi DI/Isar: $e");
  }
  
  runApp(const FinalProjectApp());
}

class FinalProjectApp extends StatelessWidget {
  const FinalProjectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: !EnvConfig.isProduction,
      title: EnvConfig.appName, 
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}