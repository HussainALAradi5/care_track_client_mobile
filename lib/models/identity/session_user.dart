import '../../enums/identity/user_type.dart';
import '../../enums/ui/picker_style.dart';

/// GET /api/auth/me (LoginSessionDto).
class SessionUser {
  const SessionUser({
    required this.userId,
    required this.name,
    required this.userType,
    this.username,
    this.pickerStyle,
  });

  final String userId;
  final String name;
  final UserType userType;
  final String? username;

  /// The person's date and time picker look; null follows the device's platform.
  final PickerStyle? pickerStyle;

  String get firstName => name.trim().split(' ').first;

  SessionUser copyWith({required PickerStyle? pickerStyle}) => SessionUser(
    userId: userId,
    name: name,
    userType: userType,
    username: username,
    pickerStyle: pickerStyle,
  );

  factory SessionUser.fromJson(Map<String, dynamic> json) => SessionUser(
    userId: json['userId'] as String,
    name: json['name'] as String,
    userType: UserType.fromWire(json['userType'] as String),
    username: json['username'] as String?,
    pickerStyle: PickerStyle.fromWire(json['pickerStyle'] as String?),
  );
}
