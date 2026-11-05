/// Body of a change that needs the version the person saw and a written reason: cancel or decline a booking
/// decision, cancel an appointment, record a missed or not-seen visit.
class VersionedReasonRequest {
  const VersionedReasonRequest({required this.expectedVersion, required this.reason});

  final int expectedVersion;
  final String reason;

  Map<String, dynamic> toJson() => {'expectedVersion': expectedVersion, 'reason': reason};
}
