import 'package:flutter/material.dart';

import '../enums/ui/status_tone.dart';
import '../enums/workforce/payroll_run_status.dart';
import '../models/ui/status_style.dart';

/// How a payslip's run status reads and looks.
class PayrollStyles {
  const PayrollStyles._();

  static const run = <PayrollRunStatus, StatusStyle>{
    PayrollRunStatus.draft: StatusStyle(label: 'Draft', tone: StatusTone.info, icon: Icons.edit_note_rounded),
    PayrollRunStatus.approved: StatusStyle(label: 'Approved', tone: StatusTone.warning, icon: Icons.verified_rounded),
    PayrollRunStatus.paid: StatusStyle(label: 'Paid', tone: StatusTone.success, icon: Icons.paid_rounded),
  };
}
