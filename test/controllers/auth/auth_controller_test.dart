import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:care_track_client_mobile/services/auth/auth_service.dart';
import 'package:care_track_client_mobile/services/auth/token_storage.dart';
import 'package:care_track_client_mobile/services/identity/session_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class StoredSession extends AuthService {
  StoredSession() : super(const FlutterAppAuth(), TokenStorage(const FlutterSecureStorage()));

  int signOuts = 0;

  @override
  Future<bool> restore() async => true;

  @override
  Future<void> signOut() async => signOuts += 1;
}

class FailingSession implements SessionService {
  FailingSession(this.error);

  final Object error;

  @override
  Future<SessionUser> me() => throw error;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<int> signOutsAfterProfileFails(Object error) async {
  final auth = StoredSession();
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      authServiceProvider.overrideWithValue(auth),
      sessionServiceProvider.overrideWithValue(FailingSession(error)),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future).catchError((_) => null);
  return auth.signOuts;
}

void main() {
  test('being offline at start-up keeps the stored sign-in', () async {
    final offline = DioException(requestOptions: RequestOptions(path: '/me'), type: DioExceptionType.connectionError);
    expect(await signOutsAfterProfileFails(offline), 0);
  });

  test('an account the server refuses is signed out', () async {
    final options = RequestOptions(path: '/me');
    final refused = DioException(requestOptions: options, response: Response(requestOptions: options, statusCode: 403));
    expect(await signOutsAfterProfileFails(refused), 1);
  });
}
