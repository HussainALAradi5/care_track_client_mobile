import '../../enums/identity/gender.dart';
import '../../enums/identity/marital_status.dart';
import '../ui/search_option.dart';

/// The Finish signing up form while it is filled in. [tried] turns on the "required" hints.
class SignUpDraft {
  const SignUpDraft({
    this.gender,
    this.maritalStatus,
    this.dateOfBirth,
    this.phone = '',
    this.nationality,
    this.country,
    this.city,
    this.address = '',
    this.hospital,
    this.tried = false,
  });

  final Gender? gender;
  final MaritalStatus? maritalStatus;
  final DateTime? dateOfBirth;
  final String phone;
  final SearchOption? nationality;
  final SearchOption? country;
  final SearchOption? city;
  final String address;
  final SearchOption? hospital;
  final bool tried;

  bool get isComplete =>
      gender != null &&
      maritalStatus != null &&
      nationality != null &&
      country != null &&
      city != null &&
      hospital != null &&
      address.trim().isNotEmpty;

  SignUpDraft copyWith({
    Gender? gender,
    MaritalStatus? maritalStatus,
    DateTime? dateOfBirth,
    String? phone,
    SearchOption? nationality,
    SearchOption? city,
    String? address,
    SearchOption? hospital,
    bool? tried,
  }) => SignUpDraft(
    gender: gender ?? this.gender,
    maritalStatus: maritalStatus ?? this.maritalStatus,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    phone: phone ?? this.phone,
    nationality: nationality ?? this.nationality,
    country: country,
    city: city ?? this.city,
    address: address ?? this.address,
    hospital: hospital ?? this.hospital,
    tried: tried ?? this.tried,
  );

  /// A new country clears the city and the hospital, which belonged to the old one.
  SignUpDraft withCountry(SearchOption value) => SignUpDraft(
    gender: gender,
    maritalStatus: maritalStatus,
    dateOfBirth: dateOfBirth,
    phone: phone,
    nationality: nationality,
    country: value,
    address: address,
    tried: tried,
  );
}
