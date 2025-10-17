import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/component/buttons/surname.dart';
import 'package:simplechat/component/buttons/email_button.dart';
import 'package:simplechat/component/buttons/facebook_btn.dart';
import 'package:simplechat/component/buttons/forgot_pass.dart';
import 'package:simplechat/component/buttons/google_btn.dart';
import 'package:simplechat/component/buttons/login_button.dart';
import 'package:simplechat/component/buttons/password_button.dart';
import 'package:simplechat/component/buttons/register_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  Future<bool> registerUser() async {
    final url = Uri.parse(
        'http://192.168.0.169:3000/api/auth/register'); // 🔗 ton endpoint backend
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      // 201 = Created (succès d'inscription)
      final data = jsonDecode(response.body);
      print("✅ Inscription réussie !");
      print("Utilisateur : ${data['user']}");

      // Optionnel : enregistrer le token directement
      if (data['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', data['token']);
        print("Token sauvegardé !");
      }

      return true;
    } else {
      print("❌ Erreur : ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${response.body}")),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            child: SingleChildScrollView(
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
                                  Surname(
                                    controller: nameController,
                                  ),
                                  EmailButton(
                                    controller: emailController,
                                  ),
                                  PasswordButton(
                                    controller: passwordController,
                                  ),
                                  ForgotPass(),
                                  RegisterButton(
                                    onRegister: registerUser,
                                  ),
                                  Divider(color: Colors.white30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GoogleBtn(),
                                      SizedBox(width: width * 0.1),
                                      FacebookBtn(),
                                    ],
                                  ),
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
          ),
        ],
      ),
    );
  }
}
