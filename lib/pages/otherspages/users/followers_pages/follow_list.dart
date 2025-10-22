import 'package:flutter/material.dart';
import 'package:simplechat/pages/otherspages/users/followers_pages/card_follow.dart';
import 'package:simplechat/pages/otherspages/users/component/bucket.dart';

class FollowList extends StatefulWidget {
  const FollowList({super.key});

  @override
  State<FollowList> createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  Bucket bucket = Bucket();

  @override
  Widget build(BuildContext context) {
    if (bucket.followers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucun utilisateur suivi',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Les utilisateurs que vous suivez apparaîtront ici',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bucket.followers.length,
      itemBuilder: (context, index) {
        final user = bucket.followers[index];

        return CardFollow(
          userName: user['name'] ?? 'Utilisateur sans nom',
          country: user['country'] ?? 'Pays non spécifié',
          countryCode: user['country_code'] ?? 'cmr',
          userImage: user['avatar_url'] ?? 'assets/component/avatar.svg',
          gender: user['gender'] ?? 'Non spécifié',
          mutualFriends: user['mutual_friends'] ?? 0,
          isOnline: user['is_online'] ?? false,
          onUnfollow: () {
            setState(() {
              bucket.unfollowUser(user);
            });
            print('Utilisateur unfollow: ${user['name']}');
          },
        );
      },
    );
  }
}
