/// Server SickNoteSummaryDto: who issued a leave's sick note and the rest days, never its content.
class SickNoteSummary {
  const SickNoteSummary({required this.id, required this.code, required this.hospitalName, required this.doctorName});

  final String id;
  final String code;
  final String hospitalName;
  final String doctorName;

  factory SickNoteSummary.fromJson(Map<String, dynamic> json) => SickNoteSummary(
    id: json['id'] as String,
    code: json['code'] as String,
    hospitalName: json['hospitalName'] as String,
    doctorName: json['doctorName'] as String,
  );
}
