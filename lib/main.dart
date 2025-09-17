import 'package:flutter/material.dart';
import 'package:simplechat/gate/informations.dart';
import 'package:simplechat/gate/login_page.dart';
import 'package:simplechat/pages/main_page.dart';
import 'package:simplechat/pages/otherspages/users/card_user2.dart';
import 'package:simplechat/test/test.dart';

void main() {
  runApp(MyApp());
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
