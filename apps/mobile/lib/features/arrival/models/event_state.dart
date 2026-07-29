import 'arrival_models.dart';

/// Single source of truth for event state evaluation.
///
/// Every screen must use this helper. No screen may implement its own
/// date comparison logic. This ensures consistent behaviour across
/// the Home screen, Event Card, Event Detail, and Live screens.
class EventState {
  /// Returns true if [date] has the same calendar date as today.
  static bool isToday(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns true if the event has started (now >= startDate).
  static bool hasStarted(DateTime? startDate) {
    if (startDate == null) return true; // no start date means always started
    return DateTime.now().isAfter(startDate) ||
        DateTime.now().isAtSameMomentAs(startDate);
  }

  /// Returns true if the event has ended (now > endDate).
  static bool hasEnded(DateTime? endDate) {
    if (endDate == null) return false; // no end date means not yet ended
    return DateTime.now().isAfter(endDate);
  }

  /// Returns true if the user can check in right now.
  static bool canCheckIn(DateTime? startDate, DateTime? endDate) {
    return hasStarted(startDate) && !hasEnded(endDate);
  }

  /// Returns true if the event happens on a future calendar date.
  static bool isUpcoming(DateTime? startDate) {
    if (startDate == null) return false;
    final now = DateTime.now();
    final startDay = DateTime(startDate.year, startDate.month, startDate.day);
    final today = DateTime(now.year, now.month, now.day);
    return startDay.isAfter(today);
  }

  /// Returns true if the event is fully in the past.
  static bool isPast(DateTime? endDate) {
    return hasEnded(endDate);
  }

  /// Returns a human-readable status message about check-in availability.
  /// Returns null if check-in is available (no message needed).
  static String? checkInStatusMessage(DateTime? startDate, DateTime? endDate) {
    if (hasEnded(endDate)) {
      return 'Event has ended';
    }
    if (!hasStarted(startDate)) {
      final hour = startDate!.hour > 12
          ? startDate.hour - 12
          : (startDate.hour == 0 ? 12 : startDate.hour);
      final amPm = startDate.hour >= 12 ? 'PM' : 'AM';
      final minute = startDate.minute.toString().padLeft(2, '0');
      return 'Check-in opens at $hour:$minute $amPm';
    }
    return null; // check-in is available
  }

  /// Convenience method for BusinessEvent.
  static bool canCheckInEvent(BusinessEvent event) {
    return canCheckIn(event.startDate, event.endDate);
  }

  /// Convenience: status message for BusinessEvent.
  static String? checkInStatusForEvent(BusinessEvent event) {
    return checkInStatusMessage(event.startDate, event.endDate);
  }
}
