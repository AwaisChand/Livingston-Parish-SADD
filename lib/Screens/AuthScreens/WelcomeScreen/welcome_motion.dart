import 'package:flutter/animation.dart';

/// Timing for the post-login welcome sequence.
/// Intervals are fractions of [sequence], so the gesture stays in sync
/// if the duration changes.
class WelcomeMotion {
  const WelcomeMotion._();

  static const Duration route = Duration(milliseconds: 420);
  static const Duration sequence = Duration(seconds: 5);
  static const Duration reduced = Duration(milliseconds: 900);

  static const int rippleCount = 3;

  static const Interval logo = Interval(0.04, 0.46, curve: Curves.easeOutCubic);
  static const Interval label = Interval(0.34, 0.56, curve: Curves.easeOut);
  static const Interval name = Interval(0.46, 0.66, curve: Curves.easeOut);
  static const Interval rule = Interval(0.56, 0.74, curve: Curves.easeOutCubic);
  static const Interval subtitle = Interval(0.64, 0.82, curve: Curves.easeOut);
  static const Interval action = Interval(0.76, 0.90, curve: Curves.easeOut);

  static Interval ripple(int index) {
    final start = 0.08 * index;
    return Interval(start, 0.72 + (0.04 * index), curve: Curves.easeOutCubic);
  }
}
