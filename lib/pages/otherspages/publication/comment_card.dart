import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final String username;
  final String comment;
  final String timeAgo;
  final String? avatarUrl; // optionnel

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
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child:
                avatarUrl == null ? const Icon(Icons.person, size: 20) : null,
          ),
          const SizedBox(width: 12),

          // Texte du commentaire
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom + Temps
                Row(
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Contenu du commentaire
                Text(
                  comment,
                  style: const TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 6),

                // Boutons d’action (like, reply, etc.)
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      "J'aime",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "Répondre",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
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
