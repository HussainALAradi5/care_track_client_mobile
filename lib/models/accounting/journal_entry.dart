import 'journal_line.dart';

/// Server JournalEntryDto; lines are empty in lists.
class JournalEntry {
  const JournalEntry({
    required this.id,
    required this.entryNumber,
    required this.entryDate,
    required this.periodName,
    required this.type,
    required this.status,
    required this.description,
    required this.totalAmount,
    required this.lines,
  });

  final String id;
  final String? entryNumber;
  final String entryDate;
  final String periodName;
  final String type;
  final String status;
  final String description;
  final double totalAmount;
  final List<JournalLine> lines;

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'] as String,
    entryNumber: json['entryNumber'] as String?,
    entryDate: json['entryDate'] as String,
    periodName: json['periodName'] as String,
    type: json['type'] as String,
    status: json['status'] as String,
    description: json['description'] as String,
    totalAmount: (json['totalAmount'] as num).toDouble(),
    lines: (json['lines'] as List<dynamic>).map((e) => JournalLine.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
