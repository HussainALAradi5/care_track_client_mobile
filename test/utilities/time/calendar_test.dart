import 'package:care_track_client_mobile/models/ui/range_draft.dart';
import 'package:care_track_client_mobile/utilities/time/calendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('builds six weeks from the first weekday', () {
    final cells = monthCells(DateTime(2026, 11), 1);
    expect(cells, hasLength(42));
    expect(cells.first, DateTime(2026, 10, 26));
    expect(cells[6].weekday, DateTime.sunday);
    expect(monthCells(DateTime(2026, 11), 0).first, DateTime(2026, 11, 1));
  });

  test('clamps into the allowed days', () {
    final first = DateTime(2026, 3, 1);
    final last = DateTime(2026, 3, 31);
    expect(clampDay(DateTime(2026, 2, 1), first, last), first);
    expect(clampDay(DateTime(2026, 4, 1), first, last), last);
    expect(clampDay(DateTime(2026, 3, 9, 15), first, last), DateTime(2026, 3, 9));
  });

  test('a range starts, ends and never goes backwards', () {
    final first = nextRange(const RangeDraft(), DateTime(2026, 3, 5));
    expect(first, RangeDraft(start: DateTime(2026, 3, 5)));
    expect(nextRange(first, DateTime(2026, 3, 8)), RangeDraft(start: DateTime(2026, 3, 5), end: DateTime(2026, 3, 8)));
    expect(nextRange(first, DateTime(2026, 3, 2)), RangeDraft(start: DateTime(2026, 3, 2)));
    final done = RangeDraft(start: DateTime(2026, 3, 5), end: DateTime(2026, 3, 8));
    expect(nextRange(done, DateTime(2026, 3, 9)), RangeDraft(start: DateTime(2026, 3, 9)));
  });
}
