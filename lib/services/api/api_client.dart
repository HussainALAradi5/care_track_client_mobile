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

  Future<Map<String, dynamic>> post(String path, {Object? body, Map<String, dynamic>? query}) async {
    final response = await _dio.post<Map<String, dynamic>>(path, data: body, queryParameters: query);
    return response.data!;
  }
}
