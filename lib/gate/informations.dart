import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/component/buttons/infoscomponent/acc_cond_util.dart';
import 'package:simplechat/component/buttons/infoscomponent/city.dart';
import 'package:simplechat/component/buttons/infoscomponent/confirm.dart';
import 'package:simplechat/component/buttons/infoscomponent/country.dart';
import 'package:simplechat/component/buttons/infoscomponent/email.dart';
import 'package:simplechat/component/buttons/infoscomponent/first_name.dart';
import 'package:simplechat/component/buttons/infoscomponent/gender.dart';
import 'package:simplechat/component/buttons/infoscomponent/last_name.dart';

class Informations extends StatefulWidget {
  const Informations({super.key});

  @override
  State<Informations> createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
  late TextEditingController firstnamecontroller;
  late TextEditingController lastnamecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController countrycontroller;
  late TextEditingController citycontroller;
  late TextEditingController gendercontroller;
  bool _areConditionsAccepted = false; // ✅ Corrigé le nom et initialisé
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // ✅ INITIALISATION des contrôleurs
    firstnamecontroller = TextEditingController();
    lastnamecontroller = TextEditingController();
    emailcontroller = TextEditingController();
    countrycontroller = TextEditingController();
    citycontroller = TextEditingController();
    gendercontroller = TextEditingController();
    _areConditionsAccepted = false;
  }

  // ✅ MÉTHODE POST pour ENVOYER les données
  Future<bool> _saveUserInfos() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('jwt_token');

      if (token == null) {
        print("Token non trouvé");
        return false;
      }

      final response = await http.post(
        Uri.parse('http://192.168.43.198:3000/user-info'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstnamecontroller.text,
          'last_name': lastnamecontroller.text,
          'email': emailcontroller.text,
          'country': countrycontroller.text,
          'city': citycontroller.text,
          'gender': gendercontroller.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Données sauvegardées avec succès!");
        return true;
      } else {
        print("❌ Erreur sauvegarde: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Erreur: $e");
      return false;
    }
  }

  // Méthode pour pré-remplir le formulaire
  void _populateForm(Map<String, dynamic> userData) {
    setState(() {
      firstnamecontroller.text = userData['first_name'] ?? '';
      lastnamecontroller.text = userData['last_name'] ?? '';
      emailcontroller.text = userData['email'] ?? '';
      countrycontroller.text = userData['country'] ?? '';
      citycontroller.text = userData['city'] ?? '';
      gendercontroller.text = userData['gender'] ?? 'Autre';
    });
  }

  @override
  void dispose() {
    // ✅ NETTOYAGE pour éviter les memory leaks
    firstnamecontroller.dispose();
    lastnamecontroller.dispose();
    emailcontroller.dispose();
    countrycontroller.dispose();
    citycontroller.dispose();
    gendercontroller.dispose();
    super.dispose();
  }

  void _onConditionsChanged(bool value) {
    setState(() {
      _areConditionsAccepted = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/logo/PAPAchou.svg',
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              FirstName(
                controller: firstnamecontroller,
              ),
              LastName(
                controller: lastnamecontroller,
              ),
              Email(
                controller: emailcontroller,
              ),
              Country(
                controller: countrycontroller,
              ),
              City(
                controller: citycontroller,
              ),
              Gender(
                controller: gendercontroller,
              ),
              AccCondUtil(
                onChanged: _onConditionsChanged,
              ),
              Confirm(
                controllers: {
                  'firstname': firstnamecontroller,
                  'lastname': lastnamecontroller,
                  'email': emailcontroller,
                  'country': countrycontroller,
                  'city': citycontroller,
                  'gender': gendercontroller,
                },
                areConditionsAccepted: _areConditionsAccepted,
                onSave: _saveUserInfos,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
