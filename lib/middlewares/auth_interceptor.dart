import 'package:dio/dio.dart';

import '../interfaces/auth/token_source.dart';

/// Adds the bearer token to every API call and ends the session when the server answers 401.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._tokens);

  final TokenSource _tokens;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokens.validAccessToken();
    if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) await _tokens.handleUnauthorized();
    handler.next(err);
  }
}
