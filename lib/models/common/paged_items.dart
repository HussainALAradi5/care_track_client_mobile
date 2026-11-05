/// Items loaded so far from a paged list, and whether more pages exist.
class PagedItems<T> {
  const PagedItems({required this.items, required this.nextPage, required this.hasNext, this.loadingMore = false});

  final List<T> items;
  final int nextPage;
  final bool hasNext;
  final bool loadingMore;

  PagedItems<T> copyWith({List<T>? items, int? nextPage, bool? hasNext, bool? loadingMore}) => PagedItems(
    items: items ?? this.items,
    nextPage: nextPage ?? this.nextPage,
    hasNext: hasNext ?? this.hasNext,
    loadingMore: loadingMore ?? this.loadingMore,
  );
}
