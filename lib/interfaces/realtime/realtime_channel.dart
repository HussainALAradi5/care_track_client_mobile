/// The live connection the rest of the app depends on, without knowing it is STOMP.
abstract interface class RealtimeChannel {
  /// Opens the connection and keeps it open, reconnecting with a fresh token, until [disconnect].
  void connect();

  void disconnect();

  /// Messages of one destination as JSON; survives reconnects.
  Stream<Map<String, dynamic>> watch(String destination);

  /// Sends one frame; false when the connection is not up, so the caller falls back to REST.
  bool publish(String destination, Map<String, dynamic> body);

  /// Fires each time a connection opens, including after a reconnect.
  Stream<void> get opened;
}
