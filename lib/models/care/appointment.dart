import '../../enums/care/appointment_status.dart';

/// Server AppointmentDto (the patient-facing fields).
class Appointment {
  const Appointment({
    required this.id,
    required this.code,
    required this.hospitalId,
    required this.clinicianId,
    required this.startsAt,
    required this.endsAt,
    required this.cancellationDeadlineAt,
    required this.createdAt,
    required this.status,
    required this.version,
    this.checkedInAt,
    this.noShowAt,
    this.noShowReason,
    this.notSeenAt,
    this.notSeenReason,
  });

  final String id;
  final String code;
  final String hospitalId;
  final String clinicianId;
  final DateTime startsAt;
  final DateTime endsAt;
  final DateTime cancellationDeadlineAt;

  /// Confirmation time: the cancellation window opens here.
  final DateTime createdAt;
  final AppointmentStatus status;
  final int version;
  final DateTime? checkedInAt;
  final DateTime? noShowAt;
  final String? noShowReason;
  final DateTime? notSeenAt;
  final String? notSeenReason;

  bool get scheduled => status == AppointmentStatus.scheduled;

  static DateTime? _optionalDate(Object? value) => value == null ? null : DateTime.parse(value as String).toLocal();

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] as String,
    code: json['code'] as String,
    hospitalId: json['hospitalId'] as String,
    clinicianId: json['clinicianId'] as String,
    startsAt: DateTime.parse(json['startsAt'] as String).toLocal(),
    endsAt: DateTime.parse(json['endsAt'] as String).toLocal(),
    cancellationDeadlineAt: DateTime.parse(json['cancellationDeadlineAt'] as String).toLocal(),
    createdAt: DateTime.parse(json['createdAt'] as String).toLocal(),
    status: AppointmentStatus.fromWire(json['status'] as String),
    version: (json['version'] as num).toInt(),
    checkedInAt: _optionalDate(json['checkedInAt']),
    noShowAt: _optionalDate(json['noShowAt']),
    noShowReason: json['noShowReason'] as String?,
    notSeenAt: _optionalDate(json['notSeenAt']),
    notSeenReason: json['notSeenReason'] as String?,
  );
}
