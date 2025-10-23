import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/pages/otherspages/users/followers_api.dart';
import 'package:simplechat/pages/otherspages/users/following_pages/following_card.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  int? currentUserId;
  List<dynamic> following = [];
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
      await _loadFollowing();
    } else {
      setState(() {
        isLoading = false;
        errorMessage = 'Impossible de récupérer l\'ID utilisateur';
      });
    }
  }

  Future<void> _getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé');
      }

      Map<String, dynamic> payload = Jwt.parseJwt(token);
      final userId = payload['id'];

      if (userId == null) {
        throw Exception('ID utilisateur non trouvé dans le token');
      }

      setState(() {
        currentUserId = userId;
      });
    } catch (e) {
      print("❌ Erreur lors de la récupération de l'ID: $e");
      setState(() {
        errorMessage = 'Erreur d\'authentification';
        isLoading = false;
      });
    }
  }

  Future<void> _loadFollowing() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      if (currentUserId == null) {
        throw Exception('ID utilisateur non disponible');
      }

      final followingList = await getFollowing(currentUserId!)
          .timeout(const Duration(seconds: 10));

      if (mounted) {
        setState(() {
          following = followingList;
          isLoading = false;
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Timeout - Vérifiez votre connexion';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage =
              'Erreur lors du chargement des abonnements: ${e.toString()}';
        });
      }
      print('Error loading following: $e');
    }
  }

  Future<void> _handleUnfollow(int followedId) async {
    try {
      if (currentUserId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur: ID utilisateur non disponible'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await unfollowUser(currentUserId!, followedId);

      await _loadFollowing();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Désabonnement réussi'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du désabonnement: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && currentUserId == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            SizedBox(height: 16),
            Text(
              'Chargement de vos abonnements...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeData,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    if (following.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline,
                size: 64, color: Color.fromARGB(132, 158, 158, 158)),
            SizedBox(height: 16),
            Text(
              'Aucun abonnement',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Les utilisateurs que vous suivez apparaîtront ici',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFollowing,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: following.length,
        itemBuilder: (context, index) {
          final user = following[index];

          return FollowingCard(
            userName: user['name'] ?? 'Utilisateur sans nom',
            country: user['country'] ?? 'Pays non spécifié',
            userImage: user['avatar_url'] ?? 'assets/component/avatar.svg',
            isOnline: user['is_online'] ?? false,
            onUnfollow: () => _handleUnfollow(user['id']),
            city: user['city'] ?? "ville non specifie",
          );
        },
      ),
    );
  }
}
