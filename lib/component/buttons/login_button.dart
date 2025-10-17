import 'package:flutter/material.dart';
import 'package:simplechat/gate/informations.dart';

class LoginButton extends StatefulWidget {
  final Future<bool> Function()? onLogin;
  const LoginButton({
    super.key,
    this.onLogin,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        // elevation: 50,
        // shadowColor: Colors.orange,
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (widget.onLogin != null) {
              bool success = await widget.onLogin!();
              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Informations()),
                );
              }
            }
          },
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            width: width * 0.3,
            height: height * 0.06,
            decoration: BoxDecoration(
              color: Colors.white24,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Sign In",
                style: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
