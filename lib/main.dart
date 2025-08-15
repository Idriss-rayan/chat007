import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late IO.Socket socket;
  String chatLog = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = IO.io(
      'http://10.0.2.2:3000', // Android Emulator → "10.0.2.2" au lieu de "localhost"
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    // Connexion réussie
    socket.onConnect((_) {
      addLog("✅ Connecté au serveur");
    });

    // Réception des événements du serveur
    socket.on('username set', (username) {
      addLog("Votre pseudo : $username");
    });

    socket.on('joined room', (room) {
      addLog("Vous avez rejoint la salle : $room");
    });

    socket.on('chat message', (data) {
      addLog("[${data['timestamp']}] ${data['user']}: ${data['text']}");
    });

    socket.on('user joined', (msg) {
      addLog(msg);
    });

    socket.on('user typing', (username) {
      addLog("$username est en train d'écrire...");
    });

    socket.connect();
  }

  void addLog(String msg) {
    setState(() {
      chatLog += msg + "\n";
    });
  }

  void setUsername() {
    socket.emit('set username', usernameController.text);
  }

  void joinRoom() {
    socket.emit('join room', roomController.text);
  }

  void sendMessage() {
    socket.emit('chat message', messageController.text);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Chat Flutter + Node.js")),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: "Pseudo")),
              ElevatedButton(
                  onPressed: setUsername, child: Text("Valider pseudo")),
              TextField(
                  controller: roomController,
                  decoration: InputDecoration(labelText: "Salle")),
              ElevatedButton(
                  onPressed: joinRoom, child: Text("Rejoindre salle")),
              Expanded(child: SingleChildScrollView(child: Text(chatLog))),
              TextField(
                  controller: messageController,
                  decoration: InputDecoration(labelText: "Message")),
              ElevatedButton(onPressed: sendMessage, child: Text("Envoyer")),
            ],
          ),
        ),
      ),
    );
  }
}
