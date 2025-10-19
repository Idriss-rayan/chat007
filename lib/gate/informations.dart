import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
