import '../../enums/care/booking_status.dart';

/// Server BookingDto.
class Booking {
  const Booking({
    required this.id,
    required this.code,
    required this.hospitalId,
    required this.clinicianId,
    required this.startsAt,
    required this.endsAt,
    required this.status,
    required this.version,
    this.patientName = '',
    this.clinicianName = '',
    this.rejectionReason,
  });

  final String id;
  final String code;
  final String hospitalId;
  final String clinicianId;
  final DateTime startsAt;
  final DateTime endsAt;
  final BookingStatus status;
  final int version;
  final String patientName;
  final String clinicianName;
  final String? rejectionReason;

  bool get waiting => status == BookingStatus.requested;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'] as String,
    code: json['code'] as String,
    hospitalId: json['hospitalId'] as String,
    clinicianId: json['clinicianId'] as String,
    startsAt: DateTime.parse(json['startsAt'] as String).toLocal(),
    endsAt: DateTime.parse(json['endsAt'] as String).toLocal(),
    status: BookingStatus.fromWire(json['status'] as String),
    version: (json['version'] as num).toInt(),
    patientName: json['patientName'] as String? ?? '',
    clinicianName: json['clinicianName'] as String? ?? '',
    rejectionReason: json['rejectionReason'] as String?,
  );
}
