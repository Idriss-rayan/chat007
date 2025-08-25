import 'package:flutter/material.dart';
import 'package:simplechat/gate/register_page.dart';

class DontHaveAccount extends StatefulWidget {
  const DontHaveAccount({super.key});

  @override
  State<DontHaveAccount> createState() => _DontHaveAccountState();
}

class _DontHaveAccountState extends State<DontHaveAccount> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
      padding: EdgeInsets.only(right: width * 0.09, top: height * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Don't have account ? ",
            style: TextStyle(
              color: Colors.black54,
              fontSize: width * 0.04,
            ),
          ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(),
                ),
              );
            },
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white70,
                fontSize: width * 0.042,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
