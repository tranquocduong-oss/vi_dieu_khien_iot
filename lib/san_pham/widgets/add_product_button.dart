import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';
import '../product_mode1.dart';
import 'add_product_dialog.dart';

class AddProductButton extends StatelessWidget {
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final Color primaryLight;
  final VoidCallback onProductAdded;

  const AddProductButton({
    super.key,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.primaryLight,
    required this.onProductAdded,
  });

  Future<void> _showAddProductDialog(BuildContext context) async {
    final newProduct = await showDialog<Product>(
      context: context,
      builder: (context) => AddProductDialog(
        cardColor: cardColor,
        textColor: textColor,
        subTextColor: subTextColor,
        primaryLight: primaryLight,
      ),
    );

    if (newProduct != null) {
      ProductData.products.add(newProduct);
      onProductAdded();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm ${newProduct.name} thành công!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddProductDialog(context),

      // 👇 ĐỔI MÀU NỀN THÀNH MÀU HỒNG
      backgroundColor: AppColors.pink,

      // 👇 ICON MÀU TRẮNG ĐỂ NỔI BẬT TRÊN NỀN HỒNG
      foregroundColor: Colors.white,

      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.add, size: 28),
    );
  }
}