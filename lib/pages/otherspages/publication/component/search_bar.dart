import 'package:flutter/material.dart';

class SearchBarCostum extends StatelessWidget {
  final VoidCallback? onClose;

  const SearchBarCostum({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.deepOrange),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // 🔍 Bouton recherche
          IconButton(
            icon: const Icon(Icons.search, color: Colors.deepOrange),
            onPressed: () {
              // tu peux lancer la recherche ici si tu veux
              debugPrint("Recherche lancée...");
            },
          ),

          // Champ texte
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // ❌ Bouton fermer
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.deepOrange),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}
