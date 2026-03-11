import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/pages/otherspages/messages/message/service_socket.dart';
import 'package:http/http.dart' as http;

class ChatDiscussion extends StatefulWidget {
  final int userId;
  final int contactId;
  final String contactName;

  const ChatDiscussion({
    super.key,
    required this.userId,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<ChatDiscussion> createState() => _ChatDiscussionState();
}

class _ChatDiscussionState extends State<ChatDiscussion> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  bool _isTyping = false;
  bool _showEmojiPicker = false;
  bool _isLoadingMessages = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeChat();
      // Écouter les nouveaux messages pour scroller automatiquement
      final socketService = context.read<SocketService>();
      socketService.addListener(_onNewMessage);
    });
  }

  void _onNewMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _initializeChat() async {
    final socketService = context.read<SocketService>();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('user_id');
    final String? token = prefs.getString('jwt_token');

    if (userId == null) {
      debugPrint('❌ User ID non trouvé');
      setState(() => _isLoadingMessages = false);
      return;
    }

    // 1. Charger l'historique des messages
    setState(() => _isLoadingMessages = true);
    await socketService.loadMessageHistory(userId, widget.contactId);
    setState(() => _isLoadingMessages = false);

    // 2. S'assurer que le socket est connecté
    if (!socketService.isConnected) {
      socketService.connect(userId, token!);
    }

    // 3. Faire défiler vers le bas après le chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    // Retirer le listener pour éviter les memory leaks
    final socketService = context.read<SocketService>();
    socketService.removeListener(_onNewMessage);
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ✅ Envoi de message privé
  void _sendMessage(SocketService socketService, int contactId, int userId) {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    socketService.sendPrivateMessage(message, contactId, userId);
    _controller.clear();
    setState(() => _isTyping = false);

    // Faire défiler vers le bas après l'envoi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  // ✅ Envoi d'une image depuis la caméra
  Future<void> _sendImage(SocketService socketService) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      //socketService.addLocalMessage("[Image envoyée]");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _toggleEmojiPicker() {
    if (_showEmojiPicker) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
    setState(() => _showEmojiPicker = !_showEmojiPicker);
  }

  // ✅ Méthode pour obtenir les messages de cette conversation spécifique
  List<Map<String, dynamic>> _getCurrentChatMessages(
      SocketService socketService) {
    final allMessages = socketService.messages;
    final List<Map<String, dynamic>> chatMessages = [];

    for (final msg in allMessages) {
      final from = msg["from"];
      final to = msg["to"];
      final isMe = msg["isMe"] ?? false;

      // Messages que j'ai envoyés à ce contact
      if (isMe && to == widget.contactId) {
        chatMessages.add(msg);
      }
      // Messages que j'ai reçus de ce contact
      else if (!isMe && from == widget.contactId) {
        chatMessages.add(msg);
      }
    }

    // Trier par timestamp
    chatMessages.sort((a, b) {
      final timeA = a["timestamp"] != null
          ? DateTime.parse(a["timestamp"]).millisecondsSinceEpoch
          : 0;
      final timeB = b["timestamp"] != null
          ? DateTime.parse(b["timestamp"]).millisecondsSinceEpoch
          : 0;
      return timeA.compareTo(timeB);
    });

    return chatMessages;
  }

  String _formatTime(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '';
    }
  }

  String _formatDate(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(date.year, date.month, date.day);

      if (messageDate == today) {
        return 'Aujourd\'hui';
      } else if (messageDate == today.subtract(const Duration(days: 1))) {
        return 'Hier';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return '';
    }
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg, bool isMe) {
    final text = msg["text"] ?? "";
    final timestamp = msg["timestamp"];
    final status = msg["status"];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe
                    ? const Color.fromARGB(255, 247, 95, 7)
                    : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (isMe && status != null) ...[
                        const SizedBox(width: 4),
                        Icon(
                          status == 'sending'
                              ? Icons.access_time
                              : Icons.done_all,
                          size: 12,
                          color: isMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(String date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMessageList(SocketService socketService) {
    final currentChatMessages = _getCurrentChatMessages(socketService);

    if (currentChatMessages.isEmpty && !_isLoadingMessages) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun message',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Envoyez votre premier message à ${widget.contactName}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Grouper les messages par date
    final Map<String, List<Map<String, dynamic>>> groupedMessages = {};
    for (final msg in currentChatMessages) {
      final timestamp = msg["timestamp"];
      final date = _formatDate(timestamp);
      if (!groupedMessages.containsKey(date)) {
        groupedMessages[date] = [];
      }
      groupedMessages[date]!.add(msg);
    }

    final dates = groupedMessages.keys.toList()
      ..sort((a, b) {
        // Trier les dates : les plus anciennes d'abord, Aujourd'hui en dernier
        if (a == 'Aujourd\'hui') return 1;
        if (b == 'Aujourd\'hui') return -1;
        if (a == 'Hier') return 1;
        if (b == 'Hier') return -1;
        return b.compareTo(a); // dates normales : plus récent en dernier
      });

    // ✅ CORRECTION : Calcul du nombre total d'items
    int totalItemCount = 0;
    for (final date in dates) {
      totalItemCount += (groupedMessages[date]?.length ?? 0) + 1;
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      reverse: true,
      itemCount: totalItemCount,
      itemBuilder: (context, index) {
        // Calculer l'index réel en tenant compte des séparateurs de date
        int tempIndex = index;
        String? currentDate;
        int messageIndex = 0;

        for (final date in dates) {
          final messagesCount = groupedMessages[date]?.length ?? 0;

          // Vérifier si c'est un séparateur de date
          if (tempIndex == 0) {
            currentDate = date;
            messageIndex = -1; // Indique que c'est un séparateur
            break;
          }
          tempIndex--;

          // Vérifier si c'est un message dans cette date
          if (tempIndex < messagesCount) {
            currentDate = date;
            messageIndex = tempIndex;
            break;
          }
          tempIndex -= messagesCount;
        }

        if (currentDate != null) {
          final messages = groupedMessages[currentDate] ?? [];

          if (messageIndex == -1) {
            // Afficher le séparateur de date
            return _buildDateSeparator(currentDate);
          } else if (messageIndex < messages.length) {
            // Afficher le message
            final msg = messages.reversed.toList()[messageIndex];
            final isMe = msg["isMe"] ?? false;
            return _buildMessageBubble(msg, isMe);
          }
        }

        // Fallback au cas où
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInputArea(SocketService socketService) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleEmojiPicker,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Écrivez un message...",
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      filled: true,
                      fillColor: Colors.grey[100],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.orange[300]!),
                      ),
                    ),
                    onTap: () {
                      if (_showEmojiPicker) {
                        setState(() => _showEmojiPicker = false);
                      }
                    },
                    onSubmitted: (_) {
                      if (_isTyping) {
                        _sendMessage(
                            socketService, widget.contactId, widget.userId);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.grey),
                  onPressed: () => _sendImage(socketService),
                ),
                const SizedBox(width: 4),
                Container(
                  decoration: BoxDecoration(
                    color: _isTyping ? Colors.orange : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: _isTyping ? Colors.white : Colors.grey[600],
                    ),
                    onPressed: _isTyping
                        ? () => _sendMessage(
                            socketService, widget.contactId, widget.userId)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          if (_showEmojiPicker)
            SizedBox(
              height: 300,
              child: EmojiPicker(
                textEditingController: _controller,
                config: Config(
                  height: 250,
                  emojiViewConfig: const EmojiViewConfig(
                    emojiSizeMax: 28.0,
                    columns: 7,
                  ),
                  categoryViewConfig: const CategoryViewConfig(
                    iconColor: Colors.orange,
                    iconColorSelected: Colors.deepOrange,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 247, 95, 7),
            foregroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      widget.contactName.isNotEmpty
                          ? widget.contactName[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 247, 95, 7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.contactName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        socketService.isConnected ? "En ligne" : "Hors ligne",
                        style: TextStyle(
                          fontSize: 12,
                          color: socketService.isConnected
                              ? Colors.green[100]
                              : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {
                  // Action d'appel
                },
              ),
              IconButton(
                icon: const Icon(Icons.videocam),
                onPressed: () {
                  // Action vidéo
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'info':
                      // Action informations
                      break;
                    case 'clear':
                      // Action vider la conversation
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<String>(
                    value: 'info',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 8),
                        Text('Informations'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'clear',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 8),
                        Text('Effacer la conversation'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              // Liste des messages
              Expanded(
                child: _isLoadingMessages
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color.fromARGB(255, 247, 95, 7),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Chargement des messages...',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildMessageList(socketService),
              ),

              // Zone de saisie
              _buildInputArea(socketService),
            ],
          ),
        );
      },
    );
  }
}
