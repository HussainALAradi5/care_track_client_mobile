import 'package:intl/intl.dart';

/// 'November 2026': a pay month.
String monthPeriod(int year, int month) => DateFormat('MMMM y').format(DateTime(year, month));
