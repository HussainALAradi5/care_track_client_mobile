import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../controllers/ui/picker_style_controller.dart';
import '../../../enums/ui/picker_style.dart';
import '../../../utilities/ui/picker_style_resolver.dart';
import 'iphone_pickers.dart';
import 'material_pickers.dart';
import 'smooth_pickers.dart';

/// The one way screens open a date, time or date-range picker; each opens in the person's chosen look, or the
/// device's default. Times are always 24-hour. Each returns null when the person cancels.
class AppPickers {
  const AppPickers._();

  static PickerStyle styleOf(BuildContext context) => resolvePickerStyle(
    ProviderScope.containerOf(context, listen: false).read(chosenPickerStyleProvider),
    Theme.of(context).platform,
  );

  static Future<DateTime?> date(
    BuildContext context, {
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) => switch (styleOf(context)) {
    PickerStyle.iphone => showIphoneDate(context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate),
    PickerStyle.android => showAndroidDate(context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate),
    PickerStyle.smooth => showSmoothDate(context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate),
  };

  static Future<TimeOfDay?> time(BuildContext context, {required TimeOfDay initialTime}) =>
      switch (styleOf(context)) {
        PickerStyle.iphone => showIphoneTime(context, initialTime: initialTime),
        PickerStyle.android => showAndroidTime(context, initialTime: initialTime),
        PickerStyle.smooth => showSmoothTime(context, initialTime: initialTime),
      };

  static Future<DateTimeRange?> dateRange(
    BuildContext context, {
    required DateTime firstDate,
    required DateTime lastDate,
    DateTimeRange? initialRange,
  }) => switch (styleOf(context)) {
    PickerStyle.iphone => showIphoneRange(context, firstDate: firstDate, lastDate: lastDate, initialRange: initialRange),
    PickerStyle.android => showAndroidRange(context, firstDate: firstDate, lastDate: lastDate, initialRange: initialRange),
    PickerStyle.smooth => showSmoothRange(context, firstDate: firstDate, lastDate: lastDate, initialRange: initialRange),
  };
}
