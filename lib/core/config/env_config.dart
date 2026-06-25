class EnvConfig {
  EnvConfig._();
  
  static const String environment = String.fromEnvironment('ENV_NAME', defaultValue: 'DEV');
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'https://api.publicapis.org/'); // Nanti bisa disesuaikan dengan API pilihan Anda [cite: 29]
  
  static bool get isProduction => environment == 'PROD';
}