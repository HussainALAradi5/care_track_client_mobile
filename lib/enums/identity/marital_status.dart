/// Server MaritalStatus.
enum MaritalStatus {
  single('SINGLE'),
  married('MARRIED');

  const MaritalStatus(this.wire);
  final String wire;
}
