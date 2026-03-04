class TimeUtils {
  /// Formats total minutes into:
  /// - "< 1h": exact minutes (e.g., "45m")
  /// - ">= 1h and < 24h": hours (e.g., "5h")
  /// - ">= 24h": days and hours (e.g., "2d 5h")
  static String formatMinutes(int totalMinutes) {
    if (totalMinutes < 0) return '0m';

    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    } else if (totalMinutes < 1440) {
      // 24 hours = 1440 minutes
      final hours = totalMinutes ~/ 60;
      return '${hours}h';
    } else {
      final days = totalMinutes ~/ 1440;
      final remainingHours = (totalMinutes % 1440) ~/ 60;
      if (remainingHours == 0) {
        return '${days}d';
      }
      return '${days}d ${remainingHours}h';
    }
  }

  /// Formats total hours into the standard format defined above.
  static String formatHours(double totalHours) {
    if (totalHours < 0) return '0m';

    final int totalMinutes = (totalHours * 60).round();
    return formatMinutes(totalMinutes);
  }

  /// Calculates the time difference between now and a given DateTime,
  /// formatting it in the same way (with " ago" appended).
  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    final totalMinutes = diff.inMinutes;

    if (totalMinutes < 0) return '0m ago';

    if (totalMinutes < 60) {
      return '${totalMinutes}m ago';
    } else if (totalMinutes < 1440) {
      final hours = totalMinutes ~/ 60;
      return '${hours}h ago';
    } else {
      final days = totalMinutes ~/ 1440;
      final remainingHours = (totalMinutes % 1440) ~/ 60;
      if (remainingHours == 0) {
        return '${days}d ago';
      }
      return '${days}d ${remainingHours}h ago';
    }
  }
}
