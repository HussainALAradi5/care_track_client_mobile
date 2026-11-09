import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import 'package:intl/intl.dart';

import '../../constants/texts/document_texts.dart';
import '../../models/documents/written_document.dart';
import '../common/feedback/async_body.dart';
import 'document_body.dart';
import 'sick_note_use.dart';

/// Opens one document full height: kind, title, who issued it where and when, then the body.
Future<void> showDocumentSheet(BuildContext context, ProviderListenable<AsyncValue<WrittenDocument>> document) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        builder: (_, controller) => Consumer(
          builder: (context, ref, _) => AsyncBody(
            value: ref.watch(document),
            data: (doc) => ListView(
              controller: controller,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                _Header(document: doc),
                if (doc.kind == DocumentTexts.sickLeaveKind && doc.restFrom != null && doc.restTo != null)
                  SickNoteUse(document: doc),
                const Divider(height: 32),
                DocumentBody(html: doc.body),
              ],
            ),
          ),
        ),
      ),
    );

class _Header extends StatelessWidget {
  const _Header({required this.document});

  final WrittenDocument document;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (DocumentTexts.kinds[document.kind] ?? document.kind).toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary, letterSpacing: 0.8),
        ),
        const SizedBox(height: 4),
        Text(document.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          '${DocumentTexts.issuedBy(document.authorName)} · ${document.hospitalName} · '
          '${DateFormat.yMMMd().add_Hm().format(document.issuedAt)}',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
