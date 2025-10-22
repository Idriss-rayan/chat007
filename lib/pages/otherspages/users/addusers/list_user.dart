import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Widgets et composants internes
import 'package:simplechat/pages/otherspages/users/addusers/card_user.dart';
import 'package:simplechat/pages/otherspages/users/component/bucket.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  final Bucket bucket = Bucket();

  bool isLoading = true;
  int? currentUserId; // ✅ ID de l'utilisateur connecté

  @override
  void initState() {
    super.initState();
    _initUserAndFetch();
  }

  // 🧠 Étape 1 : Récupération de l'utilisateur connecté et chargement des autres
  Future<void> _initUserAndFetch() async {
    await _getCurrentUserId();
    await _fetchUsers();
  }

  // 🔐 Récupère le userId depuis le token JWT sauvegardé après login
  Future<void> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token'); // correspond à ton loginUser()

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

  // 🌍 Récupère tous les utilisateurs (sauf celui connecté)
  Future<void> _fetchUsers() async {
    if (currentUserId == null) {
      debugPrint(
          "⚠️ currentUserId non défini, impossible de charger les users.");
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.169:3000/users'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final filteredUsers =
            data.where((u) => u['id'] != currentUserId).toList();

        setState(() {
          bucket.users = filteredUsers;
          isLoading = false;
        });
      } else {
        debugPrint(
            '❌ Erreur HTTP (${response.statusCode}) lors du chargement des users');
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Erreur réseau: $e");
      setState(() => isLoading = false);
    }
  }

  // ❤️ Gère le follow/unfollow via ton backend Node.js
  Future<void> _handleFollowUser(dynamic user) async {
    if (currentUserId == null) {
      debugPrint("⚠️ currentUserId non défini !");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.169:3000/follow'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'follower_id': currentUserId,
          'followed_id': user['id'],
        }),
      );

      if (response.statusCode == 200) {
        setState(() => bucket.followUser(user));
        debugPrint('✅ Tu suis maintenant ${user['name']}');
      } else if (response.statusCode == 409) {
        debugPrint('⚠️ Tu suis déjà cet utilisateur');
      } else {
        debugPrint('❌ Erreur follow: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Erreur lors de la requête follow: $e");
    }
  }

  // 🎨 UI principale
  @override
  Widget build(BuildContext context) {
    if (isLoading || currentUserId == null) {
      print('rayan');
      return const Center(child: CircularProgressIndicator());
    }

    if (bucket.users.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Aucun utilisateur à suivre',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tous les utilisateurs sont déjà suivis',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bucket.users.length,
      itemBuilder: (context, index) {
        final user = bucket.users[index];

        return CardUser(
          userName: user['name'] ?? 'Utilisateur sans nom',
          country: user['country'] ?? 'Pays non spécifié',
          userImage: user['avatar_url'] ?? 'assets/component/avatar.svg',
          gender: user['gender'] ?? 'Non spécifié',
          mutualFriends: 100,
          isOnline: user['is_online'] ?? false,
          isInitiallyFollowing: false,
          onFollowChanged: () => _handleFollowUser(user),
          onProfileTap: () =>
              debugPrint('👤 Voir le profil de ${user['name']}'),
          currentUserId: currentUserId!, // ✅ transmis au widget enfant
          otherUserId: user['id'],
        );
      },
    );
  }
}
