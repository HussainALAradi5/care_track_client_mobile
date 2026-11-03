import '../../config/endpoints.dart';
import '../../dtos/care/create_booking_request.dart';
import '../../dtos/common/page_request.dart';
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
    await _api.post(Endpoints.cancelBooking(booking.hospitalId, booking.id), query: {'expectedVersion': booking.version}),
  );
}
