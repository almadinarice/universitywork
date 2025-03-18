import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('loggedIn') ?? false; // Check if the user is logged in

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurpleAccent,
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white24,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // Show SignupPage if not logged in, else ProfilePage
      home: isLoggedIn ? ProfilePage() : SignupPage(),
    );
  }
}

// Profile Page (After successful login)
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name'),
      'email': prefs.getString('email'),
      'phone': prefs.getString('phone'),
      'password': prefs.getString('password'),
    };
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedIn'); // Remove the loggedIn flag
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> deleteUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('phone');
    await prefs.remove('password');
    await prefs.remove('loggedIn'); // Remove the loggedIn flag
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignupPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: FutureBuilder<Map<String, String?>>(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                var data = snapshot.data ?? {};
                nameController.text = data['name'] ?? 'User Name';
                emailController.text = data['email'] ?? 'Email Not Available';
                phoneController.text = data['phone'] ?? 'Phone Not Available';
                passwordController.text = data['password'] ?? '********';

                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.white24,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 50, color: Colors.teal),
                        ),
                        SizedBox(height: 15),
                        Text(
                          data['name'] ?? 'User Name',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 5),
                        Text(
                          data['email'] ?? 'Email Not Available',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        SizedBox(height: 5),
                        Text(
                          data['phone'] ?? 'Phone Not Available',
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: logoutUser,
                          child: Text('Logout'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: deleteUserData,
                          child: Text('Delete Account'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Signup Page (for new users)
class SignupPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void saveUserData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phone', phoneController.text);
    await prefs.setString('password', passwordController.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Signup", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 20),
                TextField(controller: nameController, decoration: InputDecoration(hintText: "Full Name")),
                SizedBox(height: 10),
                TextField(controller: emailController, decoration: InputDecoration(hintText: "Email")),
                SizedBox(height: 10),
                TextField(controller: phoneController, decoration: InputDecoration(hintText: "Phone")),
                SizedBox(height: 10),
                TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(hintText: "Password")),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => saveUserData(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text("Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Login Page (for existing users)
class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedPassword = prefs.getString('password');

    if (emailController.text == storedEmail && passwordController.text == storedPassword) {
      // Save loggedIn flag
      await prefs.setBool('loggedIn', true); // Set loggedIn flag to true
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 20),
                TextField(controller: emailController, decoration: InputDecoration(hintText: "Email")),
                SizedBox(height: 10),
                TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(hintText: "Password")),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => checkLogin(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
