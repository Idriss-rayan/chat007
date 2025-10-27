import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket? _socket;
  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  void connect() {
    if (_socket != null && _socket!.connected) return;

    _socket = IO.io(
      'http://192.168.0.169:3000', // ⚠️ Mets ton IP locale ici
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint('✅ Connecté au serveur Socket.IO');
    });

    _socket!.onDisconnect((_) {
      debugPrint('❌ Déconnecté du serveur');
    });

    _socket!.on('message', (data) {
      _messages.add({
        "text": data,
        "isMe": false,
      });
      notifyListeners();
    });
  }

  void sendMessage(String message) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('message', message);

    _messages.add({
      "text": message,
      "isMe": true,
    });
    notifyListeners();
  }

  // Pour tester des messages locaux (images, etc.)
  void addLocalMessage(String text) {
    _messages.add({
      "text": text,
      "isMe": true,
    });
    notifyListeners();
  }
}
