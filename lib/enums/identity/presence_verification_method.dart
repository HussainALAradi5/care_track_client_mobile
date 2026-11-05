/// Mirrors the server's PresenceVerificationMethod: how the desk checked the patient's identity.
enum PresenceVerificationMethod {
  idCard('ID_CARD'),
  passport('PASSPORT'),
  hospitalRecord('HOSPITAL_RECORD');

  const PresenceVerificationMethod(this.wire);
  final String wire;
}
