import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/users/card_user.dart';

class ListUser extends StatelessWidget {
  const ListUser({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 1000, // nombre de messages
      itemBuilder: (context, index) {
        return CardUser();
      },
    );
  }
}
