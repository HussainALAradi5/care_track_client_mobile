import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../dtos/common/page_request.dart';
import '../../models/care/appointment.dart';
import '../../models/documents/written_document.dart';
import '../core/service_providers.dart';

/// The documents written for one visit (the first page is all a visit realistically has).
final visitDocumentsProvider = FutureProvider.family<List<WrittenDocument>, Appointment>((ref, visit) async {
  final page = await ref
      .read(writtenDocumentServiceProvider)
      .forVisit(visit.hospitalId, visit.id, const PageRequest(page: 0, pageSize: AppConstants.pageSize));
  return page.items;
});

/// One visit document with its body.
final visitDocumentProvider = FutureProvider.family<WrittenDocument, ({Appointment visit, String documentId})>(
  (ref, key) =>
      ref.read(writtenDocumentServiceProvider).getForVisit(key.visit.hospitalId, key.visit.id, key.documentId),
);
