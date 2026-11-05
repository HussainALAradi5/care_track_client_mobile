import 'app_config.dart';

/// OpenID Connect (authorization code + PKCE) settings; the scheme is registered in the Android and iOS projects.
class AuthConfig {
  const AuthConfig._();

  static const redirectScheme = 'com.caretrack.mobile';
  static const redirectUri = '$redirectScheme:/oauthredirect';
  static const postLogoutRedirectUri = '$redirectScheme:/signed-out';
  static const scopes = ['openid', 'profile', 'email', 'offline_access'];
  static const issuer = AppConfig.authIssuer;
  static const clientId = AppConfig.authClientId;

  /// Refresh this long before the access token expires.
  static const refreshMargin = Duration(seconds: 30);
}
