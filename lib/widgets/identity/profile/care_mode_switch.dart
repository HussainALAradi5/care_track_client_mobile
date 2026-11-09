import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/texts/care_mode_texts.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/identity/care_mode_controller.dart';

/// Work or My care, for staff accounts only.
class CareModeSwitch extends ConsumerWidget {
  const CareModeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null || !user.userType.isStaff) return const SizedBox.shrink();
    return SegmentedButton<bool>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment(value: false, label: Text(CareModeTexts.work), icon: Icon(Icons.work_rounded)),
        ButtonSegment(value: true, label: Text(CareModeTexts.care), icon: Icon(Icons.favorite_rounded)),
      ],
      selected: {ref.watch(careModeProvider)},
      onSelectionChanged: (chosen) => ref.read(careModeProvider.notifier).set(chosen.first),
    );
  }
}
