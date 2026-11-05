import 'package:intl/intl.dart';

final _money = NumberFormat('#,##0.000');

/// "1,250.000" from an amount or the server's "1250.000" text (blank stays blank).
String formatMoney(Object? value) {
  if (value == null) return '';
  if (value is num) return _money.format(value);
  final text = value.toString();
  if (text.isEmpty) return '';
  final amount = double.tryParse(text);
  return amount == null ? text : _money.format(amount);
}
