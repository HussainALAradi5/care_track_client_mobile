import 'package:flutter/material.dart';

import '../../../constants/texts/common_texts.dart';
import '../../../models/ui/confirm_config.dart';

/// Content of the reason sheet: title, message, a reason field and confirm / keep buttons.
class ReasonSheetBody extends StatefulWidget {
  const ReasonSheetBody({super.key, required this.config, required this.reasonLabel, required this.maxLength});

  final ConfirmConfig config;
  final String reasonLabel;
  final int maxLength;

  @override
  State<ReasonSheetBody> createState() => ReasonSheetBodyBodyState();
}

class ReasonSheetBodyBodyState extends State<ReasonSheetBody> {
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + MediaQuery.viewInsetsOf(context).bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.config.title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(widget.config.message, style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          TextField(
            controller: _reason,
            autofocus: true,
            minLines: 2,
            maxLines: 4,
            maxLength: widget.maxLength,
            decoration: InputDecoration(labelText: widget.reasonLabel),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder(
            valueListenable: _reason,
            builder: (context, value, _) => FilledButton(
              style: widget.config.danger ? FilledButton.styleFrom(backgroundColor: scheme.error) : null,
              onPressed: value.text.trim().isEmpty ? null : () => Navigator.pop(context, value.text.trim()),
              child: Text(widget.config.confirmLabel),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text(CommonTexts.keep)),
        ],
      ),
    );
  }
}
