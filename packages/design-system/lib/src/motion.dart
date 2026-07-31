/// YDS Motion Tokens
///
/// Only animate opacity and transform. Never animate width, height, top, left.
class YMotion {
  YMotion._();

  static const Duration fast   = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow   = Duration(milliseconds: 350);

  /// Default easing for all transitions
  static const String easingDefault = 'cubic-bezier(0.4, 0, 0.2, 1)';

  /// Entrance: faster start
  static const String easingEnter = 'cubic-bezier(0, 0, 0.2, 1)';

  /// Exit: faster end
  static const String easingExit = 'cubic-bezier(0.4, 0, 1, 1)';
}
