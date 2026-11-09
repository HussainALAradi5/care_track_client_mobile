import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../constants/route_paths.dart';
import 'app_redirect.dart';
import 'app_routes.dart';
import 'router_refresh.dart';

/// The app's one router: its paths are [appRoutes], who may be where is [appRedirect], and auth changes re-check it.
final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = RouterRefresh(ref);
  ref.onDispose(refresh.dispose);
  return GoRouter(
    initialLocation: RoutePaths.home,
    refreshListenable: refresh,
    redirect: (_, state) => appRedirect(ref, state.matchedLocation),
    routes: appRoutes(),
  );
});
