/// Server ConversationKind: what a conversation is for.
enum ConversationKind {
  staff('STAFF', 'Colleague'),
  patientCare('PATIENT_CARE', 'Care team'),
  patientSupport('PATIENT_SUPPORT', 'Patient support');

  const ConversationKind(this.wire, this.label);
  final String wire;
  final String label;

  static ConversationKind fromWire(String value) => values.firstWhere((kind) => kind.wire == value);
}
