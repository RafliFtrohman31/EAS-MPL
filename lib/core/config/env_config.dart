class EnvConfig {
  EnvConfig._();

  // Membaca environment dari run arguments (--dart-define=ENV_NAME=PROD)
  static const String environment = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');
  
  // Isikan Mock API / News API pilihan Anda di sini
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://newsapi.org/v2/');

  static bool get isProduction => environment == 'PROD';

  // Logika Nama Aplikasi Berbasis Parameter EAS
  static String get appName {
    return isProduction ? 'UTD - 20123048' : 'DEV - Rafli';
  }
}