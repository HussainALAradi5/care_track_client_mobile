import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/texts/chat_texts.dart';

/// Who is typing now in the open thread.
class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key, required this.names});

  final List<String> names;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium, vertical: AppSpacing.tiny),
    child: Text('${names.join(', ')} ${ChatTexts.typing}', style: Theme.of(context).textTheme.bodySmall),
  );
}
