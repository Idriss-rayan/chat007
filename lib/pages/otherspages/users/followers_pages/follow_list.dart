import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/pages/otherspages/users/followers_api.dart';
import 'package:simplechat/pages/otherspages/users/followers_pages/card_follow.dart';
import 'package:simplechat/pages/otherspages/users/component/bucket.dart';

class FollowList extends StatefulWidget {
  const FollowList({super.key});

  @override
  State<FollowList> createState() => _FollowListState();
}

class _FollowListState extends State<FollowList> {
  int?
      currentUserId; // Make it nullable since it might not be available immediately
  Bucket bucket = Bucket();
  List<dynamic> followers = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getCurrentUserId();
    if (currentUserId != null) {
      await _loadFollowers();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Impossible de récupérer l\'ID utilisateur';
      });
    }
  }

  Future<void> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        setState(() {
          currentUserId = payload['id']; // ✅ ici on prend 'id'
        });
        print("✅ Token trouvé, userId = $currentUserId");
      } catch (e) {
        print("❌ Erreur lors du décodage du token: $e");
      }
    } else {
      print("⚠️ Aucun token trouvé dans SharedPreferences !");
    }
  }

  Future<void> _loadFollowers() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Check if currentUserId is available
      if (currentUserId == null) {
        setState(() {
          isLoading = false;
          errorMessage = 'ID utilisateur non disponible';
        });
        return;
      }

      // Use your existing getFollowers function
      final followersList = await getFollowers(currentUserId!);

      setState(() {
        followers = followersList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Erreur lors du chargement des followers';
      });
      print('Error loading followers: $e');
    }
  }

  Future<void> _handleUnfollow(int followedId) async {
    try {
      // Check if currentUserId is available
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ID utilisateur non disponible'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Call your unfollowUser function
      await unfollowUser(currentUserId!, followedId);

      // Refresh the list after unfollowing
      await _loadFollowers();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Utilisateur unfollow avec succès'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'unfollow: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading if we're still getting the user ID
    if (isLoading && currentUserId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement des informations utilisateur...'),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeData,
              child: Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (followers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_alt_outlined,
                size: 64, color: Color.fromARGB(132, 158, 158, 158)),
            SizedBox(height: 16),
            Text(
              'Aucun follower',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Les utilisateurs qui vous suivent apparaîtront ici',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFollowers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final user = followers[index];
          print('🔍 Toutes les clés de user: ${user.keys}');
          print('🔍 Objet user complet: $user');

          return CardFollow(
            userName: user['name'] ?? 'Utilisateur sans nom',
            country: user['country'] ?? 'Pays non spécifié',
            userImage: user['avatar_url'] ?? 'assets/component/avatar.svg',
            isOnline: user['is_online'] ?? false,
            onUnfollow: () => _handleUnfollow(user['id']),
            currentUserId: currentUserId!,
            targetUserId: user['id'],
          );
        },
      ),
    );
  }
}
