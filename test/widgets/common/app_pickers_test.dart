import 'package:care_track_client_mobile/controllers/ui/picker_style_controller.dart';
import 'package:care_track_client_mobile/enums/ui/picker_style.dart';
import 'package:care_track_client_mobile/widgets/common/pickers/app_pickers.dart';
import 'package:care_track_client_mobile/widgets/common/pickers/smooth_calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _first = DateTime(2026, 11, 1);
final _last = DateTime(2026, 12, 31);
final _initial = DateTime(2026, 11, 10);

Future<void> _open(
  WidgetTester tester,
  PickerStyle? chosen,
  TargetPlatform platform,
  Future<Object?> Function(BuildContext) open,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [chosenPickerStyleProvider.overrideWithValue(chosen)],
      child: MaterialApp(
        theme: ThemeData(platform: platform),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(onPressed: () => open(context), child: const Text('open')),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<Object?> _date(BuildContext context) =>
    AppPickers.date(context, initialDate: _initial, firstDate: _first, lastDate: _last);

Future<Object?> _time(BuildContext context) =>
    AppPickers.time(context, initialTime: const TimeOfDay(hour: 8, minute: 0));

Future<Object?> _range(BuildContext context) => AppPickers.dateRange(context, firstDate: _first, lastDate: _last);

void main() {
  testWidgets('no choice on Android opens the Material calendar', (tester) async {
    await _open(tester, null, TargetPlatform.android, _date);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('no choice on iOS opens the wheels', (tester) async {
    await _open(tester, null, TargetPlatform.iOS, _date);
    expect(find.byType(CupertinoDatePicker), findsOneWidget);
    expect(find.byType(DatePickerDialog), findsNothing);
  });

  testWidgets('the person\'s choice beats the platform', (tester) async {
    await _open(tester, PickerStyle.android, TargetPlatform.iOS, _date);
    expect(find.byType(DatePickerDialog), findsOneWidget);
  });

  testWidgets('Smooth opens the animated calendar', (tester) async {
    await _open(tester, PickerStyle.smooth, TargetPlatform.android, _date);
    expect(find.byType(SmoothCalendar), findsOneWidget);
    expect(find.byType(DatePickerDialog), findsNothing);
  });

  testWidgets('a time picker opens in the chosen look', (tester) async {
    await _open(tester, PickerStyle.android, TargetPlatform.iOS, _time);
    expect(find.byType(TimePickerDialog), findsOneWidget);
  });

  testWidgets('the wheels show 24-hour time', (tester) async {
    await _open(tester, PickerStyle.iphone, TargetPlatform.android, _time);
    final wheels = tester.widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker));
    expect(wheels.use24hFormat, isTrue);
    expect(wheels.mode, CupertinoDatePickerMode.time);
  });

  testWidgets('Smooth range closes on the second day and keeps its order', (tester) async {
    late DateTimeRange? picked;
    await _open(tester, PickerStyle.smooth, TargetPlatform.android, (context) async {
      picked = await AppPickers.dateRange(context, firstDate: _first, lastDate: _last);
      return picked;
    });
    await tester.tap(find.text('10').first);
    await tester.pumpAndSettle();
    expect(find.byType(SmoothCalendar), findsOneWidget);
    await tester.tap(find.text('12').first);
    await tester.pumpAndSettle();
    expect(find.byType(SmoothCalendar), findsNothing);
    expect(picked, DateTimeRange(start: DateTime(2026, 11, 10), end: DateTime(2026, 11, 12)));
  });

  testWidgets('iPhone range opens two-edged wheels', (tester) async {
    await _open(tester, PickerStyle.iphone, TargetPlatform.android, _range);
    expect(find.byType(CupertinoDatePicker), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(find.text('End'), findsOneWidget);
  });

  testWidgets('Android range opens the Material range picker', (tester) async {
    await _open(tester, PickerStyle.android, TargetPlatform.iOS, _range);
    expect(find.byType(DateRangePickerDialog), findsOneWidget);
  });
}
