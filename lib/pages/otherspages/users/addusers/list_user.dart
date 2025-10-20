import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simplechat/pages/otherspages/users/addusers/card_user.dart';

class ListUser extends StatefulWidget {
  const ListUser({super.key});

  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  List users = [];
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
        print('Réponse API: ${response.body}'); // ← AJOUTEZ CETTE LIGNE
        setState(() {
          users = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print('Erreur HTTP: ${response.statusCode}');
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
        child: CircularProgressIndicator(),
      );
    }

    if (users.isEmpty) {
      return const Center(
        child: Text('Aucun utilisateur trouvé'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        // Adapté à la structure de votre API SQL
        return CardUser(
          userName: user['name'] ?? 'Utilisateur sans nom',
          country: user['country'] ?? 'Country non disponible',
          mutualFriends: 10,
          gender: user['gender'] ?? 'gender address non disponible',
        );
      },
    );
  }
}
