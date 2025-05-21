import 'package:bad_calendar/models/habit_record.dart';
import 'package:bad_calendar/models/time_period.dart';
import 'package:bad_calendar/repository/habit_repository.dart';
import 'package:flutter/material.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitRepository _repo = HabitRepository();
  Map<DateTime, HabitRecord> _records = {};

  Map<DateTime, HabitRecord> get records => _records;
  DateTime get today => HabitRecord.dateOnly(DateTime.now());

  DateTime _focusedDay = HabitRecord.dateOnly(DateTime.now());
  DateTime _selectedDay = HabitRecord.dateOnly(DateTime.now());
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  void backToToday() {
    _selectedDay = today;
    _focusedDay = today;
    notifyListeners();
  }

  // 设置选中的日期
  void setSelectedDay(DateTime day) {
    _selectedDay = HabitRecord.dateOnly(day);
    _focusedDay = HabitRecord.dateOnly(day);
    notifyListeners();
  }

  // 设置焦点的日期
  void setFocusedDay(DateTime day) {
    // 如果是今天，则选中今天
    if (day.year == today.year && day.month == today.month) {
      _selectedDay = today;
      _focusedDay = today;
    } else {
      _focusedDay = HabitRecord.dateOnly(day);
      _selectedDay = HabitRecord.dateOnly(day);
    }
    notifyListeners();
  }

  // 判断当天是否有事件
  bool hasEvent(DateTime day) {
    final key = HabitRecord.dateOnly(day);
    if (_records.containsKey(key)) {
      return true;
    }
    return false;
  }

  void addRecord(DateTime day, TimePeriod period) {
    final key = HabitRecord.dateOnly(day);
    if (_records.containsKey(key)) {
      _records[key]!.addPeriod(period);
    } else {
      _records[key] = HabitRecord(date: day, recordedPeriods: {period});
    }
    notifyListeners();
  }

  void removeRecord(DateTime day, TimePeriod period) {
    final key = HabitRecord.dateOnly(day);
    if (_records.containsKey(key)) {
      _records[key]!.removePeriod(period);
      if (_records[key]!.recordedPeriods.isEmpty) {
        _records.remove(key);
      }
    }
    notifyListeners();
  }

  // 判断是否有记录
  bool hasRecord(DateTime day, TimePeriod period) {
    final key = HabitRecord.dateOnly(day);
    if (_records.containsKey(key)) {
      return _records[key]!.hasPeriod(period);
    }
    return false;
  }

  // 获取单元格颜色
  Color getCellColor(DateTime day, TimePeriod period) {
    final thisDay = HabitRecord.dateOnly(day);

    // 如果有记录，则红色
    if (hasRecord(thisDay, period)) {
      return Colors.red;
    }

    // 如果是未来或者当前时间段没有记录，则灰色
    return Colors.grey.shade300;
  }

  // 获取当前时间段
  TimePeriod getCurrentTimePeriod() {
    final hour = DateTime.now().hour;
    if (hour < 12) return TimePeriod.morning;
    if (hour < 14) return TimePeriod.noon;
    if (hour < 18) return TimePeriod.afternoon;
    return TimePeriod.evening;
  }

  // 加载所有记录
  Future<void> loadAll() async {
    final list = await _repo.getAllRecords();
    _records = {for (var r in list) HabitRecord.dateOnly(r.date): r};
    notifyListeners();
  }

  // 添加/删除记录
  Future<void> togglePeriod(DateTime day, TimePeriod period) async {
    final dateOnly = HabitRecord.dateOnly(day);

    // 1. 获取当天记录（可空）
    HabitRecord? record = _records[dateOnly];

    if (record == null) {
      // 第一次添加记录
      record = HabitRecord(date: dateOnly);
      record.addPeriod(period);
      _records[dateOnly] = record;
      await _repo.saveRecord(record);
    } else if (!record.hasPeriod(period)) {
      // 已有记录但没有该时间段
      record.addPeriod(period);
      _records[dateOnly] = record;
      await _repo.saveRecord(record);
    } else {
      // 有该时间段，执行删除
      record.removePeriod(period);

      if (record.recordedPeriods.isEmpty) {
        // 删除该天的记录
        _records.remove(dateOnly);
        await _repo.deleteRecord(dateOnly); // 可选，如果你有持久化操作
      } else {
        _records[dateOnly] = record;
        await _repo.saveRecord(record);
      }
    }

    notifyListeners();
  }
}
