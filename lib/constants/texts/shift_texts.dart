/// Text of the shifts screen.
class ShiftTexts {
  const ShiftTexts._();

  static const title = 'Shifts';
  static const subtitle = "Who works when. A booking can only be confirmed inside the doctor's shift.";
  static const addTitle = 'Add a shift';
  static const clinician = 'Doctor or nurse';
  static const date = 'Date';
  static const start = 'Starts at';
  static const length = 'Length';
  static String hours(int hours) => '$hours h';
  static const add = 'Add shift';
  static const added = 'Shift added.';
  static const noClinicians = 'No doctors or nurses have a clinical role at this hospital yet.';
  static const everyone = 'Everyone';
  static const empty = 'No upcoming shifts.';
  static const emptyHint = 'Add a shift so booking requests in that time can be confirmed.';
  static const onShift = 'On shift';
  static const shiftEnded = 'Shift ended';
  static String startsIn(String label) => 'Starts in $label';
  static const remove = 'Remove';
  static const removeTitle = 'Remove this shift?';
  static const removeBody = 'Bookings in this time can no longer be confirmed for this person.';
  static const removed = 'Shift removed.';
  static const inPast = 'Choose a start time in the future.';
  static const pickClinician = 'Choose who works this shift.';
  static const preview = 'New shift';
}
