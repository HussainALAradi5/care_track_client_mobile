/// Server PageResult.PageInfo (zero-based page number).
class PageInfo {
  const PageInfo({
    required this.number,
    required this.size,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
  });

  final int number;
  final int size;
  final int totalItems;
  final int totalPages;
  final bool hasNext;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
    number: json['number'] as int,
    size: json['size'] as int,
    totalItems: (json['totalItems'] as num).toInt(),
    totalPages: json['totalPages'] as int,
    hasNext: json['hasNext'] as bool,
  );
}
