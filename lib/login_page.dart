import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
