import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../enums/ui/picker_style.dart';
import '../auth/auth_controller.dart';

/// What the signed-in person chose for their pickers; null follows the device.
final chosenPickerStyleProvider = Provider<PickerStyle?>(
  (ref) => ref.watch(authControllerProvider).value?.pickerStyle,
);
