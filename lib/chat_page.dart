import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];

  late String sender;
  late String receiver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Récupérer les arguments passés lors de la navigation
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    sender = args['sender'];
    receiver = args['receiver'];

    loadMessages(); // Charger les anciens messages depuis le backend
    connectToSocket(); // Se connecter à Socket.IO
  }

  // 🔁 Récupérer les anciens messages depuis l'API
  Future<void> loadMessages() async {
    final response = await http.get(
      Uri.parse(
          "http://192.168.0.169:5000/api/messages?sender=$sender&receiver=$receiver"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        messages = data.map<String>((msg) {
          final from = msg['sender'];
          final text = msg['text'];
          return from == sender ? "Moi: $text" : "$from: $text";
        }).toList();
      });
    } else {
      print("Erreur lors du chargement des messages");
    }
  }

  // 🔌 Connexion au serveur Socket.IO
  void connectToSocket() {
    socket = IO.io('http://192.168.0.169:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("Connecté à Socket.IO");
    });

    socket.on("receive_message", (data) {
      if ((data['sender'] == receiver && data['receiver'] == sender) ||
          (data['sender'] == sender && data['receiver'] == receiver)) {
        setState(() {
          final text = data['text'];
          final from = data['sender'];
          messages.add(from == sender ? "Moi: $text" : "$from: $text");
        });
      }
    });

    socket.onDisconnect((_) => print("Déconnecté de Socket.IO"));
  }

  // 📤 Envoi d’un message
  void sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      socket.emit("send_message", {
        'sender': sender,
        'receiver': receiver,
        'text': text,
      });

      setState(() {
        messages.add("Moi: $text");
        _controller.clear();
      });
    }
  }

  @override
  void dispose() {
    socket.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discussion avec $receiver"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(bottom: 28.0),
                child: ListTile(
                  title: Text(messages[index]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Écrire un message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
