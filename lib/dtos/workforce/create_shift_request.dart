/// POST /api/hospitals/{hospitalId}/clinician-shifts body (UTC instants).
class CreateShiftRequest {
  const CreateShiftRequest({required this.clinicianId, required this.startsAt, required this.endsAt});

  final String clinicianId;
  final DateTime startsAt;
  final DateTime endsAt;

  Map<String, dynamic> toJson() => {
    'clinicianId': clinicianId,
    'startsAt': startsAt.toUtc().toIso8601String(),
    'endsAt': endsAt.toUtc().toIso8601String(),
  };
}
