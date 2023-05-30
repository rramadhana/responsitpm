import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'register.dart';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Box<String> userBox;
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    final appDocumentDir = await Hive.openBox<String>('users');
    setState(() {
      userBox = appDocumentDir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('LOGIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              size: 75.0,
              color: Colors.red,
            ),
            const SizedBox(height: 16.0),

            const SizedBox(height: 16.0),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
              obscureText: obscureText,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _login(),
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Background color
              ),

            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                );
              },
              child: const Text(
                'Tekan sini dulu bro bro sebelum login',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (userBox.containsKey(username)) {
      String savedPassword = userBox.get(username)!;
      if (password == savedPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Gagal'),
          content: const Text('Username atau Password Salah.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
