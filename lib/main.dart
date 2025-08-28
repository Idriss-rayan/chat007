import 'package:flutter/material.dart';
import 'package:simplechat/gate/informations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: LoginPage(),
      home: Informations(),
    );
  }
}
