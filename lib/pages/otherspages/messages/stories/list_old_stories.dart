import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/stories/stories_card.dart';

class ListOldStories extends StatefulWidget {
  const ListOldStories({super.key});

  @override
  State<ListOldStories> createState() => _ListOldStoriesState();
}

class _ListOldStoriesState extends State<ListOldStories> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(16),
      itemCount: 50,
      itemBuilder: (context, index) {
        return StoriesCard();
      },
    );
  }
}
