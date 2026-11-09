import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../constants/motion.dart';
import '../../interfaces/ui/search_loader.dart';
import '../../models/ui/search_option.dart';

/// One open type-to-search picker: waits for a pause in typing, ignores answers to older searches, pages on demand.
class SearchSelectController extends ChangeNotifier {
  SearchSelectController(this._load) {
    unawaited(_loadFirst());
  }

  final SearchLoader _load;
  Timer? _debounce;
  var _generation = 0;
  var _term = '';
  var _nextPage = 0;
  var _disposed = false;

  List<SearchOption> items = const [];
  bool loading = true;
  bool hasNext = false;
  Object? error;

  void search(String term) {
    _debounce?.cancel();
    _debounce = Timer(Motion.searchDebounce, () {
      _term = term.trim();
      unawaited(_loadFirst());
    });
  }

  void retry() => unawaited(_loadFirst());

  Future<void> _loadFirst() async {
    final generation = ++_generation;
    loading = true;
    error = null;
    _changed();
    try {
      final page = await _load(_term, 0);
      if (generation != _generation) return;
      items = page.items;
      hasNext = page.hasNext;
      _nextPage = 1;
    } catch (failure) {
      if (generation != _generation) return;
      error = failure;
    }
    loading = false;
    _changed();
  }

  Future<void> loadMore() async {
    final generation = _generation;
    final page = await _load(_term, _nextPage);
    if (generation != _generation) return;
    items = [...items, ...page.items];
    hasNext = page.hasNext;
    _nextPage += 1;
    _changed();
  }

  void _changed() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _generation += 1;
    _debounce?.cancel();
    super.dispose();
  }
}
