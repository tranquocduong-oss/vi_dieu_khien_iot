import 'package:flutter/material.dart';
import '../product_mode1.dart';

class AddProductDialog extends StatefulWidget {
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final Color primaryLight;

  // ✅ Thêm thuộc tính này để nhận sản phẩm cần sửa (nếu có)
  final Product? productToEdit;

  const AddProductDialog({
    super.key,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.primaryLight,
    this.productToEdit, // ✅ Cho phép truyền vào (không bắt buộc)
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _ratingCtrl = TextEditingController(text: '5.0');

  String _selectedCategory = ProductData.categories[1];

  @override
  void initState() {
    super.initState();
    // ✅ Nếu có dữ liệu truyền vào (đang Sửa), tự động điền vào form
    if (widget.productToEdit != null) {
      _nameCtrl.text = widget.productToEdit!.name;
      _priceCtrl.text = widget.productToEdit!.price;
      _imageCtrl.text = widget.productToEdit!.imageUrl;
      _ratingCtrl.text = widget.productToEdit!.rating.toString();
      _selectedCategory = widget.productToEdit!.category;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _imageCtrl.dispose();
    _ratingCtrl.dispose();
    super.dispose();
  }

  void _submitProduct() {
    if (!_formKey.currentState!.validate()) return;

    // ✅ Nếu đang sửa thì giữ nguyên ID cũ, nếu thêm mới thì tạo ID mới
    final id = widget.productToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

    final newProduct = Product(
      id: id,
      name: _nameCtrl.text.trim(),
      price: _priceCtrl.text.trim(),
      rating: double.tryParse(_ratingCtrl.text) ?? 5.0,
      category: _selectedCategory,
      imageUrl: _imageCtrl.text.trim().isEmpty
          ? 'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=500&auto=format&fit=crop'
          : _imageCtrl.text.trim(),
    );

    Navigator.pop(context, newProduct);
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem đang ở chế độ Thêm hay Sửa để đổi Text
    final isEditing = widget.productToEdit != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Container(
        decoration: BoxDecoration(
          color: widget.cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // === HEADER ===
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.primaryLight.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    // Đổi icon nếu là Sửa
                    child: Icon(
                        isEditing ? Icons.edit : Icons.add_box,
                        color: Colors.black,
                        size: 24
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Đổi tiêu đề nếu là Sửa
                          isEditing ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới',
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isEditing ? 'Cập nhật thông tin linh kiện' : 'Nhập thông tin linh kiện IoT',
                          style: TextStyle(color: widget.subTextColor, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: widget.subTextColor),
                  )
                ],
              ),
            ),

            // === BODY (FORM) ===
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameCtrl,
                        label: 'Tên sản phẩm',
                        hint: 'VD: Cảm biến nhiệt độ',
                        icon: Icons.devices_other,
                        validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _priceCtrl,
                              label: 'Giá bán',
                              hint: 'VD: 50.000đ',
                              icon: Icons.attach_money,
                              validator: (v) => v!.isEmpty ? 'Nhập giá' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _ratingCtrl,
                              label: 'Đánh giá',
                              hint: '1.0 - 5.0',
                              icon: Icons.star,
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final val = double.tryParse(v ?? '');
                                if (val == null || val < 0 || val > 5) {
                                  return 'Sai điểm';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _imageCtrl,
                        label: 'Link ảnh (URL)',
                        hint: 'Dán link ảnh sản phẩm...',
                        icon: Icons.image_outlined,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown danh mục
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        dropdownColor: widget.cardColor,
                        icon: Icon(Icons.arrow_drop_down, color: widget.subTextColor),
                        style: TextStyle(color: widget.textColor, fontSize: 14),
                        decoration: _inputDecoration(
                          label: 'Danh mục',
                          icon: Icons.category_outlined,
                        ),
                        items: ProductData.categories
                            .where((c) => c != 'Tất cả')
                            .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedCategory = value!);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // === FOOTER (BUTTONS) ===
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: widget.subTextColor.withValues(alpha: 0.3)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Hủy bỏ', style: TextStyle(color: widget.textColor)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submitProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.primaryLight,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        // Đổi chữ nếu là Sửa
                        isEditing ? 'Lưu thay đổi' : 'Lưu sản phẩm',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget phụ trợ tạo TextField với UI đẹp hơn
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: widget.textColor, fontSize: 14),
      decoration: _inputDecoration(label: label, hint: hint, icon: icon),
    );
  }

  // Hàm tạo viền và màu nền cho các ô nhập liệu
  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: TextStyle(color: widget.subTextColor.withValues(alpha: 0.5), fontSize: 13),
      labelStyle: TextStyle(color: widget.subTextColor, fontSize: 14),
      prefixIcon: Icon(icon, color: widget.subTextColor, size: 20),
      filled: true,
      fillColor: widget.subTextColor.withValues(alpha: 0.05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.subTextColor.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: widget.primaryLight, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }
}