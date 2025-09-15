import 'package:flutter/material.dart';

class CommentField extends StatefulWidget {
  const CommentField({super.key});

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // pour validation
  bool isTyped = false; // true = du texte présent
  bool isVisible = true; // true = icône "visibility", false = "visibility_off"

  void _sendComment() {
    if (_formKey.currentState!.validate()) {
      final comment = _controller.text.trim();
      if (comment.isNotEmpty) {
        print("Commentaire envoyé : $comment");

        // Réinitialiser le champ et l’état
        _controller.clear();
        setState(() {
          isTyped = false;
          isVisible = true; // remettre par défaut
        });
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
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    isTyped = value.trim().isNotEmpty;
                  });
                },
                maxLines: null,
                controller: _controller,
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Écrire un commentaire...",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(30, 255, 224, 178),
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

            // Bouton envoyer
            IconButton(
              icon: const Icon(Icons.send, color: Colors.red),
              onPressed: _sendComment,
            ),

            // Toggle visibilité seulement si texte présent
            isTyped
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = !isVisible; // inverse l’état
                      });
                    },
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.deepOrange,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
