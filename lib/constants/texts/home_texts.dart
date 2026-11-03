class HomeTexts {
  const HomeTexts._();

  static String greeting(String name) => name.isEmpty ? 'Hello' : 'Hello, $name';
  static const subtitle = 'Here is where your care stands today.';
  static const openRequests = 'Waiting';
  static const upcoming = 'Upcoming';
  static const completed = 'Completed';
  static const nextVisit = 'Your next visit';
  static const noNextVisit = 'No visit booked';
  static const noNextVisitHint = 'Request a time with your care team and it will appear here once confirmed.';
  static const journey = 'Visit journey';
}
