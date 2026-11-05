import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/permission_codes.dart';
import '../../enums/accounting/report_kind.dart';
import '../../models/accounting/accounting_status.dart';
import '../../models/accounting/journal_entry.dart';
import '../../models/accounting/month_summary.dart';
import '../../models/accounting/report.dart';
import '../core/service_providers.dart';
import '../identity/organization_context_controller.dart';

/// The selected Organization's id when it grants [permission], so a locked screen never calls the server.
String? _organizationWith(Ref ref, String permission) {
  final organization = ref.watch(selectedOrganizationProvider);
  return organization != null && organization.can(permission) ? organization.organizationId : null;
}

/// Whether the books are set up (and the open period); null without an Organization.
final booksStatusProvider = FutureProvider<AccountingStatus?>((ref) async {
  final id = _organizationWith(ref, PermissionCodes.accountRead);
  return id == null ? null : ref.read(accountingServiceProvider).status(id);
});

/// The month next to the month before; null until the books are set up.
final monthSummaryProvider = FutureProvider<MonthSummary?>((ref) async {
  final id = _organizationWith(ref, PermissionCodes.financeReportRead);
  final status = await ref.watch(booksStatusProvider.future);
  if (id == null || status == null || !status.setUp) return null;
  return ref.read(accountingServiceProvider).monthSummary(id);
});

/// One statement up to today.
final reportProvider = FutureProvider.family<Report?, ReportKind>((ref, kind) async {
  final id = _organizationWith(ref, PermissionCodes.financeReportRead);
  return id == null ? null : ref.read(accountingServiceProvider).report(id, kind, DateTime.now());
});

/// One journal entry with its lines.
final journalEntryProvider = FutureProvider.family<JournalEntry?, String>((ref, entryId) async {
  final id = _organizationWith(ref, PermissionCodes.journalRead);
  return id == null ? null : ref.read(accountingServiceProvider).entry(id, entryId);
});
