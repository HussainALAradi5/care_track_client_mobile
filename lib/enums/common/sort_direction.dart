/// Mirrors the server's sort directions (SortOptions.ASCENDING / DESCENDING).
enum SortDirection {
  ascending('asc'),
  descending('desc');

  const SortDirection(this.wire);
  final String wire;
}
