import '../models/habit_record.dart';
import '../database/habit_database.dart';

class HabitRepository {
  final HabitDatabase _db = HabitDatabase();

  Future<void> saveRecord(HabitRecord record) => _db.insertRecord(record);

  Future<List<HabitRecord>> getAllRecords() => _db.getAllRecords();

  Future<HabitRecord?> getRecord(DateTime date) => _db.getRecordByDate(date);

  Future<void> deleteRecord(DateTime date) => _db.deleteRecord(date);
}
