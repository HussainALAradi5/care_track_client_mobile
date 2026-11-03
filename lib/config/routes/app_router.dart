import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../screens/auth/sign_in_screen.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/patient/appointments_screen.dart';
import '../../screens/patient/book_screen.dart';
import '../../screens/patient/bookings_screen.dart';
import '../../screens/patient/home_screen.dart';
import '../../widgets/layout/patient_shell.dart';
import 'router_refresh.dart';

/// Signed-out people only see sign-in; signed-in people never see it. Tabs keep their own stacks.
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
      final signedIn = auth.value != null;
      if (!signedIn) return at == RoutePaths.signIn ? null : RoutePaths.signIn;
      if (at == RoutePaths.signIn || at == RoutePaths.splash) return RoutePaths.home;
      return null;
    },
    routes: [
      GoRoute(path: RoutePaths.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: RoutePaths.signIn, builder: (_, _) => const SignInScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => PatientShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.home, builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.book, builder: (_, _) => const BookScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: RoutePaths.requests, builder: (_, _) => const BookingsScreen())]),
          StatefulShellBranch(
            routes: [GoRoute(path: RoutePaths.visits, builder: (_, _) => const AppointmentsScreen())],
          ),
        ],
      ),
    ],
  );
});
