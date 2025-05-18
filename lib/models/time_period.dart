// lib/models/time_period.dart
enum TimePeriod { morning, noon, afternoon, evening }

extension TimePeriodExtension on TimePeriod {
  String get name {
    switch (this) {
      case TimePeriod.morning:
        return '上午';
      case TimePeriod.noon:
        return '中午';
      case TimePeriod.afternoon:
        return '下午';
      case TimePeriod.evening:
        return '晚上';
    }
  }
}
