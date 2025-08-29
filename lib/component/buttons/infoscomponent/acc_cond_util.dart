import 'package:flutter/material.dart';

class AccCondUtil extends StatefulWidget {
  const AccCondUtil({super.key});

  @override
  State<AccCondUtil> createState() => _AccCondUtilState();
}

class _AccCondUtilState extends State<AccCondUtil> {
  bool IsChecked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            checkColor: Colors.white,
            hoverColor: Colors.green,
            focusColor: Colors.green,
            activeColor: Colors.green,
            value: IsChecked,
            onChanged: (bool? value) {
              setState(() {
                IsChecked = value ?? false;
              });
            },
          ),
          //SizedBox(width: 10),
          Text(
            "Allow PAPAchou",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
