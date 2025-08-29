import 'package:flutter/material.dart';
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
      body: Column(
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
          Divider(),
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
          Confirm(),
        ],
      ),
    );
  }
}
