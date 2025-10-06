import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplechat/gate/login_page.dart';
import 'package:simplechat/model/provider_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      //: Test(),
    );
  }
}
