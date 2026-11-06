import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../constants/permission_codes.dart';
import '../../constants/status_styles.dart';
import '../../constants/texts/document_texts.dart';
import '../../controllers/care/my_visits_controller.dart';
import '../../controllers/documents/visit_documents_controller.dart';
import '../../enums/care/appointment_status.dart';
import '../../models/care/appointment.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/paged_list.dart';
import '../../widgets/common/status/status_chip.dart';
import '../../widgets/documents/document_sheet.dart';
import '../../widgets/documents/document_tile.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/care/visit_place.dart';

const _arrived = {AppointmentStatus.checkedIn, AppointmentStatus.inProgress, AppointmentStatus.completed};

/// The clinician's own visits; tap one to read the documents written for it (writing happens on the web).
class VisitsScreen extends ConsumerWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(myVisitsProvider.notifier);
    final time = DateFormat.MMMEd().add_Hm();
    return StaffPage(
      title: DocumentTexts.visitsTitle,
      subtitle: DocumentTexts.visitsSubtitle,
      permission: PermissionCodes.clinicalHistoryWrite,
      onRefresh: controller.refresh,
      children: [
        PagedList<Appointment>(
          value: ref.watch(myVisitsProvider),
          idOf: (a) => a.id,
          emptyIcon: Icons.medical_services_outlined,
          emptyTitle: DocumentTexts.visitsEmpty,
          emptyHint: DocumentTexts.visitsEmptyHint,
          onRetry: controller.refresh,
          onLoadMore: controller.loadMore,
          itemBuilder: (a) => Card.outlined(
            margin: EdgeInsets.zero,
            child: ListTile(
              onTap: () => _openVisit(context, a),
              title: Text(a.patientName, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time.format(a.startsAt)),
                  const SizedBox(height: 6),
                  VisitPlace(appointment: a),
                ],
              ),
              trailing: StatusChip(status: StatusStyles.appointment[a.status]!),
            ),
          ),
        ),
      ],
    );
  }

  void _openVisit(BuildContext context, Appointment visit) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => Consumer(
      builder: (context, ref, _) {
        final theme = Theme.of(context);
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            Text(visit.patientName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(DocumentTexts.visitDocuments, style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            if (!_arrived.contains(visit.status))
              Text(DocumentTexts.notArrived, style: theme.textTheme.bodyMedium)
            else
              AsyncBody(
                value: ref.watch(visitDocumentsProvider(visit)),
                onRetry: () => ref.invalidate(visitDocumentsProvider(visit)),
                data: (documents) => documents.isEmpty
                    ? Text(DocumentTexts.noDocuments, style: theme.textTheme.bodyMedium)
                    : Column(
                        children: [
                          for (final d in documents)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: DocumentTile(
                                document: d,
                                onTap: () =>
                                    showDocumentSheet(context, visitDocumentProvider((visit: visit, documentId: d.id))),
                              ),
                            ),
                        ],
                      ),
              ),
          ],
        );
      },
    ),
  );
}
