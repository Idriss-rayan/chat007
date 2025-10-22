import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/users/following_pages/following_card.dart';

class FriendList extends StatelessWidget {
  const FriendList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 15, // nombre de messages
      itemBuilder: (context, index) {
        return const FriendCard();
      },
    );
  }
}
