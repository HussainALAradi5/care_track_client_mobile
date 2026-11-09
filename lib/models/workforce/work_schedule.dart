/// Server WorkScheduleDto: a Hospital's working days and hours ("08:00:00").
class WorkSchedule {
  const WorkSchedule({required this.workingDays, required this.startTime, required this.endTime});

  final List<String> workingDays;
  final String startTime;
  final String endTime;

  factory WorkSchedule.fromJson(Map<String, dynamic> json) => WorkSchedule(
    workingDays: [for (final day in json['workingDays'] as List<dynamic>) day as String],
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
  );
}
