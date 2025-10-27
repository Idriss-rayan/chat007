import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simplechat/gate/gate.dart';
import 'package:simplechat/gate/login_page.dart';
import 'package:simplechat/gate/register_page.dart';
import 'package:simplechat/model/provider_model.dart';
import 'package:simplechat/pages/main_page.dart';
import 'package:simplechat/test/test2.dart';

import 'pages/otherspages/messages/message/service_socket.dart'; // 👈 ajoute cette ligne

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => SocketService()), // 👈 ajoute ça
      ],
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
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const MainPage(),
        //'/home': (context) => const SocketStatusWidget(),
      },
    );
  }
}
