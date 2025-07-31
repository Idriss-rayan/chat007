import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List users = [];
  String currentUserEmail = '';

  @override
  void initState() {
    super.initState();
    loadCurrentUserEmail();
  }

  Future<void> loadCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    if (email != null) {
      setState(() {
        currentUserEmail = email;
      });
      await fetchUsers();
    }
  }

  Future<void> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse("http://192.168.0.169:5000/api/users?email=$currentUserEmail"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // On filtre l'utilisateur courant pour ne pas l'afficher
      final filteredUsers =
          data.where((user) => user['email'] != currentUserEmail).toList();
      setState(() {
        users = filteredUsers;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des utilisateurs")),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (currentUserEmail.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Connecté en tant que $currentUserEmail"),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['email']),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chat',
                      arguments: {
                        'sender': currentUserEmail,
                        'receiver': user['email'],
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
