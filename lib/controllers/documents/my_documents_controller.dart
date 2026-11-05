import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/common/page_result.dart';
import '../../models/common/paged_items.dart';
import '../../models/documents/written_document.dart';
import '../core/service_providers.dart';

/// The patient's documents from every hospital, newest first (not tied to the selected hospital).
class MyDocumentsController extends AsyncNotifier<PagedItems<WrittenDocument>> {
  @override
  Future<PagedItems<WrittenDocument>> build() async => _toItems(await _fetch(0), const []);

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasNext || current.loadingMore) return;
    state = AsyncData(current.copyWith(loadingMore: true));
    try {
      state = AsyncData(_toItems(await _fetch(current.nextPage), current.items));
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
      rethrow;
    }
  }

  Future<PageResult<WrittenDocument>> _fetch(int page) =>
      ref.read(writtenDocumentServiceProvider).mine(PageRequest(page: page, pageSize: AppConstants.pageSize));

  PagedItems<WrittenDocument> _toItems(PageResult<WrittenDocument> page, List<WrittenDocument> before) =>
      PagedItems(items: [...before, ...page.items], nextPage: page.page + 1, hasNext: page.hasNext);
}

final myDocumentsProvider = AsyncNotifierProvider<MyDocumentsController, PagedItems<WrittenDocument>>(
  MyDocumentsController.new,
);

/// One of the patient's documents with its body.
final myDocumentProvider = FutureProvider.family<WrittenDocument, String>(
  (ref, id) => ref.read(writtenDocumentServiceProvider).mineById(id),
);
