import '../../config/endpoints.dart';
import '../../dtos/care/check_in_request.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/common/versioned_reason_request.dart';
import '../../enums/identity/presence_verification_method.dart';
import '../../models/care/appointment.dart';
import '../../models/common/page_result.dart';
import '../api/api_client.dart';

class AppointmentService {
  AppointmentService(this._api);

  final ApiClient _api;

  Future<PageResult<Appointment>> mine(String hospitalId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.myAppointments(hospitalId), query: request.toQuery()),
    Appointment.fromJson,
  );

  Future<Appointment> cancel(Appointment appointment, String reason) =>
      _reasoned(Endpoints.cancelAppointment(appointment.hospitalId, appointment.id), appointment, reason);

  /// Staff: the hospital's appointments (the desk asks for one status, soonest first).
  Future<PageResult<Appointment>> list(String hospitalId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.hospitalAppointments(hospitalId), query: request.toQuery()),
    Appointment.fromJson,
  );

  Future<Appointment> checkIn(Appointment appointment, PresenceVerificationMethod method) async => Appointment.fromJson(
    await _api.post(
      Endpoints.checkIn(appointment.hospitalId, appointment.id),
      body: CheckInRequest(expectedVersion: appointment.version, method: method).toJson(),
    ),
  );

  /// The patient did not arrive; the server also records an absent session.
  Future<Appointment> markNoShow(Appointment appointment, String reason) =>
      _reasoned(Endpoints.noShow(appointment.hospitalId, appointment.id), appointment, reason);

  /// Checked in, but the consultation never started.
  Future<Appointment> markNotSeen(Appointment appointment, String reason) =>
      _reasoned(Endpoints.notSeen(appointment.hospitalId, appointment.id), appointment, reason);

  Future<Appointment> _reasoned(String path, Appointment appointment, String reason) async => Appointment.fromJson(
    await _api.post(
      path,
      body: VersionedReasonRequest(expectedVersion: appointment.version, reason: reason).toJson(),
    ),
  );
}
