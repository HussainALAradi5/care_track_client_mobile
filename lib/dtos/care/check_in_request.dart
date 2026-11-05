import '../../enums/identity/presence_verification_method.dart';

/// POST .../appointments/{appointmentId}/check-in body.
class CheckInRequest {
  const CheckInRequest({required this.expectedVersion, required this.method});

  final int expectedVersion;
  final PresenceVerificationMethod method;

  Map<String, dynamic> toJson() => {'expectedVersion': expectedVersion, 'verificationMethod': method.wire};
}
