import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/facilities/opening_state.dart';

/// The "open now" filter of Hospitals near you; dropped when the screen closes.
class NearOpeningFilterController extends Notifier<OpeningState?> {
  @override
  OpeningState? build() => null;

  void set(OpeningState? value) => state = value;
}

final nearOpeningFilterProvider = NotifierProvider.autoDispose<NearOpeningFilterController, OpeningState?>(
  NearOpeningFilterController.new,
);
