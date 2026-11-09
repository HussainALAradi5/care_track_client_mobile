/// Server DepartmentMemberDto: a colleague in a department.
class DepartmentMember {
  const DepartmentMember({required this.userId, required this.name, required this.primary, required this.me, this.positionName});

  final String userId;
  final String name;
  final String? positionName;
  final bool primary;
  final bool me;

  factory DepartmentMember.fromJson(Map<String, dynamic> json) => DepartmentMember(
    userId: json['userId'] as String,
    name: json['name'] as String,
    positionName: json['positionName'] as String?,
    primary: json['primary'] as bool,
    me: json['me'] as bool,
  );
}
