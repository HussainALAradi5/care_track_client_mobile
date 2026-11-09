import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/workforce/day_attendance_row.dart';
import '../../models/workforce/my_attendance_today.dart';
import '../../models/workforce/work_attendance.dart';
import '../core/service_providers.dart';
import '../identity/staff_context_controller.dart';

/// The selected Hospital; null signed out, so every attendance view resets then.
final attendanceHospitalIdProvider = Provider<String?>((ref) => ref.watch(selectedStaffHospitalProvider)?.hospitalId);

/// The caller's day at the selected Hospital; clocking answers with the new day.
class AttendanceTodayController extends AsyncNotifier<MyAttendanceToday?> {
  @override
  Future<MyAttendanceToday?> build() async {
    final hospitalId = ref.watch(attendanceHospitalIdProvider);
    return hospitalId == null ? null : ref.read(attendanceServiceProvider).today(hospitalId);
  }

  Future<void> clockIn() => _clock((hospitalId) => ref.read(attendanceServiceProvider).clockIn(hospitalId));

  Future<void> clockOut(int expectedVersion) =>
      _clock((hospitalId) => ref.read(attendanceServiceProvider).clockOut(hospitalId, expectedVersion));

  /// A refused change reloads the day (someone else may have changed it) and still reaches the caller.
  Future<void> _clock(Future<MyAttendanceToday> Function(String hospitalId) call) async {
    final hospitalId = ref.read(attendanceHospitalIdProvider);
    if (hospitalId == null) return;
    try {
      state = AsyncData(await call(hospitalId));
      ref.invalidate(attendanceHistoryProvider);
    } catch (_) {
      ref.invalidateSelf();
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    ref.invalidate(attendanceHistoryProvider);
    ref.invalidate(teamTodayProvider);
    await future;
  }
}

final attendanceTodayProvider = AsyncNotifierProvider<AttendanceTodayController, MyAttendanceToday?>(
  AttendanceTodayController.new,
);

/// The caller's last two weeks.
final attendanceHistoryProvider = FutureProvider<List<WorkAttendance>>((ref) async {
  final hospitalId = ref.watch(attendanceHospitalIdProvider);
  return hospitalId == null ? const [] : ref.read(attendanceServiceProvider).mine(hospitalId);
});

/// Managers: their people here today. Empty for anyone else, whom the server refuses.
final teamTodayProvider = FutureProvider<List<DayAttendanceRow>>((ref) async {
  final hospitalId = ref.watch(attendanceHospitalIdProvider);
  if (hospitalId == null) return const [];
  try {
    return await ref.read(attendanceServiceProvider).dayRows(hospitalId, DateTime.now());
  } catch (_) {
    return const [];
  }
});
