import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/route_paths.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/auth/pending_sign_up_controller.dart';
import '../../controllers/identity/care_mode_controller.dart';

/// Where someone at [at] belongs; null keeps them there. Signed-out people only see sign-in, or the Finish signing up
/// form when their sign-in has no account yet; signed-in people never see either. Patients get the patient tabs,
/// accountants the books screens, and every other account type the staff screens. Each screen checks its own permission.
String? appRedirect(Ref ref, String at) {
  final auth = ref.read(authControllerProvider);
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
}
