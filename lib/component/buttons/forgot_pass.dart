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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white.withOpacity(0.3); // couleur du ripple
                }
                return null;
              },
            ),
          ),
          onPressed: () {
            setState(() {
              IsClicked = !IsClicked;
            });
          },
          child: Text(
            'Forgot password',
            style: TextStyle(
              color: IsClicked ? Colors.white : Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
