import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/auth/pending_sign_up_controller.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
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

DioException apiError(int status, String code) {
  final options = RequestOptions(path: '/x');
  return DioException(
    requestOptions: options,
    response: Response(requestOptions: options, statusCode: status, data: {'code': code, 'message': code}),
  );
}

class Accountless implements SessionService {
  Accountless(this.linkFailure);

  final Object? linkFailure;
  int links = 0;

  @override
  Future<SessionUser> me() => throw apiError(403, 'SIGN_UP_REQUIRED');

  @override
  Future<SessionUser> linkInvitation() async {
    links += 1;
    if (linkFailure != null) throw linkFailure!;
    return const SessionUser(userId: 'u1', name: 'Invited Person', userType: UserType.employee);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

({ProviderContainer container, StoredSession auth, Accountless session}) start(Object? linkFailure) {
  final auth = StoredSession();
  final session = Accountless(linkFailure);
  final container = ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      authServiceProvider.overrideWithValue(auth),
      sessionServiceProvider.overrideWithValue(session),
    ],
  );
  addTearDown(container.dispose);
  return (container: container, auth: auth, session: session);
}

void main() {
  test('a sign-in with no account and no invitation keeps its tokens and finishes signing up', () async {
    final s = start(apiError(404, 'INVITATION_NOT_FOUND'));
    expect(await s.container.read(authControllerProvider.future), isNull);
    expect(s.container.read(pendingSignUpProvider), isTrue);
    expect(s.auth.signOuts, 0);
  });

  test('a prepared profile opens instead of signing up anew', () async {
    final s = start(null);
    final user = await s.container.read(authControllerProvider.future);
    expect(user!.name, 'Invited Person');
    expect(s.session.links, 1);
    expect(s.container.read(pendingSignUpProvider), isFalse);
  });

  test('an unverified email is signed out with the reason', () async {
    final s = start(apiError(403, 'INVITATION_EMAIL_UNVERIFIED'));
    await s.container.read(authControllerProvider.future).catchError((_) => null);
    expect(s.container.read(pendingSignUpProvider), isFalse);
    expect(s.auth.signOuts, 1);
  });

  test('signing out and finishing signing up both clear the pending state', () async {
    final s = start(apiError(404, 'INVITATION_NOT_FOUND'));
    await s.container.read(authControllerProvider.future);
    await s.container.read(authControllerProvider.notifier).signOut();
    expect(s.container.read(pendingSignUpProvider), isFalse);

    s.container.read(pendingSignUpProvider.notifier).set(true);
    const user = SessionUser(userId: 'u1', name: 'New', userType: UserType.patient);
    s.container.read(authControllerProvider.notifier).completeSignUp(user);
    expect(s.container.read(pendingSignUpProvider), isFalse);
    expect(s.container.read(authControllerProvider).value, user);
  });
}
