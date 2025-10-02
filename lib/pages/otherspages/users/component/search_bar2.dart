import 'package:flutter/material.dart';

class SearchBar2 extends StatelessWidget {
  final VoidCallback onClose;
  final ValueChanged<String>? onChanged;

  const SearchBar2({
    super.key,
    required this.onClose,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 22),
          const SizedBox(width: 8),

          // Champ texte qui prend tout l’espace
          Expanded(
            child: TextField(
              onChanged: onChanged,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),

          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, color: Colors.grey, size: 20),
          ),
        ],
      ),
    );
  }
}
