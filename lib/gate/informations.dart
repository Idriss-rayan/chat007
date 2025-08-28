import 'package:flutter/material.dart';
import 'package:simplechat/component/buttons/infoscomponent/email.dart';
import 'package:simplechat/component/buttons/infoscomponent/first_name.dart';
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
      body: ListView(
        children: [
          Column(
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
                  Phonenumber(),
                ],
              ),
              Divider(),
              Row(
                children: [
                  FirstName(),
                  LastName(),
                ],
              ),
              Row(
                children: [
                  FirstName(),
                  LastName(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
