import 'package:care_track_client_mobile/controllers/ui/picker_style_controller.dart';
import 'package:care_track_client_mobile/enums/ui/picker_style.dart';
import 'package:care_track_client_mobile/screens/auth/sign_up_screen.dart';
import 'package:care_track_client_mobile/widgets/common/pickers/smooth_calendar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../support/api_harness.dart';

Object? catalog(RequestOptions r) => switch (r.path) {
  '/public/places/countries' => pageOf([
    {'id': 'c1', 'name': 'Bahrain', 'isoCode': 'BH', 'dialingCode': '+973'},
  ]),
  '/public/places/countries/c1/cities' => pageOf([
    {'id': 'ct1', 'name': 'Manama', 'localCode': 'MAN'},
  ]),
  '/public/hospitals' => pageOf([
    {'id': 'h1', 'name': 'Salmaniya', 'type': 'PUBLIC', 'city': 'Manama', 'addressLine': 'Road 1'},
  ]),
  _ => null,
};

Object? accepting(RequestOptions r) => r.path == '/auth/sign-up'
    ? {'userId': 'u1', 'name': 'New Person', 'userType': 'PATIENT', 'username': 'new', 'pickerStyle': null}
    : catalog(r);

Future<void> choose(WidgetTester tester, String field, String row) async {
  await tester.tap(find.text(field), warnIfMissed: false);
  await tester.pumpAndSettle();
  await tester.tap(find.text(row).last);
  await tester.pumpAndSettle();
}

Future<void> fillRequired(WidgetTester tester) async {
  await tester.tap(find.text('Female'));
  await tester.tap(find.text('Married'));
  await tester.pumpAndSettle();
  await choose(tester, 'Nationality', 'Bahrain');
  await choose(tester, 'Country you live in', 'Bahrain');
  await choose(tester, 'City', 'Manama');
  await tester.enterText(find.widgetWithText(TextField, 'Address'), '  Road 1  ');
  await tester.pumpAndSettle();
  await choose(tester, 'Hospital', 'Salmaniya');
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('finishing with nothing filled in marks what is missing and sends nothing', (tester) async {
    final server = await pumpScreen(tester, const SignUpScreen(), accepting);
    await tester.tap(find.widgetWithText(FilledButton, 'Finish signing up'));
    await tester.pumpAndSettle();
    expect(find.text('Required'), findsNWidgets(6));
    expect(find.text('Enter your address.'), findsOneWidget);
    expect(find.text('Fill in the highlighted fields first.'), findsOneWidget);
    expect(server.requests.where((r) => r.path == '/auth/sign-up'), isEmpty);
  });

  testWidgets('sends the form with type-to-search choices and no user type', (tester) async {
    final server = await pumpScreen(tester, const SignUpScreen(), accepting);
    await fillRequired(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Finish signing up'));
    await tester.pumpAndSettle();
    expect(server.lastTo('/auth/sign-up').data, {
      'phoneNumber': null,
      'dateOfBirth': null,
      'gender': 'FEMALE',
      'maritalStatus': 'MARRIED',
      'nationalityCountryId': 'c1',
      'residenceCountryId': 'c1',
      'residenceCityId': 'ct1',
      'residenceAddressLine': 'Road 1',
      'hospitalId': 'h1',
    });
    expect(server.lastTo('/public/hospitals').queryParameters['countryId'], 'c1');
    expect(server.lastTo('/public/hospitals').queryParameters['cityId'], 'ct1');
  });

  testWidgets('a new country clears the city and the hospital', (tester) async {
    await pumpScreen(tester, const SignUpScreen(), accepting);
    await fillRequired(tester);
    expect(find.text('Manama'), findsOneWidget);
    await choose(tester, 'Country you live in', 'Bahrain');
    // The same country changes nothing.
    expect(find.text('Salmaniya'), findsOneWidget);
  });

  testWidgets('shows the server error and stays on the form', (tester) async {
    await pumpScreen(
      tester,
      const SignUpScreen(),
      (r) => r.path == '/auth/sign-up' ? const Failure(409, 'SIGN_UP_ALREADY_DONE') : catalog(r),
    );
    await fillRequired(tester);
    await tester.tap(find.widgetWithText(FilledButton, 'Finish signing up'));
    await tester.pumpAndSettle();
    expect(find.text('This sign-in already has a CareTrack account.'), findsOneWidget);
    expect(find.byType(SignUpScreen), findsOneWidget);
  });

  testWidgets('a mistyped mobile number is flagged', (tester) async {
    await pumpScreen(tester, const SignUpScreen(), accepting);
    await tester.enterText(find.widgetWithText(TextField, 'Mobile number'), '3312');
    await tester.pumpAndSettle();
    expect(find.text('Start with + and the country code, digits only.'), findsOneWidget);
  });

  testWidgets('the birth date opens through AppPickers in the chosen look', (tester) async {
    await pumpScreen(
      tester,
      const SignUpScreen(),
      accepting,
      overrides: [chosenPickerStyleProvider.overrideWithValue(PickerStyle.smooth)],
    );
    await tester.tap(find.text('Date of birth'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(SmoothCalendar), findsOneWidget);
  });
}
