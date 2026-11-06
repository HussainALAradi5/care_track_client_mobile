/// Mirrors the server's AppointmentRoomSource: the clinician's planned room, or the session's room once it starts.
enum AppointmentRoomSource {
  planned('PLANNED'),
  session('SESSION');

  const AppointmentRoomSource(this.wire);
  final String wire;

  static AppointmentRoomSource? fromWire(String? value) =>
      value == null ? null : values.firstWhere((s) => s.wire == value);
}
