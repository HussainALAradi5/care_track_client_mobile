import '../documents/written_document.dart';

/// The Ask for leave form while it is filled in; [sickNote] is attached through Use for my leave.
class LeaveDraft {
  const LeaveDraft({this.leaveTypeId, this.start, this.end, this.reason = '', this.sickNote});

  final String? leaveTypeId;
  final DateTime? start;
  final DateTime? end;
  final String reason;
  final WrittenDocument? sickNote;

  LeaveDraft copyWith({String? leaveTypeId, DateTime? start, DateTime? end, String? reason}) => LeaveDraft(
    leaveTypeId: leaveTypeId ?? this.leaveTypeId,
    start: start ?? this.start,
    end: end ?? this.end,
    reason: reason ?? this.reason,
    sickNote: sickNote,
  );

  LeaveDraft withSickNote(WrittenDocument? note, {DateTime? start, DateTime? end, String? leaveTypeId}) => LeaveDraft(
    leaveTypeId: leaveTypeId ?? this.leaveTypeId,
    start: start ?? this.start,
    end: end ?? this.end,
    reason: reason,
    sickNote: note,
  );
}
