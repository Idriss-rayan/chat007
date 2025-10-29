import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket? _socket;
  final List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  void connect(int userId, String token) {
    // 👈 AJOUT DU TOKEN
    if (_socket != null && _socket!.connected) return;
    _socket = IO.io(
      'http://192.168.0.169:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect() // ⚡ Désactive la connexion auto pour contrôler manuellement
          .enableForceNew() // ⚡ Force toujours un nouveau socket, utile pour reconnect
          .build(),
    );

    _socket!.onConnect((_) {
      _isConnected = true;
      notifyListeners();
      debugPrint('✅ Connecté au serveur Socket.IO');
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      notifyListeners();
      debugPrint('❌ Déconnecté du serveur');
    });

    // Réception d'un message privé
    _socket!.on('private_message', (data) {
      _messages.add({
        "text": data["message"],
        "isMe": false,
        "from": data["from"],
      });
      notifyListeners();
    });
    _socket!.connect();
  }

  void sendPrivateMessage(String message, int contactId, int userID) {
    if (_socket == null || !_socket!.connected) return;

    _messages.add({
      "text": message,
      "isMe": true,
      "from": userID,
      "to": contactId,
    });
    _socket!.emit('private_message', {
      "to": contactId,
      "message": message,
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

  // 👈 AJOUTER une méthode disconnect propre
  void disconnect() {
    if (_socket != null) {
      try {
        if (_socket!.connected) {
          _socket!.disconnect(); // Déconnecte proprement
        }
        _socket!.destroy(); // Détruit complètement le socket
      } catch (e) {
        debugPrint('Erreur lors de la déconnexion du socket: $e');
      } finally {
        _socket = null;
        _isConnected = false;
        notifyListeners();
        debugPrint('🔴 Socket détruit et déconnexion complète');
      }
    }
  }
}
