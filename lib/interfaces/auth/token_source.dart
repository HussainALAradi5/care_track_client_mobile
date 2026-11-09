/// What the HTTP layer needs from authentication, without depending on how sign-in works.
abstract interface class TokenSource {
  /// A current access token (refreshed first when close to expiry), or null when none can be had right now.
  Future<String?> validAccessToken();

  /// Whether a session exists; true while offline with an expired token, false only once it is really over.
  bool get signedIn;

  /// The server rejected the token: the session is over.
  Future<void> handleUnauthorized();
}
