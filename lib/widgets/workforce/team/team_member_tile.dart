import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/team_texts.dart';
import '../../../models/workforce/team_member.dart';
import '../../common/display/avatar.dart';

/// Someone who reports to the caller; unfolds to the people who report to them.
class TeamMemberTile extends StatelessWidget {
  const TeamMemberTile({super.key, required this.member});

  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    final detail = [?member.positionName, ?member.departmentName, ?member.hospitalName].join(' · ');
    final leading = Avatar(name: member.name);
    final subtitle = detail.isEmpty ? null : Text(detail);
    if (member.reports.isEmpty) {
      return ListTile(leading: leading, title: Text(member.name), subtitle: subtitle);
    }
    return ExpansionTile(
      leading: leading,
      title: Text('${member.name} · ${TeamTexts.reports(member.reports.length)}'),
      subtitle: subtitle,
      childrenPadding: const EdgeInsets.only(left: AppSpacing.large),
      children: [for (final report in member.reports) TeamMemberTile(member: report)],
    );
  }
}
