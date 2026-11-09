import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/staff_texts.dart';
import '../../controllers/identity/staff_context_controller.dart';
import '../common/feedback/async_body.dart';
import '../common/feedback/empty_state.dart';
import 'page_heading.dart';

/// Scrollable staff screen with pull-to-refresh and a heading. Shows "you work nowhere" without a Hospital and a
/// locked state when the selected Hospital does not grant [permission], so each screen builds only its content.
class StaffPage extends ConsumerWidget {
  const StaffPage({
    super.key,
    required this.title,
    required this.onRefresh,
    required this.children,
    this.permission,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  /// Null: open to every staff member.
  final String? permission;
  final Future<void> Function() onRefresh;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(staffContextProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(staffContextProvider);
        await onRefresh();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          PageHeading(title: title, subtitle: subtitle),
          const SizedBox(height: 16),
          AsyncBody(
            value: staff,
            onRetry: () => ref.invalidate(staffContextProvider),
            data: (value) {
              if (value.hospital == null) {
                return const EmptyState(
                  icon: Icons.badge_rounded,
                  title: StaffTexts.noStaffHospital,
                  hint: StaffTexts.noStaffHospitalHint,
                );
              }
              if (permission != null && !value.can(permission!)) {
                return const EmptyState(
                  icon: Icons.lock_rounded,
                  title: StaffTexts.lockedTitle,
                  hint: StaffTexts.lockedHint,
                );
              }
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children);
            },
          ),
        ],
      ),
    );
  }
}
