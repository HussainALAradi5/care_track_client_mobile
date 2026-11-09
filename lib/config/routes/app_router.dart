import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/auth/pending_sign_up_controller.dart';
import '../../controllers/identity/care_mode_controller.dart';
import '../../screens/facilities/find_hospital_screen.dart';
import '../../screens/facilities/hospitals_near_screen.dart';
import '../../screens/identity/profile_screen.dart';
import '../../screens/notifications/notifications_screen.dart';
import '../../screens/chat/chat_list_screen.dart';
import '../../screens/chat/chat_thread_screen.dart';
import '../../screens/accounting/books_screen.dart';
import '../../screens/accounting/journal_screen.dart';
import '../../screens/accounting/reports_screen.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/sign_up_screen.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/patient/appointments_screen.dart';
import '../../screens/patient/book_screen.dart';
import '../../screens/patient/documents_screen.dart';
import '../../screens/patient/bookings_screen.dart';
import '../../screens/patient/home_screen.dart';
import '../../screens/staff/attendance_screen.dart';
import '../../screens/staff/desk_screen.dart';
import '../../screens/staff/leave_requests_screen.dart';
import '../../screens/staff/leave_screen.dart';
import '../../screens/staff/department_screen.dart';
import '../../screens/staff/my_requests_screen.dart';
import '../../screens/staff/payslip_detail_screen.dart';
import '../../screens/staff/payslips_screen.dart';
import '../../screens/staff/staff_requests_screen.dart';
import '../../screens/staff/team_screen.dart';
import '../../screens/staff/queue_screen.dart';
import '../../screens/staff/shifts_screen.dart';
import '../../screens/staff/staff_overview_screen.dart';
import '../../screens/staff/visits_screen.dart';
import '../../widgets/layout/books_shell.dart';
import '../../widgets/layout/patient_shell.dart';
import '../../widgets/layout/staff_shell.dart';
import 'router_refresh.dart';

/// Signed-out people only see sign-in, or the Finish signing up form when their sign-in has no account yet;
/// signed-in people never see either. Patients get the patient tabs (each with its
/// own stack), accountants the books screens, and every other account type the staff screens. Each screen checks
/// its own permission.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh(ref);
  ref.onDispose(refresh.dispose);
  return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final at = state.matchedLocation;
      if (auth.isLoading && !auth.hasValue) return RoutePaths.splash;
      final user = auth.value;
      // The hospital search is public and opens over any side.
      if (at == RoutePaths.find) return null;
      if (user == null) {
        final allowed = ref.read(pendingSignUpProvider) ? RoutePaths.signUp : RoutePaths.signIn;
        return at == allowed ? null : allowed;
      }
      // The inbox and the person's own account open over any side of the app.
      if (at == RoutePaths.notifications ||
          at == RoutePaths.profile ||
          at == RoutePaths.hospitals ||
          at.startsWith(RoutePaths.chat)) {
        return null;
      }
      final onBooksRoute = at.startsWith(RoutePaths.books);
      final onStaffRoute = at.startsWith(RoutePaths.staff);
      // Patients, and staff on "My care", are on the patient side.
      if (!user.userType.isStaff || ref.read(careModeProvider)) {
        // A staff member on My care may still act on a sick note in My leave.
        if (user.userType.isStaff && at == RoutePaths.staffLeave) return null;
        final leaves =
            onStaffRoute || onBooksRoute || at == RoutePaths.signIn || at == RoutePaths.signUp || at == RoutePaths.splash;
        return leaves ? RoutePaths.home : null;
      }
      if (user.userType.isAccountant) return onBooksRoute ? null : RoutePaths.books;
      return onStaffRoute ? null : RoutePaths.staff;
    },
    routes: [
      GoRoute(path: RoutePaths.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: RoutePaths.signIn, builder: (_, _) => const SignInScreen()),
      GoRoute(path: RoutePaths.signUp, builder: (_, _) => const SignUpScreen()),
      GoRoute(path: RoutePaths.find, builder: (_, _) => const FindHospitalScreen()),
      GoRoute(path: RoutePaths.hospitals, builder: (_, _) => const HospitalsNearScreen()),
      GoRoute(path: RoutePaths.profile, builder: (_, _) => const ProfileScreen()),
      GoRoute(path: RoutePaths.notifications, builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: RoutePaths.chat, builder: (_, _) => const ChatListScreen()),
      GoRoute(
        path: '${RoutePaths.chat}/:conversationId',
        builder: (_, state) => ChatThreadScreen(conversationId: state.pathParameters['conversationId']!),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => PatientShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.home, builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.book, builder: (_, _) => const BookScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.requests, builder: (_, _) => const BookingsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.visits, builder: (_, _) => const AppointmentsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.documents, builder: (_, _) => const DocumentsScreen())],
          ),
        ],
      ),
      ShellRoute(
        builder: (_, state, child) => StaffShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: RoutePaths.staff, builder: (_, _) => const StaffOverviewScreen()),
          GoRoute(path: RoutePaths.staffQueue, builder: (_, _) => const QueueScreen()),
          GoRoute(path: RoutePaths.staffDesk, builder: (_, _) => const DeskScreen()),
          GoRoute(path: RoutePaths.staffShifts, builder: (_, _) => const ShiftsScreen()),
          GoRoute(path: RoutePaths.staffVisits, builder: (_, _) => const VisitsScreen()),
          GoRoute(path: RoutePaths.staffRequests, builder: (_, _) => const MyRequestsScreen()),
          GoRoute(
            path: RoutePaths.staffLeave,
            builder: (_, state) => LeaveScreen(sickNoteId: state.uri.queryParameters['sickNote']),
          ),
          GoRoute(path: RoutePaths.staffLeaveRequests, builder: (_, _) => const LeaveRequestsScreen()),
          GoRoute(path: RoutePaths.staffHrRequests, builder: (_, _) => const StaffRequestsScreen()),
          GoRoute(path: RoutePaths.staffAttendance, builder: (_, _) => const AttendanceScreen()),
          GoRoute(path: RoutePaths.staffPayslips, builder: (_, _) => const PayslipsScreen()),
          GoRoute(
            path: '${RoutePaths.staffPayslips}/:payslipId',
            builder: (_, state) => PayslipDetailScreen(payslipId: state.pathParameters['payslipId']!),
          ),
          GoRoute(path: RoutePaths.staffTeam, builder: (_, _) => const TeamScreen()),
          GoRoute(path: RoutePaths.staffDepartment, builder: (_, _) => const DepartmentScreen()),
        ],
      ),
      ShellRoute(
        builder: (_, state, child) => BooksShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(path: RoutePaths.books, builder: (_, _) => const BooksScreen()),
          GoRoute(path: RoutePaths.booksJournal, builder: (_, _) => const JournalScreen()),
          GoRoute(path: RoutePaths.booksReports, builder: (_, _) => const ReportsScreen()),
        ],
      ),
    ],
  );
});
