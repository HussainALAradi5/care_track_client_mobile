import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/texts/document_texts.dart';
import '../../models/documents/written_document.dart';

const _icons = {
  'MEDICAL_REPORT': Icons.description_outlined,
  'ATTENDANCE_CERTIFICATE': Icons.event_available_outlined,
  'FITNESS_CERTIFICATE': Icons.fitness_center_outlined,
  'REFERRAL_NOTE': Icons.forward_to_inbox_outlined,
  'GENERAL_LETTER': Icons.mail_outline,
};

/// One document in a list: kind icon, title, date and hospital.
class DocumentTile extends StatelessWidget {
  const DocumentTile({super.key, required this.document, required this.onTap});

  final WrittenDocument document;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: EdgeInsets.zero,
      child: ListTile(
        onTap: onTap,
        leading: Icon(_icons[document.kind] ?? Icons.description_outlined, color: scheme.primary),
        title: Text(document.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${DocumentTexts.kinds[document.kind] ?? document.kind} · ${DateFormat.yMMMd().format(document.issuedAt)} · '
          '${document.hospitalName}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
