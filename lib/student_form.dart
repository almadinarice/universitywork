import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// MODEL CLASS
class Student {
  final int? id;
  final String name;
  final String course;
  final int creditHours;
  final int marks;

  Student({this.id, required this.name, required this.course, required this.creditHours, required this.marks});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'creditHours': creditHours,
      'marks': marks,
    };
  }
}

// DB HELPER CLASS
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

// MAIN UI
class StudentFormPage extends StatefulWidget {
  const StudentFormPage({super.key});

  @override
  State<StudentFormPage> createState() => _StudentFormPageState();
}

class _StudentFormPageState extends State<StudentFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _dbHelper = DBHelper();

  final nameController = TextEditingController();
  final courseController = TextEditingController();
  final creditController = TextEditingController();
  final marksController = TextEditingController();

  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  void loadStudents() async {
    final data = await _dbHelper.fetchStudents();
    setState(() => students = data);
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final student = Student(
        name: nameController.text,
        course: courseController.text,
        creditHours: int.parse(creditController.text),
        marks: int.parse(marksController.text),
      );
      await _dbHelper.insertStudent(student);
      nameController.clear();
      courseController.clear();
      creditController.clear();
      marksController.clear();
      loadStudents();
    }
  }

  Widget buildCard(Student s) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: Colors.deepPurple[100],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👤 ${s.name}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("📘 Course: ${s.course}", style: TextStyle(fontSize: 16)),
            Text("⏱ Credit Hours: ${s.creditHours}", style: TextStyle(fontSize: 16)),
            Text("📝 Marks: ${s.marks}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🎓 Student Info", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Student Name", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: courseController,
                  decoration: InputDecoration(labelText: "Course Name", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Enter course' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: creditController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Credit Hours", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Enter credit hours' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: marksController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Student Marks", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? 'Enter marks' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text("Submit", style: TextStyle(fontSize: 16)),
                ),
              ]),
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 2),
            const SizedBox(height: 12),
            Text("📋 Student Records", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...students.map((s) => buildCard(s)).toList(),
          ],
        ),
      ),
    );
  }
}
