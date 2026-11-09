import '../../config/endpoints.dart';
import '../../models/workforce/department_tree.dart';
import '../../models/workforce/team_member.dart';
import '../api/api_client.dart';

/// The caller's reporting line and departments, read-only.
class TeamService {
  TeamService(this._api);

  final ApiClient _api;

  Future<List<TeamMember>> myTeam() async => [
    for (final m in await _api.getList(Endpoints.myTeam)) TeamMember.fromJson(m as Map<String, dynamic>),
  ];

  Future<List<DepartmentTree>> myDepartments() async => [
    for (final d in await _api.getList(Endpoints.myDepartments)) DepartmentTree.fromJson(d as Map<String, dynamic>),
  ];
}
