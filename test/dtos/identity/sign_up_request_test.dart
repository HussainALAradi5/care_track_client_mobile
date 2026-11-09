import 'package:care_track_client_mobile/dtos/identity/sign_up_request.dart';
import 'package:care_track_client_mobile/enums/identity/gender.dart';
import 'package:care_track_client_mobile/enums/identity/marital_status.dart';
import 'package:care_track_client_mobile/utilities/auth/jwt_claims.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sends the SignUpRequest field names and a plain date, and no user type', () {
    final json = SignUpRequest(
      gender: Gender.female,
      maritalStatus: MaritalStatus.married,
      nationalityCountryId: 'n1',
      residenceCountryId: 'c1',
      residenceCityId: 'ct1',
      residenceAddressLine: 'Road 1',
      hospitalId: 'h1',
      phoneNumber: '+97333123456',
      dateOfBirth: DateTime(1990, 3, 7),
    ).toJson();
    expect(json, {
      'phoneNumber': '+97333123456',
      'dateOfBirth': '1990-03-07',
      'gender': 'FEMALE',
      'maritalStatus': 'MARRIED',
      'nationalityCountryId': 'n1',
      'residenceCountryId': 'c1',
      'residenceCityId': 'ct1',
      'residenceAddressLine': 'Road 1',
      'hospitalId': 'h1',
    });
  });

  test('reads a claim of a token, and nothing from a malformed one', () {
    // {"email":"a@b.c"}
    expect(jwtClaimsOf('x.eyJlbWFpbCI6ImFAYi5jIn0.y')['email'], 'a@b.c');
    expect(jwtClaimsOf('not-a-token'), isEmpty);
    expect(jwtClaimsOf('x.%%%.y'), isEmpty);
  });
}
