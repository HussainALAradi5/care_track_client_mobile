import 'package:care_track_client_mobile/constants/app_constants.dart';
import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/controllers/identity/care_mode_controller.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:care_track_client_mobile/screens/identity/profile_screen.dart';
import 'package:care_track_client_mobile/widgets/common/pickers/picker_style_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/api_harness.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Map<String, dynamic> hospitals() => pageOf([
    {'id': 'p1', 'code': 'P1', 'name': 'Patient Hospital', 'city': 'Manama', 'timeZone': 'Asia/Bahrain'},
  ]);

  testWidgets('a patient has no Work switch and sees where they are registered', (tester) async {
    await pumpScreen(
      tester,
      const ProfileScreen(),
      (_) => hospitals(),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))],
    );
    expect(find.text('Rana Patient'), findsOneWidget);
    expect(find.text('Patient Hospital'), findsOneWidget);
    expect(find.text('Work'), findsNothing);
    expect(find.textContaining('Account type'), findsNothing);
  });

  testWidgets('staff switch to My care and then see their patient hospitals', (tester) async {
    await pumpScreen(
      tester,
      const ProfileScreen(),
      (_) => hospitals(),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(doctor))],
    );
    expect(find.text('Dev Hospital'), findsOneWidget);
    expect(find.text('Patient Hospital'), findsNothing);
    await tester.tap(find.text('My care'));
    await tester.pumpAndSettle();
    expect(find.text('Patient Hospital'), findsOneWidget);
  });

  testWidgets('a failed hospital list shows the error with a retry', (tester) async {
    await pumpScreen(
      tester,
      const ProfileScreen(),
      (r) => r.path == '/patients/me/hospitals'
          ? const Failure(500, 'BOOM')
          : {'types': const [], 'quietHoursStart': null, 'quietHoursEnd': null},
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))],
    );
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('Picker style opens from the profile', (tester) async {
    await pumpScreen(
      tester,
      const ProfileScreen(),
      (_) => hospitals(),
      overrides: [authControllerProvider.overrideWith(() => FixedAuth(patient))],
    );
    await tester.tap(find.text('Picker style'));
    await tester.pumpAndSettle();
    expect(find.byType(PickerStyleSheet), findsOneWidget);
  });

  test('care mode is per account and resets at sign-out', () async {
    SharedPreferences.setMockInitialValues({'${AppConstants.careModeKey}.u2': true});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authControllerProvider.overrideWith(() => FixedAuth(doctor)),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    expect(container.read(careModeProvider), isTrue);
    container.read(authControllerProvider.notifier).completeSignUp(
      const SessionUser(userId: 'u3', name: 'Other', userType: UserType.doctor),
    );
    await Future<void>.delayed(Duration.zero);
    expect(container.read(careModeProvider), isFalse, reason: 'the next person starts on their own choice');
    await (container.read(authControllerProvider.notifier) as FixedAuth).signOutLocally();
    expect(container.read(careModeProvider), isFalse);
  });
}
