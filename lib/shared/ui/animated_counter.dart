import 'package:flutter/material.dart';

/// Smoothly animates a number from 0 → [value] using a tween.
/// Ideal for stat counters.
class AnimatedCounter extends StatelessWidget {
  final double value;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final Duration duration;
  final int decimals;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.duration = const Duration(milliseconds: 1200),
    this.decimals = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        final formatted = decimals > 0
            ? animatedValue.toStringAsFixed(decimals)
            : animatedValue.toInt().toString();
        return Text(
          '$prefix$formatted$suffix',
          style: style ?? Theme.of(context).textTheme.displayMedium,
        );
      },
    );
  }
}
