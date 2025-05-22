import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit_record_model.dart';

class HabitDatabase {
  static final HabitDatabase _instance = HabitDatabase._internal();
  factory HabitDatabase() => _instance;
  HabitDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'habit_records.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habit_records (
        date TEXT PRIMARY KEY,
        periods TEXT
      )
    ''');
  }

  Future<void> insertRecord(HabitRecordModel record) async {
    final db = await database;
    await db.insert(
      'habit_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<HabitRecordModel>> getAllRecords() async {
    final db = await database;
    final maps = await db.query('habit_records');

    return maps.map((map) => HabitRecordModel.fromMap(map)).toList();
  }

  Future<HabitRecordModel?> getRecordByDate(DateTime date) async {
    final db = await database;
    final result = await db.query(
      'habit_records',
      where: 'date = ?',
      whereArgs: [HabitRecordModel.dateOnly(date).toIso8601String()],
    );

    if (result.isNotEmpty) {
      return HabitRecordModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> deleteRecord(DateTime date) async {
    final db = await database;
    await db.delete(
      'habit_records',
      where: 'date = ?',
      whereArgs: [HabitRecordModel.dateOnly(date).toIso8601String()],
    );
  }
}
