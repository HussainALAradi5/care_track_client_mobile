import 'package:flutter/material.dart';

import '../../../constants/texts/common_texts.dart';
import '../../../enums/ui/button_variant.dart';
import '../buttons/app_button.dart';

/// "Load more" at the end of a paged list; hidden when there is nothing more.
class LoadMoreFooter extends StatelessWidget {
  const LoadMoreFooter({super.key, required this.hasNext, required this.onLoadMore});

  final bool hasNext;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) {
    if (!hasNext) return const SizedBox(height: 24);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: AppButton(
          label: CommonTexts.loadMore,
          icon: Icons.expand_more_rounded,
          variant: ButtonVariant.tonal,
          onPressed: onLoadMore,
        ),
      ),
    );
  }
}
