/// Text of the hospital search screens.
class HospitalTexts {
  const HospitalTexts._();

  static const nearTitle = 'Hospitals near you';
  static const nearSubtitle =
      'Hospitals and clinics in your city first, then those serving it. See who is open now before you go.';
  static const filterLabel = 'Opening';
  static const all = 'All';
  static String closesAt(String time) => 'Closes at $time';
  static String opensAt(String when) => 'Opens $when';
  static const today = 'today';
  static const emptyTitle = 'No hospital matches';
  static const emptyHint = 'Try another filter, or ask your hospital to record where you live.';
  static const findTitle = 'Find a hospital';
  static const findSubtitle =
      'Choose a country and a city to see the hospitals and clinics there, whether they are open now, and whether a visit is free.';
  static const country = 'Country';
  static const anyCountry = 'Any country';
  static const city = 'City';
  static const anyCity = 'Any city in this country';
  static const typeLabel = 'Public or private';
  static const publicAndPrivate = 'Public and private';
  static const findEmpty = 'No hospital matches these filters.';
  static const findEmptyHint = 'Try another city or turn off a filter.';
  static const signInToBook = 'Sign in to book a visit';
}
