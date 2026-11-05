import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/document_texts.dart';
import '../../controllers/documents/my_documents_controller.dart';
import '../../models/documents/written_document.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/documents/document_sheet.dart';
import '../../widgets/documents/document_tile.dart';
import '../../widgets/layout/page_heading.dart';

/// The patient's documents from every hospital, newest first; tap one to read it.
class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(myDocumentsProvider.notifier);
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const PageHeading(title: DocumentTexts.myDocumentsTitle, subtitle: DocumentTexts.myDocumentsSubtitle),
          const SizedBox(height: 16),
          PagedList<WrittenDocument>(
            value: ref.watch(myDocumentsProvider),
            idOf: (d) => d.id,
            emptyIcon: Icons.folder_open_rounded,
            emptyTitle: DocumentTexts.myDocumentsEmpty,
            emptyHint: DocumentTexts.myDocumentsEmptyHint,
            onRetry: controller.refresh,
            onLoadMore: controller.loadMore,
            itemBuilder: (d) =>
                DocumentTile(document: d, onTap: () => showDocumentSheet(context, myDocumentProvider(d.id))),
          ),
        ],
      ),
    );
  }
}
