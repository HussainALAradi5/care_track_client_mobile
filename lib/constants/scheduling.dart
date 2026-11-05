/// Client copies of the server's scheduling rules (SchedulingRules.java); the server stays the authority.
class Scheduling {
  const Scheduling._();

  static const maxConsultationMinutes = 120;
  static const durationOptions = [15, 30, 45, 60];
  static const defaultDurationMinutes = 30;
  static const slotStepMinutes = 15;
  static const dayStartHour = 8;
  static const dayEndHour = 20;
  static const bookableDays = 14;
  static const reasonMaxLength = 500;
  static const urgentFraction = 0.25;
}
