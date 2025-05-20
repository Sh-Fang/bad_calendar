// lib/models/habit_record.dart
import 'time_period.dart';

class HabitRecord {
  final DateTime date;
  final Set<TimePeriod> recordedPeriods;

  HabitRecord({required this.date, Set<TimePeriod>? recordedPeriods})
    : recordedPeriods = recordedPeriods ?? {};

  // 深拷贝构造函数
  HabitRecord copyWith({DateTime? date, Set<TimePeriod>? recordedPeriods}) {
    return HabitRecord(
      date: date ?? this.date,
      recordedPeriods: recordedPeriods ?? Set.from(this.recordedPeriods),
    );
  }

  // 添加时间段记录
  void addPeriod(TimePeriod period) {
    recordedPeriods.add(period);
  }

  // 删除时间段记录
  void removePeriod(TimePeriod period) {
    recordedPeriods.remove(period);
  }

  // 判断某个时间段是否已记录
  bool hasPeriod(TimePeriod period) {
    return recordedPeriods.contains(period);
  }

  // 用于存储的日期格式化
  static DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'periods': recordedPeriods.map((p) => p.index).join(','), // 用逗号分隔保存
    };
  }

  factory HabitRecord.fromMap(Map<String, dynamic> map) {
    return HabitRecord(
      date: DateTime.parse(map['date']),
      recordedPeriods:
          (map['periods'] as String)
              .split(',')
              .where((s) => s.isNotEmpty)
              .map((s) => TimePeriod.values[int.parse(s)])
              .toSet(),
    );
  }
}
