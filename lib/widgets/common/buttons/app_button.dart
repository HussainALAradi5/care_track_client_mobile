import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/motion.dart';
import '../../../enums/ui/button_phase.dart';
import '../../../enums/ui/button_variant.dart';
import '../feedback/app_snack.dart';

/// The only button for actions that call the server: locks on tap (a second tap is ignored), shows a spinner,
/// then briefly a tick. An error shows as a snack and unlocks the button.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = ButtonVariant.filled,
    this.expand = false,
    this.onDone,
  });

  final String label;

  /// Null disables the button.
  final Future<void> Function()? onPressed;
  final IconData? icon;
  final ButtonVariant variant;
  final bool expand;

  /// Runs after a successful action (a snack, navigation).
  final VoidCallback? onDone;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  var _phase = ButtonPhase.idle;
  Timer? _reset;

  @override
  void dispose() {
    _reset?.cancel();
    super.dispose();
  }

  Future<void> _run() async {
    final action = widget.onPressed;
    if (action == null || _phase == ButtonPhase.busy) return;
    setState(() => _phase = ButtonPhase.busy);
    unawaited(HapticFeedback.selectionClick());
    try {
      // A short minimum keeps the spinner from flickering on fast answers.
      await Future.wait([action(), Future<void>.delayed(AppConstants.minimumSpinner)]);
      if (!mounted) return;
      setState(() => _phase = ButtonPhase.done);
      widget.onDone?.call();
      _reset = Timer(AppConstants.doneTickVisible, () {
        if (mounted) setState(() => _phase = ButtonPhase.idle);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _phase = ButtonPhase.idle);
      AppSnack.error(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && _phase != ButtonPhase.busy;
    final leading = switch (_phase) {
      ButtonPhase.busy => const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2.4)),
      ButtonPhase.done => const Icon(Icons.check_rounded, size: 20, key: ValueKey('done')),
      ButtonPhase.idle => widget.icon == null ? null : Icon(widget.icon, size: 20, key: const ValueKey('icon')),
    };
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: Motion.fast,
          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
          child: leading == null
              ? const SizedBox.shrink()
              : Padding(key: ValueKey(_phase), padding: const EdgeInsets.only(right: 8), child: leading),
        ),
        Flexible(child: Text(widget.label, overflow: TextOverflow.ellipsis)),
      ],
    );
    final onPressed = enabled ? _run : null;
    final button = switch (widget.variant) {
      ButtonVariant.filled => FilledButton(onPressed: onPressed, child: child),
      ButtonVariant.tonal => FilledButton.tonal(onPressed: onPressed, child: child),
      ButtonVariant.outlined => OutlinedButton(onPressed: onPressed, child: child),
      ButtonVariant.text => TextButton(onPressed: onPressed, child: child),
    };
    return widget.expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
