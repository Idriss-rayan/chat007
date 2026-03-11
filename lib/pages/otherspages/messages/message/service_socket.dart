import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService with ChangeNotifier {
  IO.Socket? _socket;
  final List<Map<String, dynamic>> _messages = [];
  List<Map<String, dynamic>> get messages => _messages;

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  int? _currentUserId;

  // ✅ Nouvelle méthode pour charger l'historique des messages
  Future<void> loadMessageHistory(int currentUserId, int contactId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');

      final response = await http.get(
        Uri.parse(
            'http://192.168.0.169:3000/messages/$currentUserId/$contactId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['success'] == true) {
          final List<dynamic> messageHistory = data['messages'];

          // ✅ Supprimer uniquement les messages de CETTE conversation
          _messages.removeWhere((msg) =>
              (msg['isMe'] == true && msg['to'] == contactId) ||
              (msg['isMe'] == false && msg['from'] == contactId));

          for (var msg in messageHistory) {
            _messages.add({
              "id": msg['id'],
              "text": msg['message'],
              "isMe": msg['from_user_id'] == currentUserId,
              "from": msg['from_user_id'],
              "to": msg['to_user_id'],
              "timestamp": msg['created_at'],
            });
          }
          notifyListeners();
          debugPrint('📚 Historique chargé: ${_messages.length} messages');
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur chargement historique: $e');
    }
  }

  void connect(int userId, String token) {
    if (_socket != null && _socket!.connected && _currentUserId == userId) {
      return;
    }

    if (_socket != null) {
      disconnect();
    }

    _currentUserId = userId;

    _socket = IO.io(
      'http://192.168.0.169:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .disableAutoConnect()
          .enableForceNew()
          .setTimeout(10000)
          .build(),
    );

    _setupEventListeners();
    _socket!.connect();
  }

  void _setupEventListeners() {
    _socket!.onConnect((_) {
      _isConnected = true;
      debugPrint('✅ Connecté au serveur Socket.IO - User: $_currentUserId');
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      debugPrint('❌ Déconnecté du serveur');
      notifyListeners();
    });

    // ✅ CORRECTION : Réception des messages privés
    _socket!.on('private_message', (data) {
      debugPrint(
          '📩 Message reçu de ${data['from']} pour ${data['to']}: ${data['message']}');

      // Vérifier que le message nous est bien destiné
      if (data['to'] == _currentUserId) {
        _messages.add({
          "id": data['id'],
          "text": data['message'],
          "isMe": false,
          "from": data['from'],
          "to": data['to'],
          "timestamp": data['timestamp'] ?? DateTime.now().toIso8601String(),
        });
        notifyListeners();
        debugPrint('✅ Message ajouté à la liste locale');
      } else {
        debugPrint('❌ Message ignoré - pas pour cet utilisateur');
      }
    });

    _socket!.on('message_sent', (data) {
      debugPrint('✅ Message envoyé avec succès à ${data['to']}');

      // Mettre à jour le statut du message local
      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i]['text'] == data['message'] &&
            _messages[i]['isMe'] == true &&
            _messages[i]['to'] == data['to']) {
          _messages[i]['status'] = 'delivered';
          _messages[i]['id'] = data['id'];
          break;
        }
      }
      notifyListeners();
    });

    _socket!.on('user_offline', (data) {
      debugPrint('⚠️ Utilisateur ${data['to']} est hors ligne');
    });
  }

  void sendPrivateMessage(String message, int contactId, int userId) {
    if (_socket == null || !_socket!.connected) {
      debugPrint('❌ Socket non connecté, impossible d\'envoyer le message');
      return;
    }

    // ✅ Ajouter le message localement
    final newMessage = {
      "text": message,
      "isMe": true,
      "from": userId,
      "to": contactId,
      "timestamp": DateTime.now().toIso8601String(),
      "status": "sending"
    };

    _messages.add(newMessage);
    notifyListeners();

    // ✅ Envoyer via socket
    _socket!.emit('private_message', {
      "to": contactId,
      "message": message,
    });

    debugPrint('📤 Envoi message à $contactId: $message');
  }

  // ✅ Nouvelle méthode pour vider les messages d'une conversation spécifique
  void clearChatMessages(int contactId) {
    _messages.removeWhere((msg) =>
        (msg['isMe'] == true && msg['to'] == contactId) ||
        (msg['isMe'] == false && msg['from'] == contactId));
    notifyListeners();
  }

  void disconnect() {
    if (_socket != null) {
      try {
        _socket!.disconnect();
        _socket!.destroy();
      } catch (e) {
        debugPrint('Erreur lors de la déconnexion du socket: $e');
      } finally {
        _socket = null;
        _isConnected = false;
        _currentUserId = null;
        notifyListeners();
        debugPrint('🔴 Socket détruit et déconnexion complète');
      }
    }
  }
}
