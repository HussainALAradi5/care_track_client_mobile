import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/screens/facilities/find_hospital_screen.dart';
import 'package:care_track_client_mobile/screens/facilities/hospitals_near_screen.dart';
import 'package:care_track_client_mobile/utilities/facilities/opening_label.dart';
import 'package:care_track_client_mobile/models/facilities/opening_status.dart';
import 'package:care_track_client_mobile/enums/facilities/opening_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../support/api_harness.dart';

Map<String, dynamic> hospital({String id = 'h1', String name = 'Salmaniya', String state = 'OPEN_NOW'}) => {
  'id': id,
  'name': name,
  'type': 'PUBLIC',
  'city': 'Manama',
  'addressLine': 'Road 1',
  'countryName': 'Bahrain',
  'countryIsoCode': 'BH',
  'timeZone': 'Asia/Bahrain',
  'opening': {'state': state, 'nextChangeAt': null},
};

Object? publicServer(RequestOptions r) => switch (r.path) {
  '/public/countries' => pageOf([
    {'id': 'c1', 'name': 'Bahrain', 'isoCode': 'BH'},
  ]),
  '/public/countries/c1/cities' => pageOf([
    {'id': 'ct1', 'name': 'Manama', 'localCode': 'MAN'},
  ]),
  '/public/hospitals' => pageOf([hospital()]),
  '/patients/me/hospitals' => r.method == 'POST'
      ? {'id': 'h1', 'code': 'H1', 'name': 'Salmaniya', 'city': 'Manama', 'timeZone': 'Asia/Bahrain'}
      : pageOf(const []),
  _ => null,
};

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('signed out: searches with filters and offers sign-in, never registering', (tester) async {
    final server = await pumpScreen(
      tester,
      const FindHospitalScreen(),
      publicServer,
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(null))],
    );
    expect(find.text('Salmaniya'), findsOneWidget);
    expect(find.text('Sign in to book a visit'), findsOneWidget);
    expect(find.text('Register as a patient here'), findsNothing);

    await tester.tap(find.text('Private · paid'));
    await tester.pumpAndSettle();
    expect(server.requests.last.queryParameters['type'], 'PRIVATE');
    await tester.tap(find.text('Open now').first);
    await tester.pumpAndSettle();
    expect(server.requests.last.queryParameters['openingState'], 'OPEN_NOW');
  });

  testWidgets('the city opens once a country is chosen and goes with it', (tester) async {
    final server = await pumpScreen(
      tester,
      const FindHospitalScreen(),
      publicServer,
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(null))],
    );
    await tester.tap(find.text('Country'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bahrain').last);
    await tester.pumpAndSettle();
    expect(server.requests.last.queryParameters['countryId'], 'c1');
    await tester.tap(find.text('City'), warnIfMissed: false);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manama').last);
    await tester.pumpAndSettle();
    expect(server.requests.last.queryParameters['cityId'], 'ct1');
  });

  testWidgets('signed in: registers at a hospital and then shows Registered here', (tester) async {
    var enrolled = false;
    final server = await pumpScreen(tester, const FindHospitalScreen(), (r) {
      if (r.path == '/patients/me/hospitals' && r.method == 'POST') enrolled = true;
      if (r.path == '/patients/me/hospitals' && r.method == 'GET' && enrolled) {
        return pageOf([
          {'id': 'h1', 'code': 'H1', 'name': 'Salmaniya', 'city': 'Manama', 'timeZone': 'Asia/Bahrain'},
        ]);
      }
      return publicServer(r);
    }, overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))]);
    await tester.tap(find.widgetWithText(FilledButton, 'Register as a patient here'));
    await tester.pumpAndSettle();
    expect(server.requests.firstWhere((r) => r.method == 'POST').data, {'hospitalId': 'h1'});
    expect(find.text('Registered here'), findsOneWidget);
    expect(find.text('You are registered as a patient at Salmaniya.'), findsOneWidget);
  });

  testWidgets('near: a failed search shows the error', (tester) async {
    await pumpScreen(
      tester,
      const HospitalsNearScreen(),
      (r) => r.path == '/hospitals/matching-my-residence' ? const Failure(500, 'BOOM') : pageOf(const []),
      overrides: [signedInUserIdProvider.overrideWithValue('u1')],
    );
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('near: without a home address it points to the search', (tester) async {
    await pumpScreen(
      tester,
      const HospitalsNearScreen(),
      (r) => r.path == '/hospitals/matching-my-residence' ? const Failure(422, 'RESIDENCE_REQUIRED') : pageOf(const []),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))],
    );
    expect(find.text('We do not know where you live yet'), findsOneWidget);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('near: filters by opening state', (tester) async {
    final server = await pumpScreen(
      tester,
      const HospitalsNearScreen(),
      (r) => r.path == '/hospitals/matching-my-residence' ? pageOf([hospital(state: 'CLOSED_NOW')]) : pageOf(const []),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))],
    );
    await tester.tap(find.text('Closed now').first);
    await tester.pumpAndSettle();
    expect(server.lastTo('/hospitals/matching-my-residence').queryParameters['openingState'], 'CLOSED_NOW');
  });

  test('says when the opening state changes', () {
    final now = DateTime(2026, 11, 9, 9);
    expect(nextChangeLabel(OpeningStatus(state: OpeningState.openNow, nextChangeAt: DateTime(2026, 11, 9, 16)), now), 'Closes at 16:00');
    expect(nextChangeLabel(OpeningStatus(state: OpeningState.closedNow, nextChangeAt: DateTime(2026, 11, 9, 18)), now), 'Opens today 18:00');
    expect(nextChangeLabel(const OpeningStatus(state: OpeningState.open24Hours), now), isNull);
  });
}
