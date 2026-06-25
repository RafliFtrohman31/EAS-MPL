import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<Response> getNews() async {
    try {
      // Menggunakan endpoint mock berita gratis sebagai contoh
      final response = await _dio.get('https://api.spaceflightnewsapi.net/v4/articles/?limit=10');
      return response;
    } catch (e) {
      rethrow;
    }
  }
}