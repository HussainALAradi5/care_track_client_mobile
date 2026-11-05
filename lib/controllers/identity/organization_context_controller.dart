import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constants.dart';
import '../../models/identity/organization_context.dart';
import '../../models/identity/staff_organization.dart';
import '../auth/auth_controller.dart';
import '../core/service_providers.dart';

/// The accountant's Organizations with their permission codes, and the selected one, remembered between launches.
/// Other accounts get an empty context without a call.
class OrganizationContextController extends AsyncNotifier<OrganizationContext> {
  @override
  Future<OrganizationContext> build() async {
    final user = await ref.watch(authControllerProvider.future);
    if (user == null || !user.userType.isAccountant) {
      return const OrganizationContext(organizations: [], selectedId: null);
    }
    final organizations = await ref.read(staffOrganizationServiceProvider).myOrganizations();
    final stored = ref.read(sharedPreferencesProvider).getString(AppConstants.staffOrganizationKey);
    return OrganizationContext(organizations: organizations, selectedId: stored);
  }

  Future<void> select(String organizationId) async {
    final current = state.value;
    if (current == null || current.selectedId == organizationId) return;
    state = AsyncData(OrganizationContext(organizations: current.organizations, selectedId: organizationId));
    await ref.read(sharedPreferencesProvider).setString(AppConstants.staffOrganizationKey, organizationId);
  }
}

final organizationContextProvider = AsyncNotifierProvider<OrganizationContextController, OrganizationContext>(
  OrganizationContextController.new,
);

/// The Organization the books screens work in (null while loading or without an Organization-wide role).
final selectedOrganizationProvider = Provider<StaffOrganization?>(
  (ref) => ref.watch(organizationContextProvider).value?.organization,
);
