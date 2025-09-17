import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/stories/stories_card.dart';

class ListNewStories extends StatelessWidget {
  const ListNewStories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: 50,
        itemBuilder: (context, index) {
          return StoriesCard();
        },
      ),
    );
  }
}
