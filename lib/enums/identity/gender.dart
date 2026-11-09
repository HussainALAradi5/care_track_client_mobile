/// Server Gender.
enum Gender {
  female('FEMALE'),
  male('MALE');

  const Gender(this.wire);
  final String wire;
}
