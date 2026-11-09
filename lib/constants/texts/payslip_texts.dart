/// Text of My payslips.
class PayslipTexts {
  const PayslipTexts._();

  static const nav = 'Payslips';
  static const title = 'My payslips';
  static const subtitle = 'Your pay each month, once HR approves it.';
  static const emptyTitle = 'No payslips yet';
  static const emptyHint = "They appear here after HR approves a month's payroll.";
  static const net = 'Net pay';
  static const basic = 'Basic';
  static const allowances = 'Allowances';
  static const deductions = 'Deductions';
  static const adjustments = 'Adjustments';
  static const lines = 'Details';
  static String days(int days) => days == 1 ? '1 day' : '$days days';
  static String unpaidLeave(int days) => 'Unpaid leave: ${PayslipTexts.days(days)}';
  static String absent(int days) => 'Absent: ${PayslipTexts.days(days)}';
}
