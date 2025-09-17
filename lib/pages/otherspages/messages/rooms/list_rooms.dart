import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/rooms/card_rooms.dart';

class ListRooms extends StatelessWidget {
  const ListRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 50, // nombre de messages
      itemBuilder: (context, index) {
        return const CardRooms();
      },
    );
  }
}
