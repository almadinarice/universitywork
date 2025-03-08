import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // Controllers for text fields
  TextEditingController firstNumberController = TextEditingController();
  TextEditingController secondNumberController = TextEditingController();

  // String to hold the result
  String result = "";

  // Function to perform calculations
  void calculate(String operation) {
    double num1 = double.tryParse(firstNumberController.text) ?? 0;
    double num2 = double.tryParse(secondNumberController.text) ?? 0;

    setState(() {
      if (operation == '+') {
        result = (num1 + num2).toString();
      } else if (operation == '-') {
        result = (num1 - num2).toString();
      } else if (operation == '*') {
        result = (num1 * num2).toString();
      } else if (operation == '/') {
        if (num2 != 0) {
          result = (num1 / num2).toString();
        } else {
          result = "Error! Div by 0";
        }
      } else if (operation == '%') {
        result = ((num1 * num2) / 100).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: firstNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'First Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: secondNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Second Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    calculate('+');
                  },
                  child: Text('plus +'),
                ),
                ElevatedButton(
                  onPressed: () {
                    calculate('-');
                  },
                  child: Text('min -'),
                ),
                ElevatedButton(
                  onPressed: () {
                    calculate('*');
                  },
                  child: Text('mul *'),
                ),
                ElevatedButton(
                  onPressed: () {
                    calculate('/');
                  },
                  child: Text('div /'),
                ),
                ElevatedButton(
                  onPressed: () {
                    calculate('%');
                  },
                  child: Text('per %'),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Result: $result',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
