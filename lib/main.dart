import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplechat/gate/gate.dart';
import 'package:simplechat/gate/informations.dart';
import 'package:simplechat/gate/login_page.dart';
import 'package:simplechat/gate/register_page.dart';
import 'package:simplechat/model/provider_model.dart';
import 'package:simplechat/pages/main_page.dart';
import 'package:simplechat/pages/otherspages/messages/message/components/button_contact.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Gate(),
      //home: const ButtonContact(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainPage(),
      },
    );
  }
}
