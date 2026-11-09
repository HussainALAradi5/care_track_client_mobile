/// The server's limits on a leave request (LeaveRules).
class LeaveRules {
  const LeaveRules._();

  static const maxDays = 90;
  static const daysBack = 30;
  static const noteMax = 500;
  static const decideQueueSize = 50;
  static const lowBalanceDays = 3;
  static const maxYearsAhead = 2;
}
