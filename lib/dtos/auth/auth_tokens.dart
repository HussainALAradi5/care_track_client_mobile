/// Tokens returned by the identity provider, kept in secure storage between launches.
class AuthTokens {
  const AuthTokens({required this.accessToken, required this.expiresAt, this.refreshToken, this.idToken});

  final String accessToken;
  final DateTime expiresAt;
  final String? refreshToken;
  final String? idToken;

  bool expiresWithin(Duration margin) => DateTime.now().add(margin).isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.toIso8601String(),
    'refreshToken': refreshToken,
    'idToken': idToken,
  };

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
    accessToken: json['accessToken'] as String,
    expiresAt: DateTime.parse(json['expiresAt'] as String),
    refreshToken: json['refreshToken'] as String?,
    idToken: json['idToken'] as String?,
  );
}
