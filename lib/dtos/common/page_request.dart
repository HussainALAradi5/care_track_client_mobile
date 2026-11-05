import '../../enums/common/sort_direction.dart';

/// Query for any paged list; the server caps the page size and checks the sort field against its allowlist.
/// Unset sort values and filters are left out of the query.
class PageRequest {
  const PageRequest({
    required this.page,
    required this.pageSize,
    this.sortBy,
    this.sortDirection,
    this.filters = const {},
  });

  final int page;
  final int pageSize;
  final String? sortBy;
  final SortDirection? sortDirection;
  final Map<String, Object?> filters;

  Map<String, dynamic> toQuery() => {
    'page': page,
    'pageSize': pageSize,
    'sortBy': ?sortBy,
    'sortDirection': ?sortDirection?.wire,
    for (final entry in filters.entries)
      if (entry.value != null) entry.key: entry.value,
  };
}
