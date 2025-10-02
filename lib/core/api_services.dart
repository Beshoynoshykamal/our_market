import 'package:dio/dio.dart';
import 'package:our_market/core/sensitive_data.dart';

class ApiServices {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://gzuuzhyazixrjrvqusfk.supabase.co/rest/v1/',
      headers: {"apiKey": anonKey},
    ),
  );
  Future<Response> getData(String path) async {
    try {
      final response = await _dio.get(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> postData(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patchData(String path, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> deleteData(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
