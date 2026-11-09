/// Server TeamMemberDto: someone who reports to the caller, with the people who report to them.
class TeamMember {
  const TeamMember({required this.userId, required this.name, required this.reports, this.positionName, this.departmentName, this.hospitalName});

  final String userId;
  final String name;
  final String? positionName;
  final String? departmentName;
  final String? hospitalName;
  final List<TeamMember> reports;

  factory TeamMember.fromJson(Map<String, dynamic> json) => TeamMember(
    userId: json['userId'] as String,
    name: json['name'] as String,
    positionName: json['positionName'] as String?,
    departmentName: json['departmentName'] as String?,
    hospitalName: json['hospitalName'] as String?,
    reports: [for (final r in json['reports'] as List<dynamic>) TeamMember.fromJson(r as Map<String, dynamic>)],
  );
}
