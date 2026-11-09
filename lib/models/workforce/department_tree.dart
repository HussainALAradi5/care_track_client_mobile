import 'department_member.dart';

/// Server DepartmentTreeDto: a department with its people and the departments under it, read-only.
class DepartmentTree {
  const DepartmentTree({required this.id, required this.name, required this.members, required this.children, this.hospitalName});

  final String id;
  final String name;
  final String? hospitalName;
  final List<DepartmentMember> members;
  final List<DepartmentTree> children;

  factory DepartmentTree.fromJson(Map<String, dynamic> json) => DepartmentTree(
    id: json['id'] as String,
    name: json['name'] as String,
    hospitalName: json['hospitalName'] as String?,
    members: [for (final m in json['members'] as List<dynamic>) DepartmentMember.fromJson(m as Map<String, dynamic>)],
    children: [for (final c in json['children'] as List<dynamic>) DepartmentTree.fromJson(c as Map<String, dynamic>)],
  );
}
