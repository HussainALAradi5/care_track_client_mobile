import 'package:care_track_client_mobile/constants/permission_codes.dart';
import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:care_track_client_mobile/controllers/auth/pending_sign_up_controller.dart';
import 'package:care_track_client_mobile/controllers/chat/chat_typing_controller.dart';
import 'package:care_track_client_mobile/controllers/chat/chat_uploads_controller.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/controllers/identity/care_mode_controller.dart';
import 'package:care_track_client_mobile/controllers/notifications/notification_preferences_controller.dart';
import 'package:care_track_client_mobile/controllers/facilities/hospitals_near_controller.dart';
import 'package:care_track_client_mobile/controllers/ui/app_toast_controller.dart';
import 'package:care_track_client_mobile/controllers/workforce/attendance_controller.dart';
import 'package:care_track_client_mobile/controllers/workforce/leave_requests_controller.dart';
import 'package:care_track_client_mobile/controllers/workforce/my_leave_controller.dart';
import 'package:care_track_client_mobile/controllers/workforce/payslips_controller.dart';
import 'package:care_track_client_mobile/controllers/workforce/staff_requests_controller.dart';
import 'package:care_track_client_mobile/controllers/workforce/team_controller.dart';
import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:care_track_client_mobile/models/ui/app_toast.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/api_harness.dart';

const staffMember = SessionUser(userId: 'u1', name: 'Sam', userType: UserType.doctor);

class SwitchableStaff extends AuthController {
  @override
  Future<SessionUser?> build() async => staffMember;

  void become(SessionUser? user) => state = AsyncData(user);
}

Object? server(RequestOptions r) {
  final myLeave = {'year': 2026, 'employed': true, 'balances': const [], 'requests': const []};
  return switch (r.path) {
    '/auth/me/hospitals' => pageOf([
      {
        'hospitalId': 'h1',
        'organizationId': 'o1',
        'code': 'H1',
        'name': 'Dev',
        'administrator': false,
        'permissions': [PermissionCodes.leaveReadAll, PermissionCodes.staffRequestHandle],
      },
    ]),
    '/organizations/o1/leave/mine' => myLeave,
    '/hospitals/h1/attendance/me/today' => {'workingDay': true, 'canClockIn': true, 'canClockOut': false},
    '/hospitals/h1/attendance/me' => const [],
    '/hospitals/h1/attendance/day' => {'rows': const []},
    '/auth/me/team' => const [],
    '/auth/me/departments' => const [],
    '/notifications/preferences' => {'types': const [], 'quietHoursStart': null, 'quietHoursEnd': null},
    _ => pageOf(const []),
  };
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every new controller drops what it held when the person signs out', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final fake = FakeServer(server);
    final c = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dioFor(fake))),
        authControllerProvider.overrideWith(SwitchableStaff.new),
      ],
    );
    addTearDown(c.dispose);
    final auto = [
      c.listen(myLeaveProvider, (_, _) {}),
      c.listen(leaveToDecideProvider, (_, _) {}),
      c.listen(attendanceTodayProvider, (_, _) {}),
      c.listen(attendanceHistoryProvider, (_, _) {}),
      c.listen(teamTodayProvider, (_, _) {}),
      c.listen(leaveRequestsProvider, (_, _) {}),
      c.listen(staffRequestsProvider, (_, _) {}),
      c.listen(payslipsProvider, (_, _) {}),
      c.listen(hospitalsNearProvider, (_, _) {}),
      c.listen(myTeamProvider, (_, _) {}),
      c.listen(myDepartmentsProvider, (_, _) {}),
      c.listen(notificationPreferencesProvider, (_, _) {}),
      c.listen(chatTypingProvider('c1'), (_, _) {}),
      c.listen(chatUploadsProvider('c1'), (_, _) {}),
    ];
    await c.read(authControllerProvider.future);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    expect(c.read(myLeaveProvider).value, isNotNull);
    expect(c.read(attendanceTodayProvider).value, isNotNull);
    expect(c.read(notificationPreferencesProvider).value, isNotNull);
    c.read(appToastProvider.notifier).show(const AppToast(message: 'x'));
    await c.read(careModeProvider.notifier).set(true);
    expect(c.read(careModeProvider), isTrue);
    c.read(pendingSignUpProvider.notifier).set(false);
    c.read(chatTypingProvider('c1').notifier).applyTyping('someone', true);

    (c.read(authControllerProvider.notifier) as SwitchableStaff).become(null);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(c.read(myLeaveProvider).value, isNull);
    expect(c.read(leaveToDecideProvider).value, isEmpty);
    expect(c.read(attendanceTodayProvider).value, isNull);
    expect(c.read(attendanceHistoryProvider).value, isEmpty);
    expect(c.read(teamTodayProvider).value, isEmpty);
    expect(c.read(leaveRequestsProvider).value?.items, isEmpty);
    expect(c.read(staffRequestsProvider).value?.items, isEmpty);
    expect(c.read(payslipsProvider).value?.items, isEmpty);
    expect(c.read(hospitalsNearProvider).value?.items, isEmpty);
    expect(c.read(myTeamProvider).value, isEmpty);
    expect(c.read(myDepartmentsProvider).value, isEmpty);
    expect(c.read(notificationPreferencesProvider).value, isNull);
    expect(c.read(chatTypingProvider('c1')), isEmpty);
    expect(c.read(chatUploadsProvider('c1')), isEmpty);
    expect(c.read(careModeProvider), isFalse);
    expect(c.read(appToastProvider), isNull);
    expect(c.read(pendingSignUpProvider), isFalse);
    for (final subscription in auto) {
      subscription.close();
    }
  });
}
