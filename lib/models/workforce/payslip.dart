import '../../enums/workforce/payroll_run_status.dart';
import 'payslip_line.dart';

/// Server PayslipDto: one person's pay for a month at a Hospital.
class Payslip {
  const Payslip({
    required this.id,
    required this.hospitalName,
    required this.year,
    required this.month,
    required this.status,
    required this.basic,
    required this.allowances,
    required this.deductions,
    required this.adjustments,
    required this.net,
    required this.unpaidLeaveDays,
    required this.absentDays,
    required this.lines,
  });

  final String id;
  final String hospitalName;
  final int year;
  final int month;
  final PayrollRunStatus status;
  final double basic;
  final double allowances;
  final double deductions;
  final double adjustments;
  final double net;
  final int unpaidLeaveDays;
  final int absentDays;
  final List<PayslipLine> lines;

  factory Payslip.fromJson(Map<String, dynamic> json) => Payslip(
    id: json['id'] as String,
    hospitalName: json['hospitalName'] as String,
    year: (json['year'] as num).toInt(),
    month: (json['month'] as num).toInt(),
    status: PayrollRunStatus.fromWire(json['status'] as String),
    basic: (json['basic'] as num).toDouble(),
    allowances: (json['allowances'] as num).toDouble(),
    deductions: (json['deductions'] as num).toDouble(),
    adjustments: (json['adjustments'] as num).toDouble(),
    net: (json['net'] as num).toDouble(),
    unpaidLeaveDays: (json['unpaidLeaveDays'] as num).toInt(),
    absentDays: (json['absentDays'] as num).toInt(),
    lines: [for (final l in (json['lines'] as List<dynamic>? ?? const [])) PayslipLine.fromJson(l as Map<String, dynamic>)],
  );
}
