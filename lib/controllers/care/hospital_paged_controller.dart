import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import 'patient_context_controller.dart';

/// A paged list for one Hospital: loads the first page, reloads when the Hospital changes, and appends further
/// pages on demand. Subclasses say how to fetch one page; staff lists also say which Hospital (see [watchHospitalId]).
abstract class HospitalPagedController<T> extends AsyncNotifier<PagedItems<T>> {
  Future<PageResult<T>> fetch(String hospitalId, PageRequest request);

  /// The Hospital to list, watched so the list reloads when it changes: the patient's selected one by default.
  String? watchHospitalId() => ref.watch(selectedHospitalProvider)?.id;

  /// The same Hospital read once, for loading further pages.
  String? readHospitalId() => ref.read(selectedHospitalProvider)?.id;

  @override
  Future<PagedItems<T>> build() async {
    final hospitalId = watchHospitalId();
    if (hospitalId == null) return PagedItems<T>(items: const [], nextPage: 0, hasNext: false);
    return _toItems(await fetch(hospitalId, const PageRequest(page: 0, pageSize: AppConstants.pageSize)), const []);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    final hospitalId = readHospitalId();
    if (current == null || hospitalId == null || !current.hasNext || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      final next = await fetch(hospitalId, PageRequest(page: current.nextPage, pageSize: AppConstants.pageSize));
      state = AsyncData(_toItems(next, current.items));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  /// Runs one change, then reloads the list whatever the outcome (someone else may have changed it meanwhile);
  /// a failure still reaches the caller, which shows it.
  Future<void> changeThenRefresh(Future<void> Function() change) async {
    try {
      await change();
    } finally {
      await refresh();
    }
  }

  PagedItems<T> _toItems(PageResult<T> page, List<T> before) =>
      PagedItems(items: [...before, ...page.items], nextPage: page.page + 1, hasNext: page.hasNext);
}
