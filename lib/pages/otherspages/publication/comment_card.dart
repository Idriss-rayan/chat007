import 'package:flutter/material.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _controller = TextEditingController();

  // Exemple de liste de commentaires
  final List<Map<String, String>> comments = [
    {
      "username": "Rayan",
      "comment": "Super post 👌",
      "timeAgo": "2h",
    },
    {
      "username": "Idriss",
      "comment": "Merci pour le partage 🙏",
      "timeAgo": "10m",
    },
  ];

  void _addComment() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      comments.add({
        "username": "Moi",
        "comment": _controller.text,
        "timeAgo": "à l’instant",
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commentaires")),
      body: Column(
        children: [
          // Liste des commentaires
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final c = comments[index];
                return CommentCard(
                  username: c["username"]!,
                  comment: c["comment"]!,
                  timeAgo: c["timeAgo"]!,
                );
              },
            ),
          ),

          // Champ d’écriture
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Écrire un commentaire...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.pink),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Ton widget existant
class CommentCard extends StatelessWidget {
  final String username;
  final String comment;
  final String timeAgo;
  final String? avatarUrl;

  const CommentCard({
    super.key,
    required this.username,
    required this.comment,
    required this.timeAgo,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child:
                avatarUrl == null ? const Icon(Icons.person, size: 20) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(username,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 8),
                    Text(timeAgo,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text("J'aime",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(width: 16),
                    Text("Répondre",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
