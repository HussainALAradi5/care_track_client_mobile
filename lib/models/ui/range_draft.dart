import 'package:flutter/foundation.dart';

/// A date range being chosen: the end stays null until the second day is picked.
@immutable
class RangeDraft {
  const RangeDraft({this.start, this.end});

  final DateTime? start;
  final DateTime? end;

  @override
  bool operator ==(Object other) => other is RangeDraft && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);
}
