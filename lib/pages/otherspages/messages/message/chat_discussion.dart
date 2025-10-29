import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplechat/pages/otherspages/messages/message/service_socket.dart';

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

  @override
  void initState() {
    super.initState();

    // ✅ Détecte si l’utilisateur tape du texte
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });

    // ✅ Connecte le socket au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Récupérer d'abord l'userID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      final String? token = prefs.getString('jwt_token');
      final socketService = context.read<SocketService>();
      socketService.connect(userId!, token!);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ✅ Envoi de message privé
  void _sendMessage(SocketService socketService, int contactId, int userId) {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    // Envoie le message avec le contactId
    socketService.sendPrivateMessage(message, contactId, userId);
    print(
      'ici le id du contact est ${contactId} et le id du user est ${userId}',
    );

    // Réinitialise le champ
    _controller.clear();
    setState(() => _isTyping = false);
  }

  // ✅ Envoi d’une image depuis la caméra
  Future<void> _sendImage(SocketService socketService) async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Tu pourras plus tard émettre l’image via socket
      socketService.addLocalMessage("[Image envoyée]");
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

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketService>(
      builder: (context, socketService, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(15, 220, 54, 3),
            title: Row(
              children: [
                SvgPicture.asset('assets/component/avatar.svg',
                    width: 40, height: 40),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.contactName,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(
                      "en ligne",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // ✅ Liste des messages
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  reverse: true,
                  itemCount: socketService.messages.length,
                  itemBuilder: (context, index) {
                    final msg = socketService.messages.reversed.toList()[index];
                    final isMe = msg["isMe"] ?? false;
                    final text = msg["text"] ?? "";
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color.fromARGB(69, 247, 95, 7)
                              : Colors.pink[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(text),
                      ),
                    );
                  },
                ),
              ),

              // ✅ Zone de saisie
              SafeArea(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      color: Colors.white,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.emoji_emotions,
                                color: Colors.grey),
                            onPressed: _toggleEmojiPicker,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText: "Message",
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                if (_showEmojiPicker) {
                                  setState(() => _showEmojiPicker = false);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.grey),
                            onPressed: () => _sendImage(socketService),
                          ),
                          if (_isTyping)
                            IconButton(
                              icon:
                                  const Icon(Icons.send, color: Colors.orange),
                              onPressed: () => _sendMessage(
                                socketService,
                                widget.contactId,
                                widget.userId,
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
                            emojiViewConfig:
                                const EmojiViewConfig(emojiSizeMax: 28.0),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
