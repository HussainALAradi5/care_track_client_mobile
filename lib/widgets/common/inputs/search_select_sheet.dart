import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import '../../../constants/texts/search_select_texts.dart';
import '../../../controllers/ui/search_select_controller.dart';
import '../../../interfaces/ui/search_loader.dart';
import '../../../models/ui/search_option.dart';
import '../feedback/error_state.dart';
import '../feedback/load_more_footer.dart';

/// Opens the picker; resolves to the chosen row, [SearchOption.none] for "no choice", or null when dismissed.
Future<SearchOption?> showSearchSelectSheet(
  BuildContext context, {
  required String title,
  required SearchLoader load,
  String? clearLabel,
}) => showModalBottomSheet<SearchOption>(
  context: context,
  isScrollControlled: true,
  builder: (_) => SearchSelectSheet(title: title, load: load, clearLabel: clearLabel),
);

/// Type to search rows paged on the server.
class SearchSelectSheet extends StatefulWidget {
  const SearchSelectSheet({super.key, required this.title, required this.load, this.clearLabel});

  final String title;
  final SearchLoader load;
  final String? clearLabel;

  @override
  State<SearchSelectSheet> createState() => _SearchSelectSheetState();
}

class _SearchSelectSheetState extends State<SearchSelectSheet> {
  late final _controller = SearchSelectController(widget.load);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _results() {
    final c = _controller;
    if (c.loading) return const Center(child: CircularProgressIndicator());
    if (c.error != null) return ErrorState(error: c.error!, onRetry: c.retry);
    if (c.items.isEmpty && widget.clearLabel == null) return const Center(child: Text(SearchSelectTexts.empty));
    return ListView(
      children: [
        if (widget.clearLabel != null)
          ListTile(title: Text(widget.clearLabel!), onTap: () => Navigator.pop(context, SearchOption.none)),
        for (final option in c.items)
          ListTile(
            title: Text(option.label),
            subtitle: option.detail == null ? null : Text(option.detail!),
            onTap: () => Navigator.pop(context, option),
          ),
        LoadMoreFooter(hasNext: c.hasNext, onLoadMore: c.loadMore),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * AppSpacing.sheetHeightFactor;
    return SafeArea(
      child: Padding(
        padding: AppSpacing.sheet.add(EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom)),
        child: SizedBox(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.medium),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: SearchSelectTexts.search,
                  prefixIcon: Icon(Icons.search_rounded),
                ),
                onChanged: _controller.search,
              ),
              const SizedBox(height: AppSpacing.small),
              Expanded(child: ListenableBuilder(listenable: _controller, builder: (_, _) => _results())),
            ],
          ),
        ),
      ),
    );
  }
}
