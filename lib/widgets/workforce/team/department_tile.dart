import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/team_texts.dart';
import '../../../models/workforce/department_tree.dart';

/// A department with its people and the departments under it.
class DepartmentTile extends StatelessWidget {
  const DepartmentTile({super.key, required this.department});

  final DepartmentTree department;

  @override
  Widget build(BuildContext context) {
    final d = department;
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(d.name),
      subtitle: Text([?d.hospitalName, TeamTexts.people(d.members.length)].join(' · ')),
      childrenPadding: const EdgeInsets.only(left: AppSpacing.medium),
      children: [
        if (d.members.isEmpty) const ListTile(title: Text(TeamTexts.noOne)),
        for (final m in d.members)
          ListTile(
            dense: true,
            title: Text(m.name),
            subtitle: m.positionName == null ? null : Text(m.positionName!),
            trailing: Text([if (m.me) TeamTexts.you, if (m.primary) TeamTexts.main].join(' · ')),
          ),
        for (final child in d.children) DepartmentTile(department: child),
      ],
    );
  }
}
