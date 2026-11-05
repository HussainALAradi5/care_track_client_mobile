import 'package:flutter/material.dart';

import '../../../models/ui/confirm_config.dart';
import 'reason_sheet_body.dart';

/// Bottom sheet that asks for a written reason; resolves to the trimmed reason, or null when kept.
Future<String?> showReasonSheet(
  BuildContext context,
  ConfirmConfig config, {
  required String reasonLabel,
  required int maxLength,
}) => showModalBottomSheet<String>(
  context: context,
  isScrollControlled: true,
  builder: (context) => ReasonSheetBody(config: config, reasonLabel: reasonLabel, maxLength: maxLength),
);
