import '../../config/endpoints.dart';
import '../../dtos/care/cancel_appointment_request.dart';
import '../../dtos/common/page_request.dart';
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

  Future<Appointment> cancel(Appointment appointment, String reason) async => Appointment.fromJson(
    await _api.post(
      Endpoints.cancelAppointment(appointment.hospitalId, appointment.id),
      body: CancelAppointmentRequest(expectedVersion: appointment.version, reason: reason).toJson(),
    ),
  );
}
