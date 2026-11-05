import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/workforce/create_shift_request.dart';
import '../../models/common/page_result.dart';
import '../../models/workforce/clinician_shift.dart';
import '../../models/workforce/shift_clinician.dart';
import '../api/api_client.dart';

/// Scheduler shift planning; every call needs SHIFT:WRITE at the hospital.
class ShiftService {
  ShiftService(this._api);

  final ApiClient _api;

  /// Shifts that have not ended yet, soonest first (a `clinicianId` filter narrows the list to one person).
  Future<PageResult<ClinicianShift>> list(String hospitalId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.shifts(hospitalId), query: request.toQuery()),
    ClinicianShift.fromJson,
  );

  /// Doctors and nurses with a clinical role at the hospital, by name.
  Future<PageResult<ShiftClinician>> clinicians(String hospitalId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.clinicians(hospitalId), query: request.toQuery()),
    ShiftClinician.fromJson,
  );

  Future<ClinicianShift> create(String hospitalId, CreateShiftRequest request) async =>
      ClinicianShift.fromJson(await _api.post(Endpoints.shifts(hospitalId), body: request.toJson()));

  /// Only a shift that has not started and has nothing booked in it can be removed.
  Future<void> remove(ClinicianShift shift) => _api.delete(Endpoints.shift(shift.hospitalId, shift.id));
}
