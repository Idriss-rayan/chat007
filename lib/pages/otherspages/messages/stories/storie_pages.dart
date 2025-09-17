import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/messages/stories/list_new_stories.dart';

class StoriePages extends StatelessWidget {
  const StoriePages({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              'New stories',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListNewStories(),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: Text(
              'stories already watch',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
