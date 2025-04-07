import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'student.dart'; // Make sure you have student.dart model

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'students.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE students(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          course TEXT,
          creditHours INTEGER,
          marks INTEGER
        )
      ''');
    });
  }

  Future<void> insertStudent(Student student) async {
    final dbClient = await db;
    await dbClient.insert('students', student.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Student>> fetchStudents() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('students');

    return List.generate(maps.length, (i) {
      return Student(
        id: maps[i]['id'],
        name: maps[i]['name'],
        course: maps[i]['course'],
        creditHours: maps[i]['creditHours'],
        marks: maps[i]['marks'],
      );
    });
  }
}
