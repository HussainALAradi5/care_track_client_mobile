/// Body of a clock-out, daily or from a shift: the version of the record the person saw.
class ClockOutRequest {
  const ClockOutRequest({required this.expectedVersion});

  final int expectedVersion;

  Map<String, dynamic> toJson() => {'expectedVersion': expectedVersion};
}
