import 'page_info.dart';

/// Server `PageResult<T>`.
class PageResult<T> {
  const PageResult({required this.items, required this.page});

  final List<T> items;
  final PageInfo page;

  factory PageResult.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) item) => PageResult(
    items: (json['items'] as List<dynamic>).map((e) => item(e as Map<String, dynamic>)).toList(),
    page: PageInfo.fromJson(json['page'] as Map<String, dynamic>),
  );
}
