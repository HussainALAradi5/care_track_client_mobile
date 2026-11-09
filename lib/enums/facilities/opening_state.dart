/// Server OpeningState: worked out from the Hospital's hours, never stored.
enum OpeningState {
  open24Hours('OPEN_24_HOURS'),
  openNow('OPEN_NOW'),
  closingSoon('CLOSING_SOON'),
  closedNow('CLOSED_NOW');

  const OpeningState(this.wire);
  final String wire;

  static OpeningState fromWire(String value) => values.firstWhere((s) => s.wire == value);
}
