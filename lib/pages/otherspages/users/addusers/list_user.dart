import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simplechat/pages/otherspages/users/addusers/card_user.dart';
import 'package:simplechat/pages/otherspages/users/component/bucket.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  Bucket bucket = Bucket();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.43.198:3000/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print(
            'Nombre d\'utilisateurs récupérés: ${responseData.length}'); // Debug

        setState(() {
          bucket.users = responseData;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print('Erreur HTTP: ${response.statusCode}');
        print('Body: ${response.body}');
      }
    } catch (e) {
      print("Erreur lors du chargement des utilisateurs: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(61, 244, 107, 2),
        ),
      );
    }

    // CORRECTION : Utiliser bucket.users au lieu de users
    if (bucket.users.isEmpty) {
      return const Center(
        child: Text('Aucun utilisateur trouvé'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bucket.users.length,
      itemBuilder: (context, index) {
        final user = bucket.users[index];

        // Debug pour voir la structure des données
        print('Utilisateur $index: $user');

        return CardUser(
          userName: user['name'] ?? user['username'] ?? 'Utilisateur sans nom',
          country: user['country'] ?? 'Pays non spécifié',
          mutualFriends: 10, // Adaptez selon votre API
          gender: user['gender'] ?? 'Non spécifié',
        );
      },
    );
  }
}
