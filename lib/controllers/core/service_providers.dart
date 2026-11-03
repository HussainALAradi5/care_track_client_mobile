import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api/api_client.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/token_storage.dart';
import '../../services/care/appointment_service.dart';
import '../../services/care/booking_service.dart';
import '../../services/care/care_team_service.dart';
import '../../services/identity/enrollment_service.dart';
import '../../services/identity/session_service.dart';

/// Loaded in main() before the app starts, then overridden in the ProviderScope.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override sharedPreferencesProvider in main()'),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(const FlutterAppAuth(), TokenStorage(const FlutterSecureStorage())),
);

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(authServiceProvider)));

final sessionServiceProvider = Provider((ref) => SessionService(ref.watch(apiClientProvider)));
final enrollmentServiceProvider = Provider((ref) => EnrollmentService(ref.watch(apiClientProvider)));
final careTeamServiceProvider = Provider((ref) => CareTeamService(ref.watch(apiClientProvider)));
final bookingServiceProvider = Provider((ref) => BookingService(ref.watch(apiClientProvider)));
final appointmentServiceProvider = Provider((ref) => AppointmentService(ref.watch(apiClientProvider)));
