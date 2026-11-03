import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import 'patient_context_controller.dart';

/// A paged list for the selected Hospital: loads the first page, reloads when the Hospital changes,
/// and appends further pages on demand. Subclasses only say how to fetch one page.
abstract class HospitalPagedController<T> extends AsyncNotifier<PagedItems<T>> {
  Future<PageResult<T>> fetch(String hospitalId, PageRequest request);

  @override
  Future<PagedItems<T>> build() async {
    final hospital = ref.watch(selectedHospitalProvider);
    if (hospital == null) return PagedItems<T>(items: const [], nextPage: 0, hasNext: false);
    return _toItems(await fetch(hospital.id, const PageRequest(page: 0, size: AppConstants.pageSize)), const []);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    final hospital = ref.read(selectedHospitalProvider);
    if (current == null || hospital == null || !current.hasNext || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await fetch(hospital.id, PageRequest(page: current.nextPage, size: AppConstants.pageSize));
      state = AsyncData(_toItems(next, current.items));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  PagedItems<T> _toItems(PageResult<T> page, List<T> before) =>
      PagedItems(items: [...before, ...page.items], nextPage: page.page.number + 1, hasNext: page.page.hasNext);
}
