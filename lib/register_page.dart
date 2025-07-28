import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 38.0, left: 16, right: 16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'username',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'password',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'confirm password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
