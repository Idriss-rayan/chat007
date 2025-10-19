import 'package:flutter/material.dart';

class AccCondUtil extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  const AccCondUtil({super.key, this.onChanged});

  @override
  State<AccCondUtil> createState() => _AccCondUtilState();
}

class _AccCondUtilState extends State<AccCondUtil> {
  bool _isChecked = false;

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
            value: _isChecked,
            onChanged: (bool? value) {
              setState(() {
                _isChecked = value ?? false;
              });
              // Notifier le parent du changement
              if (widget.onChanged != null) {
                widget.onChanged!(_isChecked);
              }
            },
          ),
          Text(
            "Allow PAPAchou",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
