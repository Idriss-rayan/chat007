import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/stories/stories_card.dart';

class ListNewStories extends StatelessWidget {
  const ListNewStories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      itemCount: 50, // nombre de messages
      itemBuilder: (context, index) {
        return StoriesCard();
      },
    );
  }
}
