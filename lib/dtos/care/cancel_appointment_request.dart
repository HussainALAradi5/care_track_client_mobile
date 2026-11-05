/// POST .../appointments/{appointmentId}/cancel body.
class CancelAppointmentRequest {
  const CancelAppointmentRequest({required this.expectedVersion, required this.reason});

  final int expectedVersion;
  final String reason;

  Map<String, dynamic> toJson() => {'expectedVersion': expectedVersion, 'reason': reason};
}
