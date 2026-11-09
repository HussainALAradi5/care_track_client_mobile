import '../../enums/notifications/notification_link_type.dart';

/// Server NotificationDto: one inbox row. It says what happened and what it opens, never clinical or salary details.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.linkType,
    required this.linkId,
    required this.hospitalId,
    required this.read,
    required this.createdAt,
  });

  final String id;

  /// The server's notification type, as sent.
  final String type;
  final String title;
  final NotificationLinkType linkType;
  final String? linkId;
  final String? hospitalId;
  final bool read;
  final DateTime createdAt;

  AppNotification copyWith({required bool read}) => AppNotification(
    id: id,
    type: type,
    title: title,
    linkType: linkType,
    linkId: linkId,
    hospitalId: hospitalId,
    read: read,
    createdAt: createdAt,
  );

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'] as String,
    type: json['type'] as String,
    title: json['title'] as String,
    linkType: NotificationLinkType.fromWire(json['linkType'] as String),
    linkId: json['linkId'] as String?,
    hospitalId: json['hospitalId'] as String?,
    read: json['read'] as bool,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
