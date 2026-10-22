import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  // 🗑️ Hàm xử lý Hủy đơn
  void _cancelOrder(BuildContext context, String orderId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Không', style: TextStyle(color: Colors.grey))),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hủy đơn', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
    }
  }

  // ✏️ Hàm xử lý Sửa thông tin
  void _editOrderInfo(BuildContext context, String orderId, Map<String, dynamic> orderData) {
    final nameCtrl = TextEditingController(text: orderData['receiverName'] ?? '');
    final phoneCtrl = TextEditingController(text: orderData['receiverPhone'] ?? '');
    final addressCtrl = TextEditingController(text: orderData['receiverAddress'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sửa thông tin nhận hàng'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Tên người nhận'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty || phoneCtrl.text.isEmpty || addressCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập đủ thông tin!'), backgroundColor: Colors.red),
                );
                return;
              }

              // Cập nhật lên Firebase
              await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
                'receiverName': nameCtrl.text.trim(),
                'receiverPhone': phoneCtrl.text.trim(),
                'receiverAddress': addressCtrl.text.trim(),
              });

              if (context.mounted) {
                Navigator.pop(context); // Đóng dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật thông tin thành công!'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('Lưu thay đổi', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? const Color(0xFF111A35) : const Color(0xFFF3F9F7);
    final cardColor = isDarkMode ? const Color(0xFF1E2A4F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3142);
    final subColor = isDarkMode ? Colors.white54 : const Color(0xFF6C757D);

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Đơn hàng của tôi', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Bạn chưa có đơn hàng nào', style: TextStyle(color: subColor)));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDoc = orders[index];
              final orderData = orderDoc.data() as Map<String, dynamic>;
              final items = orderData['items'] as List<dynamic>;
              final status = orderData['status'] ?? 'Đang xử lý';
              final orderId = orderDoc.id.substring(0, 6).toUpperCase();

              final name = orderData['receiverName'] ?? 'Chưa cập nhật';
              final phone = orderData['receiverPhone'] ?? '';
              final address = orderData['receiverAddress'] ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mã đơn & Các nút thao tác
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Mã đơn: #$orderId', style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: status == 'Đang xử lý' ? Colors.orange.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(status, style: TextStyle(color: status == 'Đang xử lý' ? Colors.orange : Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            // Chỉ hiện nút Sửa và Hủy khi đơn đang xử lý
                            if (status == 'Đang xử lý') ...[
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                                onPressed: () => _editOrderInfo(context, orderDoc.id, orderData),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                onPressed: () => _cancelOrder(context, orderDoc.id),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    // Thông tin người nhận
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: subColor, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$name | $phone', style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(address, style: TextStyle(color: subColor, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Danh sách sản phẩm
                    ...items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(child: Text(item['name'] ?? '', style: TextStyle(color: subColor))),
                          Text(item['price'] ?? '', style: TextStyle(color: subColor)),
                        ],
                      ),
                    )),

                    const Divider(height: 24),

                    // Tổng tiền
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng cộng', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                        Text('\$${(orderData['totalPrice'] as num).toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFFFF467A), fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}