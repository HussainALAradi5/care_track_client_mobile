import '../../enums/facilities/opening_state.dart';

/// Server OpeningStatusDto: open or closed now, and when that changes.
class OpeningStatus {
  const OpeningStatus({required this.state, this.nextChangeAt});

  final OpeningState state;
  final DateTime? nextChangeAt;

  factory OpeningStatus.fromJson(Map<String, dynamic> json) => OpeningStatus(
    state: OpeningState.fromWire(json['state'] as String),
    nextChangeAt: json['nextChangeAt'] == null ? null : DateTime.parse(json['nextChangeAt'] as String),
  );
}
