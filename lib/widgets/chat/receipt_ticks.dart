import 'package:flutter/material.dart';

import '../../constants/texts/chat_texts.dart';
import '../../enums/chat/receipt_state.dart';

/// The tick after one of my messages: one for sent, two for delivered, two coloured for read.
class ReceiptTicks extends StatelessWidget {
  const ReceiptTicks({super.key, required this.state});

  final ReceiptState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, label, color) = switch (state) {
      ReceiptState.sent => (Icons.check_rounded, ChatTexts.sent, scheme.onSurfaceVariant),
      ReceiptState.delivered => (Icons.done_all_rounded, ChatTexts.delivered, scheme.onSurfaceVariant),
      ReceiptState.read => (Icons.done_all_rounded, ChatTexts.read, scheme.primary),
    };
    return Icon(icon, size: 14, color: color, semanticLabel: label);
  }
}
