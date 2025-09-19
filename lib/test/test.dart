import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/users/addusers/card_user2.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CardUser2(),
        ),
      ),
    );
  }
}
