import 'package:care_track_client_mobile/validations/identity/phone.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the mobile number is optional but must be international', () {
    expect(isValidOptionalPhone('  '), isTrue);
    expect(isValidOptionalPhone('+97333123456'), isTrue);
    expect(isValidOptionalPhone('97333123456'), isFalse);
    expect(isValidOptionalPhone('+0123456789'), isFalse);
  });
}
