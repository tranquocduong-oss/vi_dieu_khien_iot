import 'package:flutter/material.dart';

// 🛍️ Màn hình Mua sản phẩm
class BuyProductsScreen extends StatelessWidget {
  const BuyProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mua sản phẩm')),
      body: const Center(child: Text('Danh sách sản phẩm để mua')),
    );
  }
}

// ℹ️ Màn hình Phiên bản
class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phiên bản')),
      body: const Center(child: Text('Phiên bản v1.0.0')),
    );
  }
}

// 🔄 Màn hình Cập nhật
class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cập nhật')),
      body: const Center(child: Text('Kiểm tra bản mới...')),
    );
  }
}

// 🔔 Màn hình Thông báo
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications_active),
            title: Text('Cập nhật mới'),
            subtitle: Text('Có phiên bản mới v1.1.0'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_bag),
            title: Text('Đơn hàng'),
            subtitle: Text('Đơn hàng #123 đã gửi'),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Khuyến mãi'),
            subtitle: Text('Giảm 20% tất cả sản phẩm'),
          ),
        ],
      ),
    );
  }
}