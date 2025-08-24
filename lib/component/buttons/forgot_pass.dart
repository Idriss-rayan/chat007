import 'package:flutter/material.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  bool IsClicked = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        setState(() {
          IsClicked = !IsClicked;
        });
      },
      child: Text(
        'Forgot password',
        style: TextStyle(
          color: IsClicked ? Colors.grey : Colors.white,
        ),
      ),
    );
  }
}
