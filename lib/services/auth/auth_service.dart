import 'dart:async';

import 'package:flutter_appauth/flutter_appauth.dart';

import '../../config/app_config.dart';
import '../../config/auth_config.dart';
import '../../dtos/auth/auth_tokens.dart';
import '../../interfaces/auth/token_source.dart';
import 'token_storage.dart';

/// Sign-in through the external identity provider (authorization code + PKCE in the system browser).
/// The server never sees a password; it only validates the access token's issuer and subject.
class AuthService implements TokenSource {
  AuthService(this._appAuth, this._storage);

  final FlutterAppAuth _appAuth;
  final TokenStorage _storage;
  final _expired = StreamController<void>.broadcast();
  AuthTokens? _tokens;
  Future<AuthTokens?>? _refreshing;

  /// Fires when the session ends without the person signing out (refresh failed or 401).
  Stream<void> get expired => _expired.stream;
  bool get signedIn => _tokens != null;

  Future<bool> restore() async {
    _tokens = await _storage.read();
    if (_tokens != null && _tokens!.expiresWithin(AuthConfig.refreshMargin)) await _refresh();
    return _tokens != null;
  }

  /// False when the person closed the browser without signing in (not an error).
  Future<bool> signIn() async {
    try {
      final response = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AuthConfig.clientId,
          AuthConfig.redirectUri,
          issuer: AuthConfig.issuer,
          scopes: AuthConfig.scopes,
          allowInsecureConnections: AppConfig.allowInsecureConnections,
        ),
      );
      await _save(response, previous: null);
      return true;
    } on FlutterAppAuthUserCancelledException {
      return false;
    }
  }

  Future<void> signOut() async {
    final idToken = _tokens?.idToken;
    _tokens = null;
    await _storage.clear();
    if (idToken == null) return;
    try {
      await _appAuth.endSession(
        EndSessionRequest(
          idTokenHint: idToken,
          postLogoutRedirectUrl: AuthConfig.postLogoutRedirectUri,
          issuer: AuthConfig.issuer,
          allowInsecureConnections: AppConfig.allowInsecureConnections,
        ),
      );
    } catch (_) {
      // Local sign-out already happened; a provider-side failure must not keep the person signed in here.
    }
  }

  @override
  Future<String?> validAccessToken() async {
    final tokens = _tokens;
    if (tokens == null) return null;
    if (!tokens.expiresWithin(AuthConfig.refreshMargin)) return tokens.accessToken;
    return (await _refresh())?.accessToken;
  }

  @override
  Future<void> handleUnauthorized() async {
    if (_tokens == null) return;
    _tokens = null;
    await _storage.clear();
    _expired.add(null);
  }

  /// One refresh at a time; concurrent callers share it.
  Future<AuthTokens?> _refresh() => _refreshing ??= _doRefresh().whenComplete(() => _refreshing = null);

  Future<AuthTokens?> _doRefresh() async {
    final current = _tokens;
    if (current?.refreshToken == null) {
      await handleUnauthorized();
      return null;
    }
    try {
      final response = await _appAuth.token(
        TokenRequest(
          AuthConfig.clientId,
          AuthConfig.redirectUri,
          refreshToken: current!.refreshToken,
          issuer: AuthConfig.issuer,
          scopes: AuthConfig.scopes,
          allowInsecureConnections: AppConfig.allowInsecureConnections,
        ),
      );
      return await _save(response, previous: current);
    } catch (_) {
      await handleUnauthorized();
      return null;
    }
  }

  Future<AuthTokens> _save(TokenResponse response, {required AuthTokens? previous}) async {
    final tokens = AuthTokens(
      accessToken: response.accessToken!,
      expiresAt: response.accessTokenExpirationDateTime ?? DateTime.now().add(const Duration(minutes: 5)),
      refreshToken: response.refreshToken ?? previous?.refreshToken,
      idToken: response.idToken ?? previous?.idToken,
    );
    _tokens = tokens;
    await _storage.write(tokens);
    return tokens;
  }
}
