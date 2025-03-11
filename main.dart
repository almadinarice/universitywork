import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiple Inputs Example',
      debugShowCheckedModeBanner: false,
      home: const InputPage(),
    );
  }
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // List to hold multiple entries
  List<Map<String, String>> entries = [];

  // Save entries as a JSON string in SharedPreferences
  Future<void> saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonEntries = jsonEncode(entries);
    await prefs.setString('entries', jsonEntries);
  }

  // Add an entry and clear input fields
  void _addEntry() {
    if (emailController.text.isEmpty || nameController.text.isEmpty) {
      return;
    }
    setState(() {
      entries.add({
        "email": emailController.text,
        "name": nameController.text,
      });
      emailController.clear();
      nameController.clear();
    });
    saveEntries();
  }

  // Navigate to the DisplayPage to show all saved entries
  void _navigateToDisplayPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DisplayPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Multiple Inputs")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addEntry,
                  child: const Text("Add Entry"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _navigateToDisplayPage,
                  child: const Text("Save and Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayPage extends StatefulWidget {
  const DisplayPage({super.key});

  @override
  State<DisplayPage> createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<Map<String, dynamic>> entries = [];

  // Load the saved entries from SharedPreferences
  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonEntries = prefs.getString('entries');
    if (jsonEntries != null) {
      List decoded = jsonDecode(jsonEntries);
      setState(() {
        entries = List<Map<String, dynamic>>.from(decoded);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Display All Entries")),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ListTile(
            title: Text("Email: ${entry['email']}"),
            subtitle: Text("Name: ${entry['name']}"),
          );
        },
      ),
    );
  }
}
