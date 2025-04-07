import 'package:flutter/material.dart';
import 'student_form.dart'; // This is your main form screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Form App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const StudentFormPage(), // Yehi tera form screen hai
    );
  }
}
