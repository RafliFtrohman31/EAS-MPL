import 'package:flutter/material.dart';
import '../config/env_config.dart';

class AppTheme {
  AppTheme._();

  // Skema Warna Elegan untuk Mode PROD (Biru Gelap Premium)
  static const Color _prodPrimary = Color(0xFF0F172A); // Slate Blue / Deep Blue
  static const Color _prodSecondary = Color(0xFF2563EB); // Royal Blue Accent

  // Skema Warna untuk Mode DEV (Teal Modern)
  static const Color _devPrimary = Color(0xFF0D9488); 
  static const Color _devSecondary = Color(0xFF14B8A6);

  static ThemeData get lightTheme {
    final primaryColor = EnvConfig.isProduction ? _prodPrimary : _devPrimary;
    final secondaryColor = EnvConfig.isProduction ? _prodSecondary : _devSecondary;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light, // WAJIB LIGHT MODE (Digit NPM Genap: 8)
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: const Color(0xFFF8FAFC), // Latar belakang putih keabu-abuan bersih
        onSurface: const Color(0xFF0F172A),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      
      // Desain AppBar Elegan & Tipis
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        shape: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
      ),

      // Desain Card Premium modern tanpa bayangan kaku (Shadowless)
      cardTheme: CardTheme(
        color: const Color(0xFFFFFFFF),
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: const Color(0xFFE2E8F0), width: 1), // Border tipis halus
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Tipografi bergaya editorial berita modern
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: -1),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF0F172A), height: 1.3),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF475569), height: 1.5),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
      ),
    );
  }
}