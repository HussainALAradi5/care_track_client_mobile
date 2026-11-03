import 'package:care_track_client_mobile/config/theme/app_theme.dart';
import 'package:care_track_client_mobile/constants/status_styles.dart';
import 'package:care_track_client_mobile/controllers/ui/clock_controller.dart';
import 'package:care_track_client_mobile/enums/care/booking_status.dart';
import 'package:care_track_client_mobile/widgets/common/buttons/app_button.dart';
import 'package:care_track_client_mobile/widgets/common/progress/countdown_meter.dart';
import 'package:care_track_client_mobile/widgets/common/progress/step_progress.dart';
import 'package:care_track_client_mobile/widgets/common/status/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _host(Widget child, {DateTime? now}) => ProviderScope(
  overrides: [if (now != null) nowProvider.overrideWithValue(now)],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: Padding(padding: const EdgeInsets.all(16), child: child)),
  ),
);

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('status chip shows its label', (tester) async {
    await tester.pumpWidget(_host(StatusChip(status: StatusStyles.booking[BookingStatus.rejected]!)));
    expect(find.text('Declined'), findsOneWidget);
  });

  testWidgets('countdown meter shows time left, then the closed label', (tester) async {
    final opens = DateTime(2026, 11, 3, 8);
    final closes = DateTime(2026, 11, 3, 12);
    await tester.pumpWidget(
      _host(CountdownMeter(opensAt: opens, closesAt: closes, label: 'Free cancellation', closedLabel: 'Closed'),
          now: DateTime(2026, 11, 3, 11)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Free cancellation'), findsOneWidget);
    expect(find.text('60 min'), findsNothing);
    expect(find.text('1 h 0 min'), findsOneWidget);

    await tester.pumpWidget(
      _host(CountdownMeter(opensAt: opens, closesAt: closes, label: 'Free cancellation', closedLabel: 'Closed'),
          now: DateTime(2026, 11, 3, 13)),
    );
    await tester.pumpAndSettle();
    expect(find.text('Closed'), findsOneWidget);
  });

  testWidgets('step progress ticks finished steps', (tester) async {
    await tester.pumpWidget(_host(const StepProgress(steps: ['A', 'B', 'C'], current: 1)));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('app button runs once, shows a tick, and ignores a second tap', (tester) async {
    var calls = 0;
    await tester.pumpWidget(
      _host(AppButton(label: 'Send', onPressed: () async => calls++)),
    );
    await tester.tap(find.text('Send'));
    await tester.tap(find.text('Send'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 400));
    expect(calls, 1);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
