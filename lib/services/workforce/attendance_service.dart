import '../../config/endpoints.dart';
import '../../dtos/workforce/clock_out_request.dart';
import '../../models/workforce/day_attendance_row.dart';
import '../../models/workforce/my_attendance_today.dart';
import '../../models/workforce/staff_attendance.dart';
import '../../models/workforce/work_attendance.dart';
import '../../utilities/time/dates.dart';
import '../api/api_client.dart';

/// The caller's clock-in and out at a Hospital, their days, and the day's people.
class AttendanceService {
  AttendanceService(this._api);

  final ApiClient _api;

  Future<MyAttendanceToday> today(String hospitalId) async =>
      MyAttendanceToday.fromJson(await _api.get(Endpoints.attendanceToday(hospitalId)));

  Future<MyAttendanceToday> clockIn(String hospitalId) async =>
      MyAttendanceToday.fromJson(await _api.post(Endpoints.clockIn(hospitalId)));

  Future<MyAttendanceToday> clockOut(String hospitalId, int expectedVersion) async => MyAttendanceToday.fromJson(
    await _api.post(Endpoints.clockOut(hospitalId), body: ClockOutRequest(expectedVersion: expectedVersion).toJson()),
  );

  /// Only the doctor or nurse the shift belongs to may clock in to it.
  Future<StaffAttendance> clockInToShift(String hospitalId, String shiftId) async =>
      StaffAttendance.fromJson(await _api.post(Endpoints.shiftClockIn(hospitalId, shiftId)));

  Future<StaffAttendance> clockOutOfShift(String hospitalId, String shiftId, int expectedVersion) async =>
      StaffAttendance.fromJson(
        await _api.post(
          Endpoints.shiftClockOut(hospitalId, shiftId),
          body: ClockOutRequest(expectedVersion: expectedVersion).toJson(),
        ),
      );

  /// The caller's days, the last two weeks by default.
  Future<List<WorkAttendance>> mine(String hospitalId) async => [
    for (final day in await _api.getList(Endpoints.myAttendance(hospitalId)))
      WorkAttendance.fromJson(day as Map<String, dynamic>),
  ];

  /// One day at the Hospital: HR everyone, a manager their direct reports.
  Future<List<DayAttendanceRow>> dayRows(String hospitalId, DateTime date) async {
    final json = await _api.get(Endpoints.attendanceDay(hospitalId), query: {'date': isoDay(date)});
    return [for (final row in json['rows'] as List<dynamic>) DayAttendanceRow.fromJson(row as Map<String, dynamic>)];
  }
}
