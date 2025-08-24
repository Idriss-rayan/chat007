import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simplechat/component/buttons/email_button.dart';
import 'package:simplechat/component/buttons/password_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: Stack(
        children: [
          // ici, Boxfit,cover pour couvir completement mon background avec une image
          SizedBox.expand(
            child: Image.asset(
              "assets/images/bg.png",
              fit: BoxFit.cover,
            ),
          ),
          // dans ce stack, j'ai utiliser Align widget pour tres bien aligner mon text Sign-in, c'est la meilleure optio selon chatGPT
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: height * 0.125,
                  ), // je pouvais utliser positionned, mais prefere align parce qu'il est plus adaptatif
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(0.4),
                      fontFamily: "Georgia",
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                      child: Container(
                        width: width * 0.9052,
                        height: height * 0.65,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(12, 255, 255, 255),
                          border: Border.all(
                            color: Colors.white30,
                          ),
                        ), // pour l'effet "verre"
                        alignment: Alignment.center,
                        child: Form(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: height * 0.03,
                              left: width * 0.03,
                              right: width * 0.03,
                            ),
                            child: Column(
                              children: [
                                EmailButton(),
                                PasswordButton(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
