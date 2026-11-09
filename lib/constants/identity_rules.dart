/// Limits mirrored from the server's SignUpRequest.
class IdentityRules {
  const IdentityRules._();

  static const addressMax = 300;
  static const firstBirthYear = 1900;
  static const defaultBirthYearsAgo = 30;
  static final phoneE164 = RegExp(r'^\+[1-9][0-9]{6,14}$');
}
