import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';
import 'cart_model.dart';
// 👇 Import màn hình CheckoutScreen
import 'package:vi_dieu_khien_iot/san_pham/checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;
    final cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;
    final subColor = isDarkMode ? AppColors.greenLight.withValues(alpha: 0.6) : Colors.grey[600]!;
    final primaryLight = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;

    // Tính tổng tiền
    double totalPrice = 0;
    for (var item in CartData.items) {
      String priceStr = item.price.replaceAll(RegExp(r'[^0-9.]'), '');
      totalPrice += double.tryParse(priceStr) ?? 0;
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Giỏ hàng', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: CartData.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: subColor),
            const SizedBox(height: 16),
            Text('Giỏ hàng của bạn đang trống', style: TextStyle(color: subColor, fontSize: 16)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        itemCount: CartData.items.length,
        itemBuilder: (context, index) {
          final product = CartData.items[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.image, size: 80),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(product.price, style: TextStyle(color: primaryLight, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      CartData.removeFromCart(product);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      // Nút Thanh Toán dưới cùng
      bottomNavigationBar: CartData.items.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tổng cộng', style: TextStyle(color: subColor, fontSize: 14)),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ElevatedButton(
                // 👇 CHUYỂN SANG TRANG XÁC NHẬN (CHECKOUT)
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                        cartItems: CartData.items,
                        totalPrice: totalPrice,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pink,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Thanh toán', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}