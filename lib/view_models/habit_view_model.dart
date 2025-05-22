import 'package:bad_calendar/models/habit_record_model.dart';
import 'package:bad_calendar/models/time_period_model.dart';
import 'package:bad_calendar/repository/habit_repository.dart';
import 'package:flutter/material.dart';

class HabitViewModel extends ChangeNotifier {
  final HabitRepository _repo = HabitRepository();
  Map<DateTime, HabitRecordModel> _records = {};

  Map<DateTime, HabitRecordModel> get records => _records;
  DateTime get today => HabitRecordModel.dateOnly(DateTime.now());

  DateTime _focusedDay = HabitRecordModel.dateOnly(DateTime.now());
  DateTime _selectedDay = HabitRecordModel.dateOnly(DateTime.now());
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  void backToToday() {
    _selectedDay = today;
    _focusedDay = today;
    notifyListeners();
  }

  // 设置选中的日期
  void setSelectedDay(DateTime day) {
    _selectedDay = HabitRecordModel.dateOnly(day);
    _focusedDay = HabitRecordModel.dateOnly(day);
    notifyListeners();
  }

  // 设置焦点的日期
  void setFocusedDay(DateTime day) {
    // 如果是今天，则选中今天
    if (day.year == today.year && day.month == today.month) {
      _selectedDay = today;
      _focusedDay = today;
    } else {
      _focusedDay = HabitRecordModel.dateOnly(day);
      _selectedDay = HabitRecordModel.dateOnly(day);
    }
    notifyListeners();
  }

  // 判断当天是否有事件
  bool hasEvent(DateTime day) {
    final key = HabitRecordModel.dateOnly(day);
    if (_records.containsKey(key)) {
      return true;
    }
    return false;
  }

  void addRecord(DateTime day, TimePeriodModel period) {
    final key = HabitRecordModel.dateOnly(day);
    final record = _records[key] ?? HabitRecordModel(date: key);
    record.addPeriod(period);
    _records[key] = record;

    _repo.saveRecord(record);
    notifyListeners();
  }

  void removeRecord(DateTime day, TimePeriodModel period) {
    final key = HabitRecordModel.dateOnly(day);
    final record = _records[key];
    if (record != null) {
      record.removePeriod(period);
      if (record.recordedPeriods.isEmpty) {
        _records.remove(key);
        _repo.deleteRecord(key);
      } else {
        _repo.saveRecord(record);
      }
      notifyListeners();
    }
  }

  // 判断是否有记录
  bool hasRecord(DateTime day, TimePeriodModel period) {
    final key = HabitRecordModel.dateOnly(day);
    if (_records.containsKey(key)) {
      return _records[key]!.hasPeriod(period);
    }
    return false;
  }

  // 获取单元格颜色
  Color getCellColor(DateTime day, TimePeriodModel period) {
    final thisDay = HabitRecordModel.dateOnly(day);

    // 如果有记录，则红色
    if (hasRecord(thisDay, period)) {
      return Colors.red;
    }

    // 如果是未来或者当前时间段没有记录，则灰色
    return Colors.grey.shade300;
  }

  // 获取当前时间段
  TimePeriodModel getCurrentTimePeriod() {
    final hour = DateTime.now().hour;
    if (hour < 12) return TimePeriodModel.morning;
    if (hour < 14) return TimePeriodModel.noon;
    if (hour < 18) return TimePeriodModel.afternoon;
    return TimePeriodModel.evening;
  }

  // 加载所有记录
  Future<void> loadAll() async {
    final list = await _repo.getAllRecords();
    _records = {for (var r in list) HabitRecordModel.dateOnly(r.date): r};
    notifyListeners();
  }

  // 添加/删除记录
  Future<void> togglePeriod(DateTime day, TimePeriodModel period) async {
    final dateOnly = HabitRecordModel.dateOnly(day);

    // 1. 获取当天记录（可空）
    HabitRecordModel? record = _records[dateOnly];

    if (record == null) {
      // 第一次添加记录
      record = HabitRecordModel(date: dateOnly);
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
