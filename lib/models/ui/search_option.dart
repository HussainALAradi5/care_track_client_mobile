/// One row of a type-to-search picker. [none] is the "no choice" row of a filter.
class SearchOption {
  const SearchOption({required this.id, required this.label, this.detail});

  static const none = SearchOption(id: '', label: '');

  final String id;
  final String label;
  final String? detail;

  bool get isNone => id.isEmpty;
}
