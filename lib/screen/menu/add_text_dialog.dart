import 'package:flutter/material.dart';

class AddTextDialog extends StatefulWidget {
  final Color cardColor;
  final Color bgColor;
  final Color textColor;
  final Color subColor;
  final Color accent;
  final Color highlight;

  // 👇 Thêm 2 biến này để nhận dữ liệu cũ khi sửa
  final String? initialText;
  final String? initialImageUrl;

  // Trả về text và imageUrl
  final Function(String text, String imageUrl) onAdd;

  const AddTextDialog({
    super.key,
    required this.cardColor,
    required this.bgColor,
    required this.textColor,
    required this.subColor,
    required this.accent,
    required this.highlight,
    required this.onAdd,
    this.initialText, // Tùy chọn
    this.initialImageUrl, // Tùy chọn
  });

  @override
  State<AddTextDialog> createState() => _AddTextDialogState();
}

class _AddTextDialogState extends State<AddTextDialog> {
  late TextEditingController _textCtrl;
  late TextEditingController _imageUrlCtrl;

  @override
  void initState() {
    super.initState();
    // Nếu có dữ liệu cũ truyền vào thì điền sẵn, không thì để trống
    _textCtrl = TextEditingController(text: widget.initialText ?? '');
    _imageUrlCtrl = TextEditingController(text: widget.initialImageUrl ?? '');
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _imageUrlCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Nếu có initialText thì tiêu đề là "Sửa", ngược lại là "Thêm"
    bool isEditing = widget.initialText != null;

    return AlertDialog(
      backgroundColor: widget.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Icon(isEditing ? Icons.edit : Icons.text_fields, color: widget.highlight),
          const SizedBox(width: 10),
          Text(isEditing ? 'Chỉnh Sửa Text' : 'Thêm Text Mới',
              style: TextStyle(
                  color: widget.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nội dung text (Bắt buộc)',
                style: TextStyle(color: widget.subColor, fontSize: 12)),
            const SizedBox(height: 6),
            TextField(
              controller: _textCtrl,
              autofocus: true,
              maxLines: 2,
              style: TextStyle(color: widget.textColor),
              decoration: InputDecoration(
                hintText: 'VD: Smart Home Control',
                hintStyle: TextStyle(color: widget.subColor),
                filled: true,
                fillColor: widget.bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text('Link ảnh đại diện (Tùy chọn)',
                style: TextStyle(color: widget.subColor, fontSize: 12)),
            const SizedBox(height: 6),
            TextField(
              controller: _imageUrlCtrl,
              style: TextStyle(color: widget.textColor),
              decoration: InputDecoration(
                hintText: 'Dán link ảnh (https://...)',
                hintStyle: TextStyle(color: widget.subColor),
                prefixIcon: Icon(Icons.image, color: widget.subColor, size: 20),
                filled: true,
                fillColor: widget.bgColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            setState(() {
              _textCtrl.clear();
              _imageUrlCtrl.clear();
            });
          },
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
          label: const Text('Xóa', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Hủy', style: TextStyle(color: widget.subColor)),
        ),
        ElevatedButton.icon(
          onPressed: () {
            final text = _textCtrl.text.trim();
            final imageUrl = _imageUrlCtrl.text.trim();

            if (text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vui lòng nhập text')),
              );
              return;
            }
            widget.onAdd(text, imageUrl);
            Navigator.pop(context);
          },
          icon: Icon(isEditing ? Icons.save : Icons.add, size: 16),
          label: Text(isEditing ? 'Lưu' : 'Thêm'),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.highlight,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}