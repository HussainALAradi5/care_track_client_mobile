import 'package:care_track_client_mobile/dtos/auth/auth_tokens.dart';
import 'package:care_track_client_mobile/services/auth/auth_service.dart';
import 'package:care_track_client_mobile/services/auth/token_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class ThrowingAppAuth extends FlutterAppAuth {
  ThrowingAppAuth(this.error);

  final Object error;

  @override
  Future<TokenResponse> token(TokenRequest request) => throw error;
}

FlutterAppAuthPlatformException refused(String code) => FlutterAppAuthPlatformException(
  code: 'token_failed',
  platformErrorDetails: FlutterAppAuthPlatformErrorDetails(error: code),
);

Future<AuthService> signedInWithExpiredToken(Object refreshError) async {
  FlutterSecureStorage.setMockInitialValues({});
  final storage = TokenStorage(const FlutterSecureStorage());
  await storage.write(
    AuthTokens(accessToken: 'old', expiresAt: DateTime(2020), refreshToken: 'refresh', idToken: 'id'),
  );
  return AuthService(ThrowingAppAuth(refreshError), storage);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a refresh that cannot reach the provider keeps the session', () async {
    final service = await signedInWithExpiredToken(
      PlatformException(code: 'token_failed', message: 'offline'),
    );
    await service.restore();

    expect(await service.validAccessToken(), isNull);
    expect(service.signedIn, isTrue);
  });

  test('an unrelated refresh failure from the provider keeps the session', () async {
    final service = await signedInWithExpiredToken(refused('temporarily_unavailable'));
    await service.restore();

    expect(await service.validAccessToken(), isNull);
    expect(service.signedIn, isTrue);
  });

  test('an invalid grant ends the session and says so', () async {
    final service = await signedInWithExpiredToken(refused('invalid_grant'));
    final expired = expectLater(service.expired, emits(null));

    await service.restore();

    expect(service.signedIn, isFalse);
    await expired;
  });
}
