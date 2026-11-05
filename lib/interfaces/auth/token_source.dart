/// What the HTTP layer needs from authentication, without depending on how sign-in works.
abstract interface class TokenSource {
  /// A current access token (refreshed first when close to expiry), or null when signed out.
  Future<String?> validAccessToken();

  /// The server rejected the token: the session is over.
  Future<void> handleUnauthorized();
}
