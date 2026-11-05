import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../constants/permission_codes.dart';
import '../../dtos/common/page_request.dart';
import '../../models/accounting/journal_entry.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../core/service_providers.dart';
import '../identity/organization_context_controller.dart';

/// The selected Organization's journal, newest first, loading further pages on demand.
class JournalController extends AsyncNotifier<PagedItems<JournalEntry>> {
  String? _organizationId({bool watch = true}) {
    final organization = watch ? ref.watch(selectedOrganizationProvider) : ref.read(selectedOrganizationProvider);
    return organization != null && organization.can(PermissionCodes.journalRead) ? organization.organizationId : null;
  }

  @override
  Future<PagedItems<JournalEntry>> build() async {
    final id = _organizationId();
    if (id == null) return const PagedItems(items: [], nextPage: 0, hasNext: false);
    return _toItems(await _fetch(id, 0), const []);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    final id = _organizationId(watch: false);
    if (current == null || id == null || !current.hasNext || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      state = AsyncData(_toItems(await _fetch(id, current.nextPage), current.items));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  Future<PageResult<JournalEntry>> _fetch(String organizationId, int page) => ref
      .read(accountingServiceProvider)
      .journal(organizationId, PageRequest(page: page, pageSize: AppConstants.pageSize));

  PagedItems<JournalEntry> _toItems(PageResult<JournalEntry> page, List<JournalEntry> before) =>
      PagedItems(items: [...before, ...page.items], nextPage: page.page + 1, hasNext: page.hasNext);
}

final journalProvider = AsyncNotifierProvider<JournalController, PagedItems<JournalEntry>>(JournalController.new);
