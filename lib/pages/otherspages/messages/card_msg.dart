import 'package:flutter/material.dart';

class CardMsg extends StatefulWidget {
  const CardMsg({super.key});

  @override
  State<CardMsg> createState() => _CardMsgState();
}

class _CardMsgState extends State<CardMsg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.amber,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("John Doe",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("Dernier message...",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
          const Text("12:45",
              style: TextStyle(color: Colors.black45, fontSize: 12)),
        ],
      ),
    );
  }
}
