import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../constants/app_constants.dart';
import '../../dtos/auth/auth_tokens.dart';

/// Keeps tokens in the platform keystore / keychain, never in plain preferences.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<AuthTokens?> read() async {
    try {
      final raw = await _storage.read(key: AppConstants.tokenKey);
      return raw == null ? null : AuthTokens.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      // Unreadable or from an older format: treat as signed out.
      return null;
    }
  }

  Future<void> write(AuthTokens tokens) =>
      _storage.write(key: AppConstants.tokenKey, value: jsonEncode(tokens.toJson()));

  Future<void> clear() => _storage.delete(key: AppConstants.tokenKey);
}
