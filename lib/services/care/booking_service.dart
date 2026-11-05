import '../../config/endpoints.dart';
import '../../constants/permission_codes.dart';
import '../../dtos/care/create_booking_request.dart';
import '../../dtos/common/page_request.dart';
import '../../dtos/common/versioned_reason_request.dart';
import '../../models/care/booking.dart';
import '../../models/common/page_result.dart';
import '../api/api_client.dart';

class BookingService {
  BookingService(this._api);

  final ApiClient _api;

  Future<PageResult<Booking>> mine(String hospitalId, PageRequest request) async =>
      PageResult.fromJson(await _api.get(Endpoints.myBookings(hospitalId), query: request.toQuery()), Booking.fromJson);

  Future<Booking> create(String hospitalId, CreateBookingRequest request) async =>
      Booking.fromJson(await _api.post(Endpoints.createBooking(hospitalId), body: request.toJson()));

  /// Patient withdraws a request that is still waiting for a decision.
  Future<Booking> cancel(Booking booking) async => Booking.fromJson(
    await _api.post(
      Endpoints.cancelBooking(booking.hospitalId, booking.id),
      query: {'expectedVersion': booking.version},
    ),
  );

  /// Staff: the hospital's requests (the queue asks for `status=REQUESTED`, oldest first).
  Future<PageResult<Booking>> list(String hospitalId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.hospitalBookings(hospitalId), query: request.toQuery()),
    Booking.fromJson,
  );

  /// Confirms into an appointment. A retried tap on the same version sends the same key, so it never books
  /// twice: the server answers with the appointment it already made.
  Future<void> confirm(Booking booking) => _api.post(
    Endpoints.confirmBooking(booking.hospitalId, booking.id),
    query: {'expectedVersion': booking.version},
    headers: {PermissionCodes.idempotencyHeader: 'confirm-${booking.id}-v${booking.version}'},
  );

  Future<Booking> reject(Booking booking, String reason) async => Booking.fromJson(
    await _api.post(
      Endpoints.rejectBooking(booking.hospitalId, booking.id),
      body: VersionedReasonRequest(expectedVersion: booking.version, reason: reason).toJson(),
    ),
  );
}
