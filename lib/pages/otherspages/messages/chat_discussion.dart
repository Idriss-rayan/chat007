import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class ChatDiscussion extends StatefulWidget {
  const ChatDiscussion({super.key});
  @override
  State<ChatDiscussion> createState() => _ChatDiscussionState();
}

class _ChatDiscussionState extends State<ChatDiscussion> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isTyping = false;
  bool _showEmojiPicker = false;
  final List<Map<String, dynamic>> _messages = [];

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
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.videocam, color: Colors.black54),
              onPressed: () {}),
        ],
      ),
      body: Column(
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
                    child: Text(msg["text"]),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                              hintText: "Message", border: InputBorder.none),
                          onTap: () {
                            if (_showEmojiPicker) {
                              setState(() => _showEmojiPicker = false);
                            }
                          },
                        ),
                      ),
                      IconButton(
                          icon:
                              const Icon(Icons.attach_file, color: Colors.grey),
                          onPressed: () {}),
                      IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.grey),
                          onPressed: () {}),
                      _isTyping
                          ? IconButton(
                              icon:
                                  const Icon(Icons.send, color: Colors.orange),
                              onPressed: _sendMessage)
                          : IconButton(
                              icon: const Icon(Icons.mic, color: Colors.orange),
                              onPressed: () {}),
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
                        bottomActionBarConfig: const BottomActionBarConfig(),
                        searchViewConfig: const SearchViewConfig(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
