import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whose shifts the list shows: one clinician's id, or null for everyone.
class ShiftFilterController extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? clinicianId) => state = clinicianId;
}

final shiftFilterProvider = NotifierProvider<ShiftFilterController, String?>(ShiftFilterController.new);
