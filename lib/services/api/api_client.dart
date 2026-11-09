import 'dart:typed_data';

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

  /// For routes that answer a JSON array rather than an object.
  Future<List<dynamic>> getList(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<List<dynamic>>(path, queryParameters: query);
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

  Future<Map<String, dynamic>> put(String path, {Object? body}) async {
    final response = await _dio.put<Map<String, dynamic>>(path, data: body);
    return response.data!;
  }

  /// For a POST that answers 204 No Content.
  Future<void> postNoContent(String path, {Object? body}) => _dio.post<void>(path, data: body);

  /// For routes that answer 204 No Content.
  Future<void> delete(String path) => _dio.delete<void>(path);

  /// A file as raw bytes.
  Future<Uint8List> getBytes(String path) async {
    final response = await _dio.get<List<int>>(path, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data!);
  }

  /// A multipart upload; [onProgress] gets bytes sent and total, as they go.
  Future<Map<String, dynamic>> upload(
    String path, {
    required FormData form,
    void Function(int sent, int total)? onProgress,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(path, data: form, onSendProgress: onProgress);
    return response.data!;
  }
}
