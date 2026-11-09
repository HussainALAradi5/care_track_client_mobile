/// Text of the Work / My care switch and of registering at a hospital.
class CareModeTexts {
  const CareModeTexts._();

  static const label = 'Show';
  static const work = 'Work';
  static const care = 'My care';
  static const register = 'Register as a patient here';
  static const registered = 'Registered here';
  static String done(String hospital) => 'You are registered as a patient at $hospital.';
  static const findHospitals = 'Find a hospital';
  static const backToApp = 'Back to CareTrack';
  static const hospitals = 'Hospitals near you';
  static const noResidence = 'We do not know where you live yet';
  static const noResidenceHint =
      'Use Find a hospital to search every hospital by country and city, and register there.';
}
