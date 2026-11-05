import '../../config/endpoints.dart';
import '../../dtos/common/page_request.dart';
import '../../enums/accounting/report_kind.dart';
import '../../models/accounting/accounting_status.dart';
import '../../models/accounting/journal_entry.dart';
import '../../models/accounting/month_summary.dart';
import '../../models/accounting/report.dart';
import '../../models/common/page_result.dart';
import '../api/api_client.dart';

/// The accountant's read calls: status, month summary, the journal and the statements.
class AccountingService {
  AccountingService(this._api);

  final ApiClient _api;

  Future<AccountingStatus> status(String organizationId) async =>
      AccountingStatus.fromJson(await _api.get(Endpoints.accountingStatus(organizationId)));

  Future<MonthSummary> monthSummary(String organizationId) async =>
      MonthSummary.fromJson(await _api.get(Endpoints.monthSummary(organizationId)));

  Future<PageResult<JournalEntry>> journal(String organizationId, PageRequest request) async => PageResult.fromJson(
    await _api.get(Endpoints.journal(organizationId), query: request.toQuery()),
    JournalEntry.fromJson,
  );

  Future<JournalEntry> entry(String organizationId, String entryId) async =>
      JournalEntry.fromJson(await _api.get(Endpoints.journalEntry(organizationId, entryId)));

  /// As-of statements up to [to]; the income statement from the start of [to]'s year.
  Future<Report> report(String organizationId, ReportKind kind, DateTime to) async {
    final day = _date(to);
    final query = kind.asOf ? {'asOf': day} : {'from': '${to.year}-01-01', 'to': day};
    return Report.fromJson(await _api.get(Endpoints.report(organizationId, kind.path), query: query));
  }

  static String _date(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
