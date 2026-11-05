class BookingTexts {
  const BookingTexts._();

  static const wizardTitle = 'Book a visit';
  static const stepHospital = 'Hospital';
  static const stepClinician = 'Doctor';
  static const stepTime = 'Time';
  static const stepReview = 'Review';
  static const steps = [stepHospital, stepClinician, stepTime, stepReview];
  static const noHospitals = 'You are not enrolled at a hospital yet.';
  static const noHospitalsHint = 'Ask the hospital reception to enrol you, then come back here.';
  static const noCareTeam = 'No doctor is assigned to you here yet.';
  static const noCareTeamHint = 'Your hospital assigns a care team before you can book.';
  static const duration = 'Length';
  static String minutes(int m) => '$m min';
  static const noSlots = 'No free times left on this day.';
  static const reviewNote = 'This is a request. The hospital confirms it if the doctor is on shift.';
  static const submit = 'Send request';
  static const submitted = 'Request sent. You will see it here once staff decide.';
  static const listTitle = 'My requests';
  static const emptyList = 'No booking requests yet.';
  static const emptyListHint = 'Book a visit and it will show up here.';
  static const bookNow = 'Book a visit';
  static const withdraw = 'Withdraw';
  static const cancelTitle = 'Withdraw this request?';
  static const cancelBody = 'The hospital will no longer see it.';
  static const cancelled = 'Request withdrawn.';
  static const rejectedBecause = 'Reason given';
  static const back = 'Back';
  static const next = 'Continue';
}
