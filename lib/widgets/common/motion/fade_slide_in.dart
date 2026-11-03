import 'package:flutter/material.dart';

import '../../../constants/motion.dart';

/// Fades and slides its child up into place once, after `index` stagger steps (list entrances).
/// Respects the system "reduce motion" setting.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({super.key, required this.child, this.index = 0});

  final Widget child;
  final int index;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this, duration: Motion.medium);
  late final _curve = CurvedAnimation(parent: _controller, curve: Motion.standard);

  @override
  void initState() {
    super.initState();
    final steps = widget.index.clamp(0, Motion.maxStaggerItems);
    Future<void>.delayed(Motion.staggerStep * steps, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _curve,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, Motion.enterOffset), end: Offset.zero).animate(_curve),
        child: widget.child,
      ),
    );
  }
}
