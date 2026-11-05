import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../dtos/common/page_request.dart';
import '../../models/care/booking.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../core/service_providers.dart';
import 'hospital_paged_controller.dart';

class BookingsController extends HospitalPagedController<Booking> {
  @override
  Future<PageResult<Booking>> fetch(String hospitalId, PageRequest request) =>
      ref.read(bookingServiceProvider).mine(hospitalId, request);

  Future<void> withdraw(Booking booking) async {
    await ref.read(bookingServiceProvider).cancel(booking);
    await refresh();
  }
}

final bookingsProvider = AsyncNotifierProvider<BookingsController, PagedItems<Booking>>(BookingsController.new);
