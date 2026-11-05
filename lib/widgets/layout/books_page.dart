import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/accounting_texts.dart';
import '../../controllers/identity/organization_context_controller.dart';
import '../common/feedback/async_body.dart';
import '../common/feedback/empty_state.dart';
import 'page_heading.dart';

/// Scrollable accountant screen with pull-to-refresh and a heading. Shows "no organization" without one and a
/// locked state when the selected Organization does not grant [permission].
class BooksPage extends ConsumerWidget {
  const BooksPage({
    super.key,
    required this.title,
    required this.permission,
    required this.onRefresh,
    required this.children,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String permission;
  final Future<void> Function() onRefresh;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizations = ref.watch(organizationContextProvider);
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(organizationContextProvider);
        await onRefresh();
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          PageHeading(title: title, subtitle: subtitle),
          const SizedBox(height: 16),
          AsyncBody(
            value: organizations,
            onRetry: () => ref.invalidate(organizationContextProvider),
            data: (value) {
              if (value.organization == null) {
                return const EmptyState(
                  icon: Icons.domain_disabled_rounded,
                  title: AccountingTexts.noOrganization,
                  hint: AccountingTexts.noOrganizationHint,
                );
              }
              if (!value.can(permission)) {
                return const EmptyState(
                  icon: Icons.lock_rounded,
                  title: AccountingTexts.lockedTitle,
                  hint: AccountingTexts.lockedHint,
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
