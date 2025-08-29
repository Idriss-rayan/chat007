import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simplechat/component/buttons/infoscomponent/acc_cond_util.dart';
import 'package:simplechat/component/buttons/infoscomponent/address.dart';
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
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: SvgPicture.asset(
                      'assets/logo/PAPAchou.svg',
                      width: 27,
                      height: 27,
                      // colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn), // optionnel: recoloriser
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      FirstName(),
                      LastName(),
                    ],
                  ),
                  Row(
                    children: [
                      Email(),
                      Gender(),
                    ],
                  ),
                  //Divider(),
                  Row(
                    children: [
                      Country(),
                      City(),
                    ],
                  ),
                  Row(
                    children: [
                      // Address(),
                      Phonenumber(),
                    ],
                  ),
                  AccCondUtil(),
                  Confirm(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
