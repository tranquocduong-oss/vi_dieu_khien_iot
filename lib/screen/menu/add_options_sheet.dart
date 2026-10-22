import 'package:flutter/material.dart';
import 'add_icon_dialog.dart';
import 'add_text_dialog.dart';

class AddOptionsSheet extends StatelessWidget {
  final Color cardColor;
  final Color bgColor;
  final Color textColor;
  final Color subColor;
  final Color accent;
  final Color highlight;
  final Function(IconData icon, String name) onAddIcon;
  final Function(String text, String imageUrl) onAddText;

  // Dữ liệu cho Icon (Sửa)
  final String? initialIconName;
  final IconData? initialIconData;

  // Dữ liệu cho Text (Sửa)
  final String? initialText;
  final String? initialImageUrl;

  const AddOptionsSheet({
    super.key,
    required this.cardColor,
    required this.bgColor,
    required this.textColor,
    required this.subColor,
    required this.accent,
    required this.highlight,
    required this.onAddIcon,
    required this.onAddText,
    this.initialText,
    this.initialImageUrl,
    this.initialIconName,
    this.initialIconData,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: subColor.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text('Bạn muốn thêm gì?',
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _optionCard(
                    icon: Icons.widgets_outlined,
                    title: initialIconName != null ? 'Sửa Icon' : 'Add Icon',
                    sub: 'Thêm hình + tên',
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => AddIconDialog(
                          cardColor: cardColor,
                          bgColor: bgColor,
                          textColor: textColor,
                          subColor: subColor,
                          accent: accent,
                          highlight: highlight,
                          onAdd: onAddIcon,
                          initialName: initialIconName,
                          initialIcon: initialIconData,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _optionCard(
                    icon: Icons.description_outlined,
                    title: initialText != null ? 'Sửa Text' : 'Add Text',
                    sub: 'Thêm nội dung text',
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (_) => AddTextDialog(
                          cardColor: cardColor,
                          bgColor: bgColor,
                          textColor: textColor,
                          subColor: subColor,
                          accent: accent,
                          highlight: highlight,
                          onAdd: (text, imageUrl) {
                            onAddText(text, imageUrl);
                          },
                          initialText: initialText,
                          initialImageUrl: initialImageUrl,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _optionCard({
    required IconData icon,
    required String title,
    required String sub,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: highlight.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: highlight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(sub,
                style: TextStyle(color: subColor, fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}