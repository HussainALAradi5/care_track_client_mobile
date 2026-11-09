import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every date and time goes through AppPickers: no screen opens a platform picker itself', () {
    final offenders = <String>[];
    final pickers = RegExp(r'showDatePicker\(|showTimePicker\(|showDateRangePicker\(|CupertinoDatePicker\(');
    for (final file in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart') || file.path.contains('pickers')) continue;
      if (pickers.hasMatch(file.readAsStringSync())) offenders.add(file.path);
    }
    expect(offenders, isEmpty);
  });
}
