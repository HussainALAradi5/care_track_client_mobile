import '../../models/common/page_result.dart';
import '../../models/ui/search_option.dart';

/// Loads one page of a type-to-search picker from the server.
typedef SearchLoader = Future<PageResult<SearchOption>> Function(String term, int page);
