import 'package:care_track_client_mobile/interfaces/auth/token_source.dart';
import 'package:care_track_client_mobile/middlewares/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class CountingTokens implements TokenSource {
  int unauthorized = 0;

  @override
  bool get signedIn => true;

  @override
  Future<String?> validAccessToken() async => null;

  @override
  Future<void> handleUnauthorized() async => unauthorized += 1;
}

class QuietHandler extends ErrorInterceptorHandler {
  @override
  void next(DioException error) {}
}

void main() {
  test('a 401 to a call sent without a token does not end the session', () async {
    final tokens = CountingTokens();
    final interceptor = AuthInterceptor(tokens);
    final options = RequestOptions(path: '/x');
    final error = DioException(
      requestOptions: options,
      response: Response(requestOptions: options, statusCode: 401),
    );

    await interceptor.onError(error, QuietHandler());

    expect(tokens.unauthorized, 0);
  });

  test('a 401 to a call sent with a token ends the session', () async {
    final tokens = CountingTokens();
    final interceptor = AuthInterceptor(tokens);
    final options = RequestOptions(path: '/x', headers: {'Authorization': 'Bearer t'});
    final error = DioException(
      requestOptions: options,
      response: Response(requestOptions: options, statusCode: 401),
    );

    await interceptor.onError(error, QuietHandler());

    expect(tokens.unauthorized, 1);
  });
}
