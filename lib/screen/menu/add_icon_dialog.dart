import 'package:flutter/material.dart';

class AddIconDialog extends StatefulWidget {
  final Color cardColor;
  final Color bgColor;
  final Color textColor;
  final Color subColor;
  final Color accent;
  final Color highlight;
  final Function(IconData icon, String name) onAdd;

  // 👇 Nhận dữ liệu cũ (nếu đang Sửa)
  final String? initialName;
  final IconData? initialIcon;

  const AddIconDialog({
    super.key,
    required this.cardColor,
    required this.bgColor,
    required this.textColor,
    required this.subColor,
    required this.accent,
    required this.highlight,
    required this.onAdd,
    this.initialName,
    this.initialIcon,
  });

  @override
  State<AddIconDialog> createState() => _AddIconDialogState();
}

class _AddIconDialogState extends State<AddIconDialog> {
  late TextEditingController _nameCtrl;
  late IconData _selectedIcon;

  // Danh sách các icon có sẵn để chọn
  final List<IconData> _availableIcons = [
    Icons.sentiment_satisfied, Icons.favorite, Icons.wb_sunny,
    Icons.edit, Icons.stars, Icons.thumb_up,
    Icons.check_circle, Icons.notifications, Icons.settings,
    Icons.home, Icons.memory, Icons.eco, Icons.lightbulb, Icons.wifi,
  ];

  @override
  void initState() {
    super.initState();
    // Nếu có dữ liệu cũ thì điền vào, không thì để trống
    _nameCtrl = TextEditingController(text: widget.initialName ?? '');
    _selectedIcon = widget.initialIcon ?? _availableIcons[0];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing = widget.initialName != null;

    return AlertDialog(
      backgroundColor: widget.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(isEditing ? Icons.edit : Icons.widgets_outlined, color: widget.highlight),
          const SizedBox(width: 10),
          Text(isEditing ? 'Sửa Icon' : 'Thêm Icon Mới',
              style: TextStyle(
                  color: widget.textColor, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên Icon', style: TextStyle(color: widget.subColor, fontSize: 12)),
            const SizedBox(height: 6),
            TextField(
              controller: _nameCtrl,
              style: TextStyle(color: widget.textColor),
              decoration: InputDecoration(
                hintText: 'VD: Đèn ngủ',
                hintStyle: TextStyle(color: widget.subColor),
                filled: true,
                fillColor: widget.bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Chọn biểu tượng', style: TextStyle(color: widget.subColor, fontSize: 12)),
            const SizedBox(height: 10),

            // Lưới chọn Icon
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _availableIcons.map((icon) {
                bool isSelected = _selectedIcon == icon;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIcon = icon),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? widget.highlight : widget.bgColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? widget.highlight : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : widget.textColor,
                      size: 24,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy', style: TextStyle(color: widget.subColor)),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameCtrl.text.trim();
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng nhập tên icon')),
              );
              return;
            }
            // Trả về icon mới và tên mới
            widget.onAdd(_selectedIcon, name);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.highlight,
            foregroundColor: Colors.white,
          ),
          child: Text(isEditing ? 'Lưu' : 'Thêm'),
        ),
      ],
    );
  }
}