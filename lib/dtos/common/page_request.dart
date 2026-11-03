/// Query for any paged list; the server caps the size. Unset filters are left out of the query.
class PageRequest {
  const PageRequest({required this.page, required this.size, this.filters = const {}});

  final int page;
  final int size;
  final Map<String, Object?> filters;

  Map<String, dynamic> toQuery() => {
    'page': page,
    'size': size,
    for (final entry in filters.entries)
      if (entry.value != null) entry.key: entry.value,
  };
}
