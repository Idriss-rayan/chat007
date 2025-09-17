import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/stories/stories_card.dart';
import 'package:simplechat/pages/otherspages/messages/stories/stories_old_card.dart';

class ListOldStories extends StatefulWidget {
  const ListOldStories({super.key});

  @override
  State<ListOldStories> createState() => _ListOldStoriesState();
}

class _ListOldStoriesState extends State<ListOldStories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(
        5,
        (index) => const StoriesOldCard(),
      ),
    );
  }
}
