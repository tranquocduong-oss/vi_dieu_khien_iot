import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Color cardColor;
  final Color subColor;
  final Color highlight;
  final VoidCallback onAddPressed;
  final ValueChanged<String>? onChanged; // ✅ Nhận sự kiện gõ phím

  const CustomSearchBar({
    super.key,
    required this.cardColor,
    required this.subColor,
    required this.highlight,
    required this.onAddPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              onChanged: onChanged, // ✅ Gắn sự kiện vào TextField
              style: TextStyle(color: subColor, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Search plant, pots...',
                hintStyle: TextStyle(color: subColor, fontSize: 13),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: subColor, size: 20),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: onAddPressed,
          child: Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: highlight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }
}