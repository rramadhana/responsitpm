import 'dart:js';

import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'homepage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/homepage': (context) => const HomePage(),
      '/login': (context) => const Login(),
      '/_registerpage': (context) => const RegisterPage(),



    },
    home: const Login(),
  ));
}
