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
import 'package:simplechat/component/buttons/infoscomponent/phonenumber.dart';

class Informations extends StatefulWidget {
  const Informations({super.key});

  @override
  State<Informations> createState() => _InformationsState();
}

class _InformationsState extends State<Informations> {
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
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/logo/PAPAchou.svg',
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
              SizedBox(height: 30),
              FirstName(),
              LastName(),
              Email(),
              Country(),
              City(),
              Gender(),
              Phonenumber(),
              AccCondUtil(),
              Confirm(),
            ],
          ),
        ),
      ),
    );
  }
}
