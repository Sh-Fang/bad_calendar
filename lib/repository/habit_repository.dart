import '../models/habit_record_model.dart';
import '../database/habit_database.dart';

class HabitRepository {
  final HabitDatabase _db = HabitDatabase();

  Future<void> saveRecord(HabitRecordModel record) => _db.insertRecord(record);

  Future<List<HabitRecordModel>> getAllRecords() => _db.getAllRecords();

  Future<HabitRecordModel?> getRecord(DateTime date) =>
      _db.getRecordByDate(date);

  Future<void> deleteRecord(DateTime date) => _db.deleteRecord(date);
}
