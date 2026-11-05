import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/care/booking_status.dart';
import '../../enums/common/sort_direction.dart';
import '../../models/care/booking.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../core/service_providers.dart';
import 'staff_paged_controller.dart';

/// Staff booking queue: requests still waiting at the selected Hospital, oldest first.
class QueueController extends StaffPagedController<Booking> {
  @override
  String get permission => PermissionCodes.bookingReadAll;

  @override
  Future<PageResult<Booking>> fetch(String hospitalId, PageRequest request) => ref
      .read(bookingServiceProvider)
      .list(
        hospitalId,
        PageRequest(
          page: request.page,
          pageSize: request.pageSize,
          sortDirection: SortDirection.ascending,
          filters: {'status': BookingStatus.requested.wire},
        ),
      );

  Future<void> confirm(Booking booking) => changeThenRefresh(() => ref.read(bookingServiceProvider).confirm(booking));

  Future<void> reject(Booking booking, String reason) =>
      changeThenRefresh(() => ref.read(bookingServiceProvider).reject(booking, reason));
}

final queueProvider = AsyncNotifierProvider<QueueController, PagedItems<Booking>>(QueueController.new);
