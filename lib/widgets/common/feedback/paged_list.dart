import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/common/paged_items.dart';
import '../motion/fade_slide_in.dart';
import 'async_body.dart';
import 'empty_state.dart';
import 'load_more_footer.dart';

/// Every state of a paged list in one place: skeleton while loading, error with retry, the empty panel, or the
/// rows fading in one after another with "Load more" underneath. Rows are keyed by [idOf] so they keep their
/// state (a busy button) across reloads.
class PagedList<T> extends StatelessWidget {
  const PagedList({
    super.key,
    required this.value,
    required this.idOf,
    required this.itemBuilder,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.onRetry,
    required this.onLoadMore,
    this.emptyHint,
  });

  final AsyncValue<PagedItems<T>> value;
  final String Function(T item) idOf;
  final Widget Function(T item) itemBuilder;
  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptyHint;
  final VoidCallback onRetry;
  final Future<void> Function() onLoadMore;

  @override
  Widget build(BuildContext context) => AsyncBody(
    value: value,
    onRetry: onRetry,
    data: (paged) => paged.items.isEmpty
        ? EmptyState(icon: emptyIcon, title: emptyTitle, hint: emptyHint)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < paged.items.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FadeSlideIn(key: ValueKey(idOf(paged.items[i])), index: i, child: itemBuilder(paged.items[i])),
                ),
              LoadMoreFooter(hasNext: paged.hasNext, onLoadMore: onLoadMore),
            ],
          ),
  );
}
