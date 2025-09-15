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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
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
