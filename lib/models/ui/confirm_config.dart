/// Text of a confirmation or reason sheet.
class ConfirmConfig {
  const ConfirmConfig({required this.title, required this.message, required this.confirmLabel, this.danger = false});

  final String title;
  final String message;
  final String confirmLabel;
  final bool danger;
}
