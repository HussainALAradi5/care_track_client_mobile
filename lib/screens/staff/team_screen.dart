import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/texts/team_texts.dart';
import '../../controllers/workforce/team_controller.dart';
import '../../widgets/common/feedback/async_body.dart';
import '../../widgets/common/feedback/empty_state.dart';
import '../../widgets/layout/staff_page.dart';
import '../../widgets/workforce/team/team_member_tile.dart';

/// The people who report to the caller, read-only.
class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => StaffPage(
    title: TeamTexts.teamTitle,
    subtitle: TeamTexts.teamSubtitle,
    onRefresh: () async => ref.refresh(myTeamProvider.future),
    children: [
      AsyncBody(
        value: ref.watch(myTeamProvider),
        onRetry: () => ref.invalidate(myTeamProvider),
        data: (team) => team.isEmpty
            ? const EmptyState(icon: Icons.groups_rounded, title: TeamTexts.teamEmpty, hint: TeamTexts.teamEmptyHint)
            : Column(children: [for (final m in team) TeamMemberTile(member: m)]),
      ),
    ],
  );
}
