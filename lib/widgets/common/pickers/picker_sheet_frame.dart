import 'package:flutter/material.dart';

import '../../../constants/picker_layout.dart';
import '../../../constants/texts/picker_texts.dart';

/// The bar with Cancel and Done above a picker's wheels, inside the sheet.
class PickerSheetFrame extends StatelessWidget {
  const PickerSheetFrame({super.key, required this.onDone, required this.child, this.header});

  final VoidCallback onDone;
  final Widget? header;
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLowest,
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text(PickerTexts.cancel)),
              TextButton(onPressed: onDone, child: const Text(PickerTexts.done)),
            ],
          ),
          ?header,
          SizedBox(height: PickerLayout.wheelHeight, child: child),
        ],
      ),
    ),
  );
}
