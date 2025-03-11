import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: FirstPage(),
    );
  }
}

// 🎨 Common Background Decoration
BoxDecoration backgroundDecoration() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue.shade900, Colors.blue.shade300],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sharjeel",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        blurRadius: 5,
                        color: Colors.black54,
                        offset: Offset(2, 2))
                  ],
                ),
              ),
              SizedBox(height: 20),
              customButton(context, "Next Page", SecondPage()),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(),
        child: Center(
          child: customButton(context, "Go to Next Page", ThirdPage()),
        ),
      ),
    );
  }
}

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  String name = "Sharjeel";

  void changeName() {
    setState(() {
      name = name == "Sharjeel" ? "Safdar" : "Sharjeel";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: Text(
                  name,
                  key: ValueKey<String>(name),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 5,
                          color: Colors.black54,
                          offset: Offset(2, 2))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              customButton(context, "Change Name", null, onPressed: changeName),
            ],
          ),
        ),
      ),
    );
  }
}

// 🟢 Custom Button Widget
Widget customButton(BuildContext context, String text, Widget? nextPage,
    {VoidCallback? onPressed}) {
  return ElevatedButton(
    onPressed: onPressed ??
        () {
          if (nextPage != null) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => nextPage));
          }
        },
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 10,
      backgroundColor: Colors.white,
      shadowColor: Colors.black45,
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade900,
      ),
    ),
  );
}
