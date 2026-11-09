import '../../enums/ui/picker_style.dart';

/// Text of the date and time pickers and of the Picker style setting.
class PickerTexts {
  const PickerTexts._();

  static const done = 'Done';
  static const cancel = 'Cancel';
  static const previousMonth = 'Previous month';
  static const nextMonth = 'Next month';
  static const pickerStyle = 'Picker style';
  static const pickerStyleHint = 'How date and time pickers look for you, on every device you sign in on.';
  static const saved = 'Picker style saved.';
  static const deviceDefault = 'Device default';
  static const deviceDefaultHint = 'Follow this phone';

  static String label(PickerStyle style) => switch (style) {
    PickerStyle.iphone => 'iPhone',
    PickerStyle.android => 'Android',
    PickerStyle.smooth => 'Smooth',
  };

  static String hint(PickerStyle style) => switch (style) {
    PickerStyle.iphone => 'Scrolling wheels',
    PickerStyle.android => 'Material calendar and clock',
    PickerStyle.smooth => 'CareTrack\'s animated calendar',
  };
}
