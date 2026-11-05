import '../../enums/identity/user_type.dart';

/// GET /api/auth/me (LoginSessionDto).
class SessionUser {
  const SessionUser({required this.userId, required this.name, required this.userType, this.username});

  final String userId;
  final String name;
  final UserType userType;
  final String? username;

  String get firstName => name.trim().split(' ').first;

  factory SessionUser.fromJson(Map<String, dynamic> json) => SessionUser(
    userId: json['userId'] as String,
    name: json['name'] as String,
    userType: UserType.fromWire(json['userType'] as String),
    username: json['username'] as String?,
  );
}
