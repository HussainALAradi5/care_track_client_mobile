/// App-wide limits and keys.
class AppConstants {
  const AppConstants._();

  static const appName = 'CareTrack';
  static const tagline = 'Your care, one calm timeline.';
  static const pageSize = 20;
  static const searchPageSize = 20;
  static const maxEnrollments = 50;
  static const maxCareTeam = 50;
  static const maxStaffHospitals = 50;
  static const clockTick = Duration(seconds: 30);
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 30);
  static const minimumSpinner = Duration(milliseconds: 300);
  static const doneTickVisible = Duration(milliseconds: 1200);

  static const themeModeKey = 'caretrack.themeMode';
  static const hospitalKey = 'caretrack.hospital';
  static const staffHospitalKey = 'caretrack.staffHospital';
  static const staffOrganizationKey = 'caretrack.staffOrganization';
  static const careModeKey = 'caretrack.careMode';
  static const tokenKey = 'caretrack.tokens';
}
