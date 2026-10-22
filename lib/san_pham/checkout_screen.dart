import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/thongtincanha/truong_thanh_phan/dia_chi_model.dart';
import 'cart_model.dart';
// 👇 Import file chứa dữ liệu địa chỉ
import 'package:vi_dieu_khien_iot/thongtincanha/my_orders_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.totalPrice,
  });

  Future<void> _placeOrder(BuildContext context, Color primaryDark) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đăng nhập để đặt hàng!')),
      );
      return;
    }

    try {
      // 👇 LẤY THÔNG TIN ĐỊA CHỈ MẶC ĐỊNH ĐÃ CHỌN
      final defaultAddress = DiaChiData.getMacDinh();

      // 1. Lưu đơn hàng lên Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'userEmail': user.email,

        // 👇 LƯU THÔNG TIN NGƯỜI NHẬN VÀO ĐÂY
        'receiverName': defaultAddress?.ten ?? 'Chưa cập nhật',
        'receiverPhone': defaultAddress?.soDienThoai ?? '',
        'receiverAddress': defaultAddress?.diaChiChiTiet ?? 'Chưa cập nhật',

        'items': cartItems.map((item) => {
          'name': item.name,
          'price': item.price,
          'imageUrl': item.imageUrl,
        }).toList(),
        'totalPrice': totalPrice,
        'orderDate': FieldValue.serverTimestamp(),
        'status': 'Đang xử lý',
      });

      // 2. Xóa sạch giỏ hàng
      CartData.items.clear();

      // 3. Chuyển sang trang Lịch sử đơn hàng
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Đặt hàng thành công!'),
            backgroundColor: primaryDark,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MyOrdersScreen(),
          ),
              (route) => route.isFirst,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi đặt hàng: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? const Color(0xFF111A35) : const Color(0xFFF3F9F7);
    final cardColor = isDarkMode ? const Color(0xFF1E2A4F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3142);
    final primaryDark = const Color(0xFF004D40);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Thanh toán', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sản phẩm (${cartItems.length})',
              style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: cartItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.name, style: TextStyle(color: textColor)),
                      Text(item.price, style: const TextStyle(color: Color(0xFFFF467A), fontWeight: FontWeight.bold)),
                    ],
                  ),
                )).toList(),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng cộng', style: TextStyle(color: textColor, fontSize: 18)),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFFFF467A), fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => _placeOrder(context, primaryDark),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Xác nhận Đặt hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}