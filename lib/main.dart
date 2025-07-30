import 'package:flutter/material.dart';
import 'package:simplechat/chat_page.dart';
import 'package:simplechat/lunch_gate.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleChat',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LaunchGate(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/chat': (_) => ChatPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
