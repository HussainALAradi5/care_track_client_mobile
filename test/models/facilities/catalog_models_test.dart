import 'package:care_track_client_mobile/enums/facilities/hospital_type.dart';
import 'package:care_track_client_mobile/enums/facilities/opening_state.dart';
import 'package:care_track_client_mobile/models/facilities/hospital_summary.dart';
import 'package:care_track_client_mobile/models/facilities/public_city.dart';
import 'package:care_track_client_mobile/models/facilities/public_country.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses PublicHospitalDto with its country and opening', () {
    final h = HospitalSummary.fromJson({
      'id': 'h1',
      'name': 'Salmaniya',
      'type': 'PUBLIC',
      'city': 'Manama',
      'addressLine': 'Road 1',
      'countryName': 'Bahrain',
      'countryIsoCode': 'BH',
      'flagEmoji': 'BH',
      'timeZone': 'Asia/Bahrain',
      'opening': {'state': 'CLOSING_SOON', 'nextChangeAt': '2026-11-09T16:00:00Z'},
    });
    expect(h.type, HospitalType.public);
    expect(h.countryName, 'Bahrain');
    expect(h.opening!.state, OpeningState.closingSoon);
    expect(h.opening!.nextChangeAt, DateTime.utc(2026, 11, 9, 16));
  });

  test('parses HospitalDto, which has no country and may have no opening', () {
    final h = HospitalSummary.fromJson({
      'id': 'h1',
      'code': 'H1',
      'name': 'Private Clinic',
      'organizationId': 'o1',
      'type': 'PRIVATE',
      'countryCode': 'BH',
      'city': 'Riffa',
      'addressLine': 'Road 2',
      'timeZone': 'Asia/Bahrain',
      'is24Hours': false,
      'status': 'ACTIVE',
      'version': 1,
      'countryId': 'c1',
      'cityId': 'ct1',
      'opening': null,
    });
    expect(h.type, HospitalType.private);
    expect(h.countryName, isNull);
    expect(h.opening, isNull);
  });

  test('parses PublicCountryDto and PublicCityDto', () {
    final country = PublicCountry.fromJson({
      'id': 'c1',
      'name': 'Bahrain',
      'isoCode': 'BH',
      'flagEmoji': 'BH',
      'flagSvgUrl': 'https://x/bh.svg',
      'dialingCode': '+973',
    });
    expect(country.dialingCode, '+973');
    expect(PublicCity.fromJson({'id': 'ct1', 'name': 'Manama', 'localCode': 'MAN'}).name, 'Manama');
  });

  test('every opening state on the wire is known', () {
    for (final wire in ['OPEN_24_HOURS', 'OPEN_NOW', 'CLOSING_SOON', 'CLOSED_NOW']) {
      expect(OpeningState.fromWire(wire).wire, wire);
    }
  });
}
