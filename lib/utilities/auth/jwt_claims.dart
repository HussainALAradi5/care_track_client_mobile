import 'dart:convert';

/// The claims of a signed token, without checking it (the server does that); empty when it cannot be read.
Map<String, dynamic> jwtClaimsOf(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return const {};
  try {
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return jsonDecode(payload) as Map<String, dynamic>;
  } on FormatException {
    return const {};
  }
}
