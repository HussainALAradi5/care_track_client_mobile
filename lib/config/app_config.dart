/// Public build-time settings, overridable with `--dart-define` (never secrets).
///
/// Local Android: run `adb reverse tcp:8080 tcp:8080` and `adb reverse tcp:8081 tcp:8081` so `localhost`
/// on the phone reaches the API and the identity provider, and the token issuer matches the server's.
class AppConfig {
  const AppConfig._();

  static const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080');
  /// The STOMP endpoint: the API origin over ws or wss, at the server's /ws path.
  static String get realtimeUrl => '${apiUrl.replaceFirst('http', 'ws')}/ws';

  static const authIssuer = String.fromEnvironment(
    'AUTH_ISSUER',
    defaultValue: 'http://localhost:8081/realms/caretrack',
  );
  static const authClientId = String.fromEnvironment('AUTH_CLIENT_ID', defaultValue: 'caretrack-mobile');
  static const allowInsecureConnections = bool.fromEnvironment('AUTH_ALLOW_HTTP', defaultValue: true);
}
