import 'package:care_track_client_mobile/utilities/accounting/money_format.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats amounts and the server text with three decimals', () {
    expect(formatMoney(1250.5), '1,250.500');
    expect(formatMoney('250.000'), '250.000');
    expect(formatMoney(''), '');
    expect(formatMoney(null), '');
  });
}
