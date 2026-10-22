import 'package:flutter/material.dart';
import 'product_mode1.dart';
import 'checkout_screen.dart';
import 'cart_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDarkMode ? const Color(0xFF111A35) : const Color(0xFFE8F5E9);
    final cardColor = isDarkMode ? const Color(0xFF1E2A4F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1B1B1B);
    final subTextColor = isDarkMode ? Colors.white54 : const Color(0xFF757575);
    final primaryDark = const Color(0xFF004D40);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: cardColor,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: cardColor,
              child: IconButton(
                icon: Icon(Icons.ios_share, color: textColor, size: 20),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: SizedBox(
              width: double.infinity,
              child: Hero(
                tag: 'product_${product.id}',
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(Icons.image, size: 100, color: subTextColor),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -10)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                            const SizedBox(height: 4),
                            Text(product.category, style: TextStyle(color: subTextColor, fontSize: 14)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Price', style: TextStyle(color: subTextColor, fontSize: 12)),
                          Text(product.price, style: TextStyle(color: primaryDark, fontSize: 22, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Description', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.green, size: 16),
                          const Icon(Icons.star, color: Colors.green, size: 16),
                          const Icon(Icons.star, color: Colors.green, size: 16),
                          const Icon(Icons.star, color: Colors.green, size: 16),
                          const Icon(Icons.star_border, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('(${product.rating})', style: TextStyle(color: subTextColor, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thiết bị IoT chất lượng cao. Hỗ trợ kết nối nhanh chóng, độ bền vượt trội, đáp ứng hoàn hảo cho các dự án nhà thông minh của bạn.',
                    style: TextStyle(color: subTextColor, fontSize: 13, height: 1.5),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // ================= NÚT THÊM VÀO GIỎ & MUA NGAY =================
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // 👇 CHUYỂN ĐỔI TỪ PRODUCT SANG CARTITEM
                          CartData.addToCart(
                            CartItem(
                              name: product.name,
                              price: product.price,
                              imageUrl: product.imageUrl,
                              icon: Icons.device_unknown,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã thêm ${product.name} vào giỏ!'),
                              backgroundColor: primaryDark,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: subTextColor.withValues(alpha: 0.2)),
                          ),
                          child: Icon(Icons.add_shopping_cart, color: textColor),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // 👇 SỬA LẠI ĐỂ TRUYỀN DANH SÁCH VÀ TỔNG TIỀN
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(
                                    cartItems: [
                                      CartItem(
                                        name: product.name,
                                        price: product.price,
                                        imageUrl: product.imageUrl,
                                        icon: Icons.device_unknown,
                                      )
                                    ],
                                    totalPrice: double.tryParse(product.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.flash_on, color: Colors.white),
                            label: const Text('Mua Ngay', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryDark,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}