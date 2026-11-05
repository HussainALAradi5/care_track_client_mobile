import 'package:care_track_client_mobile/dtos/common/page_request.dart';
import 'package:care_track_client_mobile/enums/common/sort_direction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sends page and pageSize, and only the sort and filters that are set', () {
    const request = PageRequest(page: 1, pageSize: 10, filters: {'status': 'REQUESTED', 'upcoming': null});
    expect(request.toQuery(), {'page': 1, 'pageSize': 10, 'status': 'REQUESTED'});
  });

  test('sends the sort field and direction when given', () {
    const request = PageRequest(page: 0, pageSize: 5, sortBy: 'name', sortDirection: SortDirection.descending);
    expect(request.toQuery(), {'page': 0, 'pageSize': 5, 'sortBy': 'name', 'sortDirection': 'desc'});
  });
}
