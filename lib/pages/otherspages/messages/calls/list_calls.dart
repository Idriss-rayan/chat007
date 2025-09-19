import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/calls/card_calls.dart';

class ListCalls extends StatelessWidget {
  const ListCalls({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 50, // nombre de messages
      itemBuilder: (context, index) {
        return const CardCalls();
      },
    );
  }
}
