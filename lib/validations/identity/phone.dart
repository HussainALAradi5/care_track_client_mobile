import '../../constants/identity_rules.dart';

/// An empty number is fine (it is optional); otherwise it must be in international form.
bool isValidOptionalPhone(String value) => value.trim().isEmpty || IdentityRules.phoneE164.hasMatch(value.trim());
