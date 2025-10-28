import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/pages/otherspages/messages/message/contact_list.dart';
import 'package:simplechat/pages/otherspages/messages/message/service_socket.dart';
import 'card_msg.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List<dynamic> contacts = [];
  bool isLoading = true;
  int? storedUserId;

  Future<void> fetchContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    setState(() {
      storedUserId = userId;
    });

    if (storedUserId == null) {
      setState(() => isLoading = false);
      print('❌ User ID non trouvé');
      return;
    }

    try {
      final url = Uri.parse('http://192.168.0.169:3000/contacts/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse['success'] == true) {
          setState(() {
            contacts = jsonResponse['contacts'];
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
          print('⚠️ Aucune donnée dans la réponse.');
        }
      } else {
        setState(() => isLoading = false);
        print('❌ Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('⚠️ Erreur réseau: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // 🔌 Connexion automatique au socket dès l'ouverture de la page
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Récupérer d'abord l'userID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      final String? token = prefs.getString('jwt_token');

      if (userId != null) {
        final socketService =
            Provider.of<SocketService>(context, listen: false);
        socketService.connect(userId, token!); // 👈 PASSER L'USERID ICI
      } else {
        print('❌ User ID non trouvé pour la connexion socket');
      }

      fetchContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return CardMsg(
            userId: storedUserId!,
            contactId: contacts[index]['contact_id'] ?? 0,
            contactName: contacts[index]['last_name'] ?? "",
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        shape: const CircleBorder(),
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactList()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
