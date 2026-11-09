import 'package:care_track_client_mobile/enums/identity/user_type.dart';
import 'package:care_track_client_mobile/enums/ui/picker_style.dart';
import 'package:care_track_client_mobile/models/identity/session_user.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> session(Object? pickerStyle) => {
  'userId': 'u1',
  'username': 'ann',
  'name': 'Ann Lee',
  'userType': 'NURSE',
  'pickerStyle': pickerStyle,
};

void main() {
  test('parses the picker look', () {
    final user = SessionUser.fromJson(session('SMOOTH'));
    expect(user.pickerStyle, PickerStyle.smooth);
    expect(user.userType, UserType.nurse);
  });

  test('null means the device default', () {
    expect(SessionUser.fromJson(session(null)).pickerStyle, isNull);
    expect(SessionUser.fromJson({'userId': 'u', 'name': 'A', 'userType': 'NURSE'}).pickerStyle, isNull);
  });

  test('an unknown look falls back to the device default', () {
    expect(SessionUser.fromJson(session('WINDOWS')).pickerStyle, isNull);
  });

  test('copyWith keeps everything but the look', () {
    final user = SessionUser.fromJson(session('SMOOTH')).copyWith(pickerStyle: null);
    expect(user.pickerStyle, isNull);
    expect(user.name, 'Ann Lee');
  });

  test('every look keeps its wire name', () {
    expect(PickerStyle.values.map((s) => s.wire), ['IPHONE', 'ANDROID', 'SMOOTH']);
  });
}
