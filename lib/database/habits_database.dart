import 'package:badhabit/models/habit.dart';
import 'package:badhabit/models/history_item.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HabitsDatabase {
  static const habitsTableName = 'habits';
  static const historyTableName = 'history';

  static final HabitsDatabase instance = HabitsDatabase._init();

  static Database? _database;

  HabitsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('habits.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS habits(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    dateTime TEXT NOT NULL,
    color INTEGER NOT NULL,
    record INTEGER NOT NULL,
    recordAttempt INTEGER NOT NULL,
    attempt INTEGER NOT NULL
    )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS history(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    type NOT NULL,
    dateTime TEXT NOT NULL,
    comment TEXT,
    FK_habit_id INTEGER NOT NULL,
    FOREIGN KEY (FK_habit_id) REFERENCES habits (id) ON DELETE NO ACTION ON UPDATE NO ACTION
    )
    ''');
  }

  Future<int> insert(Habit habit) async {
    final db = await instance.database;

    final id = await db.insert(habitsTableName, habit.toMap());

    return id;
  }

  Future<int> insertHistoryItem(HistoryItem historyItem) async {
    final db = await instance.database;

    final id = await db.insert(historyTableName, historyItem.toMap());

    return id;
  }

  Future<int> update(Habit habit) async {
    final db = await instance.database;

    final id = await db.update(
      habitsTableName,
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );

    return id;
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    await db.delete(
      habitsTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return await deleteHistoryItems(id);
  }

  Future<int> deleteHistoryItems(int habitId) async {
    final db = await instance.database;

    return await db.delete(
      historyTableName,
      where: 'FK_habit_id = ?',
      whereArgs: [habitId],
    );
  }

  Future<int> deleteHistoryItem(int id) async {
    final db = await instance.database;

    return await db.delete(
      historyTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Habit> getById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      habitsTableName,
      columns: [
        'id',
        'name',
        'dateTime',
        'color',
        'record',
        'recordAttempt',
        'attempt'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Habit.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Habit>> getAll(String? name) async {
    final db = await instance.database;

    final List<Map<String, Object?>> result;

    if (name == null || name.isEmpty) {
      result = await db.query(
        habitsTableName,
      );
    } else {
      result = await db.query(
        habitsTableName,
        where: 'name LIKE ?',
        whereArgs: ['%$name%'],
      );
    }

    return result.map((e) => Habit.fromMap(e)).toList();
  }

  Future<List<HistoryItem>> getHistoryItems(int habitId) async {
    final db = await instance.database;

    final List<Map<String, Object?>> result = await db.query(
      historyTableName,
      orderBy: 'dateTime DESC',
      where: 'FK_habit_id = ?',
      whereArgs: [habitId],
    );

    return result.map((e) => HistoryItem.fromMap(e)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
