import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/workforce/department_tree.dart';
import '../../models/workforce/team_member.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// The people who report to the caller; empty signed out.
final myTeamProvider = FutureProvider.autoDispose<List<TeamMember>>((ref) async {
  if (ref.watch(signedInUserIdProvider) == null) return const [];
  return ref.read(teamServiceProvider).myTeam();
});

/// The departments the caller works in; empty signed out.
final myDepartmentsProvider = FutureProvider.autoDispose<List<DepartmentTree>>((ref) async {
  if (ref.watch(signedInUserIdProvider) == null) return const [];
  return ref.read(teamServiceProvider).myDepartments();
});
