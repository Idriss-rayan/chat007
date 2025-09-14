import 'package:flutter/material.dart';

class CommentField extends StatefulWidget {
  const CommentField({super.key});

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // pour validation

  void _sendComment() {
    if (_formKey.currentState!.validate()) {
      final comment = _controller.text.trim();
      if (comment.isNotEmpty) {
        // 🔹 Ici tu peux envoyer le commentaire à ton backend ou l’ajouter à la liste
        print("Commentaire envoyé : $comment");

        // Réinitialiser le champ
        _controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // 👤 Avatar de l'utilisateur
            const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person, size: 20),
            ),
            const SizedBox(width: 10),

            // 🔹 Champ de saisie comment
            Expanded(
              child: TextFormField(
                maxLines: null,
                controller: _controller,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Écrire un commentaire...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 12.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Le commentaire ne peut pas être vide";
                  }
                  return null;
                },
              ),
            ),

            // 🔹 Bouton envoyer
            IconButton(
              icon: const Icon(Icons.send, color: Colors.deepOrange),
              onPressed: _sendComment,
            ),
          ],
        ),
      ),
    );
  }
}
