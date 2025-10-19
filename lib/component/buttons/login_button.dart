import 'dart:convert' show json;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/gate/informations.dart';
import 'package:simplechat/pages/main_page.dart';

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
  /// Récupère le token JWT stocké
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            if (widget.onLogin != null) {
              /// Appel de la fonction login (Future<bool>)
              bool success = await widget.onLogin!();

              if (success) {
                /// Récupère le token stocké
                String token = await getToken();

                /// Vérifie si l'utilisateur a déjà rempli ses infos
                final response = await http.get(
                  Uri.parse('http://192.168.43.198:3000/user-info'),
                  headers: {'Authorization': 'Bearer $token'},
                );

                if (response.statusCode == 200) {
                  final jsonData = json.decode(response.body);

                  if (jsonData['hasInfo'] == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Informations()),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erreur serveur')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Échec de la connexion')),
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "Log In",
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
