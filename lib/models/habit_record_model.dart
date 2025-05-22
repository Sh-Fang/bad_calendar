// lib/models/habit_record.dart
import 'time_period_model.dart';

class HabitRecordModel {
  final DateTime date;
  final Set<TimePeriodModel> recordedPeriods;

  HabitRecordModel({required this.date, Set<TimePeriodModel>? recordedPeriods})
    : recordedPeriods = recordedPeriods ?? {};

  // 深拷贝构造函数
  HabitRecordModel copyWith({
    DateTime? date,
    Set<TimePeriodModel>? recordedPeriods,
  }) {
    return HabitRecordModel(
      date: date ?? this.date,
      recordedPeriods: recordedPeriods ?? Set.from(this.recordedPeriods),
    );
  }

  // 添加时间段记录
  void addPeriod(TimePeriodModel period) {
    recordedPeriods.add(period);
  }

  // 删除时间段记录
  void removePeriod(TimePeriodModel period) {
    recordedPeriods.remove(period);
  }

  // 判断某个时间段是否已记录
  bool hasPeriod(TimePeriodModel period) {
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

  factory HabitRecordModel.fromMap(Map<String, dynamic> map) {
    return HabitRecordModel(
      date: DateTime.parse(map['date']),
      recordedPeriods:
          (map['periods'] as String)
              .split(',')
              .where((s) => s.isNotEmpty)
              .map((s) => TimePeriodModel.values[int.parse(s)])
              .toSet(),
    );
  }
}
