/// Server NotificationTypePreferenceDto: the channels of one kind of notification.
class NotificationTypePreference {
  const NotificationTypePreference({required this.type, required this.inApp, required this.push, required this.email});

  final String type;
  final bool inApp;
  final bool push;
  final bool email;

  NotificationTypePreference copyWith({bool? inApp, bool? push, bool? email}) => NotificationTypePreference(
    type: type,
    inApp: inApp ?? this.inApp,
    push: push ?? this.push,
    email: email ?? this.email,
  );

  Map<String, dynamic> toJson() => {'type': type, 'inApp': inApp, 'push': push, 'email': email};

  factory NotificationTypePreference.fromJson(Map<String, dynamic> json) => NotificationTypePreference(
    type: json['type'] as String,
    inApp: json['inApp'] as bool,
    push: json['push'] as bool,
    email: json['email'] as bool,
  );
}
