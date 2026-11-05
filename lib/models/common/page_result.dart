/// Server `PageResult<T>`: one page of items, the zero-based page, its size and the exact totals.
class PageResult<T> {
  const PageResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
  });

  final List<T> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;

  factory PageResult.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) item) => PageResult(
    items: (json['items'] as List<dynamic>).map((e) => item(e as Map<String, dynamic>)).toList(),
    page: json['page'] as int,
    pageSize: json['pageSize'] as int,
    totalItems: (json['totalItems'] as num).toInt(),
    totalPages: json['totalPages'] as int,
    hasNext: json['hasNext'] as bool,
  );
}
