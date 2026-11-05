import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../constants/app_constants.dart';
import '../../interfaces/auth/token_source.dart';
import '../../middlewares/auth_interceptor.dart';

/// The one configured HTTP client: every feature service calls the API through it.
class ApiClient {
  ApiClient(TokenSource tokens, {Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: '${AppConfig.apiUrl}/api',
              connectTimeout: AppConstants.connectTimeout,
              receiveTimeout: AppConstants.receiveTimeout,
              contentType: Headers.jsonContentType,
            ),
          ) {
    _dio.interceptors.add(AuthInterceptor(tokens));
  }

  final Dio _dio;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
    return response.data!;
  }

  /// [headers] carries per-call headers such as the Idempotency-Key retry-safe writes need.
  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: body,
      queryParameters: query,
      options: headers == null ? null : Options(headers: headers),
    );
    return response.data!;
  }

  /// For routes that answer 204 No Content.
  Future<void> delete(String path) => _dio.delete<void>(path);
}
