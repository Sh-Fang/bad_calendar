// lib/viewmodels/calendar_view_model.dart
import 'package:flutter/material.dart';
import '../models/time_period.dart';
import '../models/habit_record.dart';

class CalendarViewModel extends ChangeNotifier {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, HabitRecord> _records = {};

  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  // 获取日期对应的记录
  HabitRecord? getRecord(DateTime date) {
    final dateOnly = HabitRecord.dateOnly(date);
    return _records[dateOnly];
  }

  // 设置选中的日期
  void selectDay(DateTime day) {
    _selectedDay = day;
    _focusedDay = day;
    notifyListeners();
  }

  // 选择今天
  void selectToday() {
    selectDay(DateTime.now());
  }

  // 获取当前时间段
  TimePeriod getCurrentTimePeriod() {
    final hour = DateTime.now().hour;
    if (hour < 12) return TimePeriod.morning;
    if (hour < 14) return TimePeriod.noon;
    if (hour < 18) return TimePeriod.afternoon;
    return TimePeriod.evening;
  }

  // 判断是否是今天
  bool isToday(DateTime date) {
    final today = HabitRecord.dateOnly(DateTime.now());
    return HabitRecord.dateOnly(date) == today;
  }

  // 添加或删除记录
  void toggleRecord() {
    if (_selectedDay == null) return;

    final today = HabitRecord.dateOnly(DateTime.now());
    final selected = HabitRecord.dateOnly(_selectedDay!);

    // 只能记录今天
    if (selected != today) return;

    final currentPeriod = getCurrentTimePeriod();

    // 获取或创建记录
    final record = _records[selected] ?? HabitRecord(date: selected);

    // 切换记录状态
    if (record.hasPeriod(currentPeriod)) {
      record.removePeriod(currentPeriod);
    } else {
      record.addPeriod(currentPeriod);
    }

    _records[selected] = record;
    notifyListeners();
  }

  // 判断某个时间段是否已记录
  bool isRecorded(DateTime date, TimePeriod period) {
    final record = getRecord(date);
    if (record == null) return false;
    return record.hasPeriod(period);
  }

  // 获取单元格颜色
  Color getCellColor(DateTime day, TimePeriod period) {
    final today = HabitRecord.dateOnly(DateTime.now());
    final thisDay = HabitRecord.dateOnly(day);

    // 过去的日期，显示绿色（表示安全度过）
    if (thisDay.isBefore(today)) {
      return Colors.green;
    }
    // 如果是今天
    else if (thisDay == today) {
      final currentPeriod = getCurrentTimePeriod();

      // 如果已经记录了坏习惯
      if (isRecorded(thisDay, period)) {
        return Colors.red;
      }
      // 过去的时间段，显示绿色
      else if (period.index < currentPeriod.index) {
        return Colors.green;
      }
    }

    // 默认灰色
    return Colors.grey.shade300;
  }

  // 更新焦点日期
  void updateFocusedDay(DateTime newFocusedDay) {
    _focusedDay = newFocusedDay;
    _selectedDay = newFocusedDay;
    notifyListeners();
  }
}
