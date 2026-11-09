import 'dart:convert';
import 'dart:typed_data';

import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/controllers/core/service_providers.dart';
import 'package:care_track_client_mobile/controllers/identity/staff_context_controller.dart';
import 'package:care_track_client_mobile/interfaces/auth/token_source.dart';
import 'package:care_track_client_mobile/models/identity/staff_context.dart';
import 'package:care_track_client_mobile/models/identity/staff_hospital.dart';
import 'package:care_track_client_mobile/services/api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// An error answer from the fake server.
class Failure {
  const Failure(this.status, this.code);

  final int status;
  final String code;
}

/// Answers every call from [respond]; a [Failure] becomes an ApiError body with its status.
class FakeServer implements HttpClientAdapter {
  FakeServer(this.respond);

  final Object? Function(RequestOptions request) respond;
  final requests = <RequestOptions>[];

  RequestOptions lastTo(String path) => requests.lastWhere((r) => r.path == path);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final answer = respond(options);
    final failure = answer is Failure ? answer : null;
    if (answer is Uint8List) return ResponseBody.fromBytes(answer, 200);
    return ResponseBody.fromString(
      jsonEncode(failure == null ? answer : {'code': failure.code, 'message': failure.code}),
      failure?.status ?? 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class FakeTokens implements TokenSource {
  @override
  bool get signedIn => true;

  @override
  Future<String?> validAccessToken() async => 'token';

  @override
  Future<void> handleUnauthorized() async {}
}

Map<String, dynamic> pageOf(List<Object?> items, {bool hasNext = false}) => {
  'items': items,
  'page': 0,
  'pageSize': 20,
  'totalItems': items.length,
  'totalPages': 1,
  'hasNext': hasNext,
  'correlationId': 'c',
};

StaffHospital staffHospital(Set<String> permissions) => StaffHospital(
  hospitalId: 'h1',
  organizationId: 'o1',
  code: 'H1',
  name: 'Dev Hospital',
  administrator: false,
  permissions: permissions,
);

/// A staff member at Dev Hospital holding [permissions].
class FixedStaff extends StaffContextController {
  FixedStaff(this.permissions);

  final Set<String> permissions;

  @override
  Future<StaffContext> build() async => StaffContext(hospitals: [staffHospital(permissions)], selectedId: 'h1');
}

Dio dioFor(FakeServer server) => Dio(BaseOptions(baseUrl: 'http://test/api'))..httpClientAdapter = server;

/// Room for a whole form, so lists build every row.
void useTallScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(1000, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<FakeServer> pumpScreen(
  WidgetTester tester,
  Widget screen,
  Object? Function(RequestOptions request) respond, {
  Set<String> permissions = const {},
  List<Override> overrides = const [],
  Map<String, Object> preferences = const {},
}) async {
  SharedPreferences.setMockInitialValues(preferences);
  final prefs = await SharedPreferences.getInstance();
  final server = FakeServer(respond);
  useTallScreen(tester);
  await tester.pumpWidget(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        apiClientProvider.overrideWithValue(ApiClient(FakeTokens(), dio: dioFor(server))),
        staffContextProvider.overrideWith(() => FixedStaff(permissions)),
        ...overrides,
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: screen),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return server;
}
