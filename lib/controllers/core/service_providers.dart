import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/accounting/accounting_service.dart';
import '../../services/facilities/hospital_service.dart';
import '../../services/facilities/public_catalog_service.dart';
import '../../services/identity/sign_up_service.dart';
import '../../services/api/api_client.dart';
import '../../services/auth/auth_service.dart';
import '../../services/auth/token_storage.dart';
import '../../services/care/appointment_service.dart';
import '../../services/care/booking_service.dart';
import '../../services/care/care_team_service.dart';
import '../../services/identity/enrollment_service.dart';
import '../../services/identity/session_service.dart';
import '../../services/documents/written_document_service.dart';
import '../../services/identity/staff_hospital_service.dart';
import '../../services/identity/staff_organization_service.dart';
import '../../services/workforce/shift_service.dart';
import '../../services/workforce/staff_request_service.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/chat/chat_service.dart';
import '../../services/realtime/stomp_realtime_channel.dart';
import '../../config/app_config.dart';
import '../../interfaces/realtime/realtime_channel.dart';

/// Loaded in main() before the app starts, then overridden in the ProviderScope.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('Override sharedPreferencesProvider in main()'),
);

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(const FlutterAppAuth(), TokenStorage(const FlutterSecureStorage())),
);

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient(ref.watch(authServiceProvider)));

final sessionServiceProvider = Provider((ref) => SessionService(ref.watch(apiClientProvider)));
final signUpServiceProvider = Provider((ref) => SignUpService(ref.watch(apiClientProvider)));
final publicCatalogServiceProvider = Provider((ref) => PublicCatalogService(ref.watch(apiClientProvider)));
final hospitalServiceProvider = Provider((ref) => HospitalService(ref.watch(apiClientProvider)));
final enrollmentServiceProvider = Provider((ref) => EnrollmentService(ref.watch(apiClientProvider)));
final careTeamServiceProvider = Provider((ref) => CareTeamService(ref.watch(apiClientProvider)));
final bookingServiceProvider = Provider((ref) => BookingService(ref.watch(apiClientProvider)));
final appointmentServiceProvider = Provider((ref) => AppointmentService(ref.watch(apiClientProvider)));
final staffHospitalServiceProvider = Provider((ref) => StaffHospitalService(ref.watch(apiClientProvider)));
final shiftServiceProvider = Provider((ref) => ShiftService(ref.watch(apiClientProvider)));
final staffRequestServiceProvider = Provider((ref) => StaffRequestService(ref.watch(apiClientProvider)));
final notificationServiceProvider = Provider((ref) => NotificationService(ref.watch(apiClientProvider)));
final chatServiceProvider = Provider((ref) => ChatService(ref.watch(apiClientProvider)));

final realtimeChannelProvider = Provider<RealtimeChannel>(
  (ref) => StompRealtimeChannel(ref.watch(authServiceProvider), AppConfig.realtimeUrl),
);
final staffOrganizationServiceProvider = Provider((ref) => StaffOrganizationService(ref.watch(apiClientProvider)));
final accountingServiceProvider = Provider((ref) => AccountingService(ref.watch(apiClientProvider)));
final writtenDocumentServiceProvider = Provider((ref) => WrittenDocumentService(ref.watch(apiClientProvider)));
