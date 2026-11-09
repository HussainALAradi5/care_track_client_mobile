import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/interfaces/files/file_access.dart';
import 'package:care_track_client_mobile/models/files/picked_attachment.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:care_track_client_mobile/controllers/auth/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:typed_data';

import 'chat_harness.dart';

/// No device files in tests: returns [picked] and records what was saved.
class FakeFiles implements FileAccess {
  FakeFiles({this.picked = const []});

  final List<PickedAttachment> picked;
  final saved = <String, Uint8List>{};

  @override
  Future<List<PickedAttachment>> pickAttachments(List<String> extensions) async => picked;

  @override
  Future<bool> save(String fileName, Uint8List bytes) async {
    saved[fileName] = bytes;
    return true;
  }
}

/// A chat screen with the fake server, the fake live channel and fake device files.
Future<({FakeServer server, RecordingChannel channel})> pumpChat(
  WidgetTester tester,
  Widget screen,
  Respond respond, {
  FakeFiles? files,
  bool channelUp = false,
}) async {
  final server = FakeServer(respond);
  final channel = RecordingChannel(up: channelUp);
  final dio = Dio(BaseOptions(baseUrl: 'http://test/api'))..httpClientAdapter = server;
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dio)),
        realtimeChannelProvider.overrideWithValue(channel),
        authControllerProvider.overrideWith(SwitchableAuth.new),
        fileAccessProvider.overrideWithValue(files ?? FakeFiles()),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: screen),
    ),
  );
  await tester.pumpAndSettle();
  return (server: server, channel: channel);
}
