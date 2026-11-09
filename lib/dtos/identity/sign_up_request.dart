import '../../enums/identity/gender.dart';
import '../../enums/identity/marital_status.dart';
import '../../utilities/time/dates.dart';

/// POST /api/auth/sign-up body (SignUpRequest). There is deliberately no user type: new accounts are patients.
class SignUpRequest {
  const SignUpRequest({
    required this.gender,
    required this.maritalStatus,
    required this.nationalityCountryId,
    required this.residenceCountryId,
    required this.residenceCityId,
    required this.residenceAddressLine,
    required this.hospitalId,
    this.phoneNumber,
    this.dateOfBirth,
  });

  final Gender gender;
  final MaritalStatus maritalStatus;
  final String nationalityCountryId;
  final String residenceCountryId;
  final String residenceCityId;
  final String residenceAddressLine;
  final String hospitalId;
  final String? phoneNumber;
  final DateTime? dateOfBirth;

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'dateOfBirth': dateOfBirth == null ? null : isoDay(dateOfBirth!),
    'gender': gender.wire,
    'maritalStatus': maritalStatus.wire,
    'nationalityCountryId': nationalityCountryId,
    'residenceCountryId': residenceCountryId,
    'residenceCityId': residenceCityId,
    'residenceAddressLine': residenceAddressLine,
    'hospitalId': hospitalId,
  };
}
