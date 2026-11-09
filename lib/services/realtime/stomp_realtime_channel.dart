import 'dart:async';
import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../constants/realtime.dart';
import '../../interfaces/auth/token_source.dart';
import '../../interfaces/realtime/realtime_channel.dart';

/// STOMP over WebSocket to the server's /ws. Every connection attempt asks the token source for a current access
/// token, so a connection the server closed for an expired token comes back with a fresh one.
class StompRealtimeChannel implements RealtimeChannel {
  StompRealtimeChannel(this._tokens, this._url);

  final TokenSource _tokens;
  final String _url;
  final _connectHeaders = <String, String>{};
  final _destinations = <String, StreamController<Map<String, dynamic>>>{};
  final _opened = StreamController<void>.broadcast();
  StompClient? _client;

  @override
  Stream<void> get opened => _opened.stream;

  @override
  Stream<Map<String, dynamic>> watch(String destination) =>
      _destinations.putIfAbsent(destination, StreamController<Map<String, dynamic>>.broadcast).stream;

  @override
  void connect() {
    if (_client != null) return;
    _client = StompClient(
      config: StompConfig(
        url: _url,
        reconnectDelay: Realtime.reconnectDelay,
        heartbeatIncoming: Realtime.heartbeat,
        heartbeatOutgoing: Realtime.heartbeat,
        stompConnectHeaders: _connectHeaders,
        beforeConnect: _authorize,
        onConnect: _onConnect,
      ),
    )..activate();
  }

  @override
  void disconnect() {
    _client?.deactivate();
    _client = null;
  }

  Future<void> _authorize() async {
    final token = await _tokens.validAccessToken();
    if (token == null) {
      // Signed out ends the connection; otherwise this is a gap, and the next attempt asks for a token again.
      _connectHeaders.remove(Realtime.authorizationHeader);
      if (!_tokens.signedIn) disconnect();
      return;
    }
    _connectHeaders[Realtime.authorizationHeader] = '${Realtime.bearerPrefix}$token';
  }

  void _onConnect(StompFrame frame) {
    for (final entry in _destinations.entries) {
      _client?.subscribe(destination: entry.key, callback: (message) => _deliver(entry.value, message));
    }
    _opened.add(null);
  }

  void _deliver(StreamController<Map<String, dynamic>> controller, StompFrame message) {
    final body = message.body;
    if (body != null) controller.add(jsonDecode(body) as Map<String, dynamic>);
  }
}
