import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simplechat/pages/otherspages/messages/calls/page_calls.dart';
import 'package:simplechat/pages/otherspages/messages/message/components/attach.dart';
import 'package:simplechat/pages/otherspages/messages/message/components/audio_msg.dart';
import 'package:simplechat/pages/otherspages/messages/message/components/voice.dart';

class ChatDiscussion extends StatefulWidget {
  const ChatDiscussion({super.key});
  @override
  State<ChatDiscussion> createState() => _ChatDiscussionState();
}

class _ChatDiscussionState extends State<ChatDiscussion> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _showEmojiPicker = false;
  final List<Map<String, dynamic>> _messages = [];
  String? _previewAudioPath;
  int? _previewAudioDuration;
  bool _showPreviewModal = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTyping = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({"text": text, "isMe": true});
      _controller.clear();
      _isTyping = false;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({"text": "Réponse automatique", "isMe": false});
      });
    });
  }

  void _toggleEmojiPicker() {
    if (_showEmojiPicker) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });
  }

  void _handleRecordedAudio(String path, int duration) {
    debugPrint("🎤 Audio envoyé: $path");
    debugPrint("⏱️ Durée: $duration secondes");

    setState(() {
      _messages.add({
        "audio": path,
        "duration": duration,
        "isMe": true,
      });
      _previewAudioPath = null;
      _previewAudioDuration = null;
    });

    // Réponse automatique simulée
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _messages.add({
          "text": "J'ai bien reçu ton message audio !",
          "isMe": false,
        });
      });
    });
  }

  void _handleAudioPreview(String path, int duration) {
    debugPrint("🎧 Prévisualisation audio: $path");
    debugPrint("⏱️ Durée: $duration secondes");

    setState(() {
      _previewAudioPath = path;
      _previewAudioDuration = duration;
    });

    // Afficher la modal de prévisualisation automatiquement
    _showAudioPreviewModal();
  }

  void _showAudioPreviewModal() {
    if (_previewAudioPath == null || _previewAudioDuration == null) return;

    setState(() {
      _showPreviewModal = true;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPreviewModal(),
    ).then((_) {
      setState(() {
        _showPreviewModal = false;
      });
    });
  }

  Widget _buildPreviewModal() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Prévisualisation audio",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Visualisation audio stylée
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.audiotrack,
                  size: 50,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                Text(
                  "Durée: ${_formatDuration(_previewAudioDuration ?? 0)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Lecteur audio de prévisualisation
                if (_previewAudioPath != null && _previewAudioDuration != null)
                  AudioMsg(
                    path: _previewAudioPath!,
                    duration: _previewAudioDuration!,
                    color: Colors.blue,
                    height: 8,
                  ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Boutons d'action
          Row(
            children: [
              // Bouton Annuler
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _previewAudioPath = null;
                      _previewAudioDuration = null;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Audio supprimé"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(width: 8),
                      Text("Supprimer"),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Bouton Envoyer
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (_previewAudioPath != null &&
                        _previewAudioDuration != null) {
                      _handleRecordedAudio(
                          _previewAudioPath!, _previewAudioDuration!);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Audio envoyé !"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.send),
                      SizedBox(width: 8),
                      Text("Envoyer"),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
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
              children: const [
                Text("John Doe",
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
                Text("en ligne",
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black54),
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFB88C), // orange doux
                            Color(0xFFFF6F91), // rose doux
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.call,
                            color: Colors.white,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Appel vers Rayan",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Tu es sur le point d'appeler Rayan. Veux-tu continuer ?",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Ligne de boutons Oui / Fermer
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Bouton Oui
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // fermer le dialog
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          const PageCalls(
                                        name: 'rayan',
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(0.0, 0.2),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Continuer"),
                              ),

                              // Bouton Fermer
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text("Fermer"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black54),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[_messages.length - 1 - index];
                    return Align(
                      alignment: msg["isMe"]
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7),
                        decoration: BoxDecoration(
                          color: msg["isMe"]
                              ? const Color.fromARGB(69, 247, 95, 7)
                              : Colors.pink[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: msg.containsKey("image")
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  msg["image"],
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 150,
                                ),
                              )
                            : msg.containsKey("audio")
                                ? AudioMsg(
                                    path: msg["audio"],
                                    duration: msg["duration"] ?? 0,
                                  )
                                : Text(msg["text"] ?? ""),
                      ),
                    );
                  },
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    // Indicateur de prévisualisation audio
                    if (_previewAudioPath != null && !_showPreviewModal)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        color: Colors.blue[50],
                        child: Row(
                          children: [
                            const Icon(Icons.audiotrack,
                                color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              "Audio en attente (${_formatDuration(_previewAudioDuration ?? 0)})",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: _showAudioPreviewModal,
                              child: const Text(
                                "Écouter",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _previewAudioPath = null;
                                  _previewAudioDuration = null;
                                });
                              },
                              icon: const Icon(Icons.close, size: 16),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
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
                              keyboardType: TextInputType.multiline,
                              controller: _controller,
                              focusNode: _focusNode,
                              minLines: 1,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                  hintText: "Message",
                                  border: InputBorder.none),
                              onTap: () {
                                if (_showEmojiPicker) {
                                  setState(() => _showEmojiPicker = false);
                                }
                              },
                            ),
                          ),
                          const Attach(),
                          IconButton(
                            icon: const Icon(Icons.camera_alt,
                                color: Colors.grey),
                            onPressed: () async {
                              // Ouvre la caméra
                              final XFile? photo = await _picker.pickImage(
                                  source: ImageSource.camera);

                              if (photo != null) {
                                // Ajoute l'image à la liste des messages
                                setState(() {
                                  _messages.add({
                                    "image": File(photo.path),
                                    "isMe": true,
                                  });
                                });
                              }
                            },
                          ),
                          _isTyping
                              ? IconButton(
                                  icon: const Icon(Icons.send,
                                      color: Colors.orange),
                                  onPressed: _sendMessage)
                              : Voice(
                                  onRecorded: _handleRecordedAudio,
                                  onPreview: _handleAudioPreview,
                                ),
                        ],
                      ),
                    ),
                    if (_showEmojiPicker)
                      SizedBox(
                        height: 250,
                        child: EmojiPicker(
                          textEditingController: _controller,
                          config: Config(
                            height: 250,
                            checkPlatformCompatibility: true,
                            emojiViewConfig:
                                const EmojiViewConfig(emojiSizeMax: 28.0),
                            viewOrderConfig: const ViewOrderConfig(),
                            skinToneConfig: const SkinToneConfig(),
                            categoryViewConfig: const CategoryViewConfig(),
                            bottomActionBarConfig:
                                const BottomActionBarConfig(),
                            searchViewConfig: const SearchViewConfig(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
