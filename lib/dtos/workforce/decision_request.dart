/// Approves or rejects a waiting request (LeaveDecisionRequest, StaffRequestDecisionRequest); a rejection needs a note.
class DecisionRequest {
  const DecisionRequest({required this.approve, required this.expectedVersion, this.note});

  final bool approve;
  final int expectedVersion;
  final String? note;

  Map<String, dynamic> toJson() => {'approve': approve, 'note': note, 'expectedVersion': expectedVersion};
}
