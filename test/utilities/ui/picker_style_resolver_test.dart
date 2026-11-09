import 'package:care_track_client_mobile/enums/ui/picker_style.dart';
import 'package:care_track_client_mobile/utilities/ui/picker_style_resolver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the person\'s choice wins on every platform', () {
    expect(resolvePickerStyle(PickerStyle.smooth, TargetPlatform.iOS), PickerStyle.smooth);
    expect(resolvePickerStyle(PickerStyle.iphone, TargetPlatform.android), PickerStyle.iphone);
  });

  test('with no choice, Apple devices get the wheels and others Material', () {
    expect(resolvePickerStyle(null, TargetPlatform.iOS), PickerStyle.iphone);
    expect(resolvePickerStyle(null, TargetPlatform.macOS), PickerStyle.iphone);
    expect(resolvePickerStyle(null, TargetPlatform.android), PickerStyle.android);
    expect(resolvePickerStyle(null, TargetPlatform.windows), PickerStyle.android);
  });
}
