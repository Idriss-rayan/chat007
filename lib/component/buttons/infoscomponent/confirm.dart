import 'package:flutter/material.dart';

class Confirm extends StatefulWidget {
  const Confirm({super.key});

  @override
  State<Confirm> createState() => _ConfirmState();
}

class _ConfirmState extends State<Confirm> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: width * 0.7,
          height: height * 0.08,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepOrangeAccent),
            borderRadius: BorderRadius.circular(7),
            color: Colors.deepOrange,
          ),
          child: Center(
            child: Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
