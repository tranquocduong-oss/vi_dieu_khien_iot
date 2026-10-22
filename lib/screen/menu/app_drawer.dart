import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/phien_ban/notification_screen.dart';
import 'package:vi_dieu_khien_iot/san_pham/shop_screen.dart';
import 'package:vi_dieu_khien_iot/phien_ban/version_screen.dart';
import 'package:vi_dieu_khien_iot/phien_ban/update_screen.dart';

// ✅ ĐÃ XÓA HOÀN TOÀN DÒNG IMPORT drawer_actions.dart Ở ĐÂY

class AppDrawer extends StatelessWidget {
  final Color bgColor;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final Color accent;

  const AppDrawer({
    super.key,
    required this.bgColor,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'Mua sản phẩm',
        'sub': 'Xem sản phẩm mới nhất',
        'screen': const ShopScreen(),
      },
      {
        'icon': Icons.info_outline,
        'title': 'Phiên bản',
        'sub': 'v1.0.0',
        'screen': const VersionScreen(),
      },
      {
        'icon': Icons.system_update_alt,
        'title': 'Cập nhật',
        'sub': 'Kiểm tra bản mới',
        'screen': const UpdateScreen(),
      },
      {
        'icon': Icons.notifications_none,
        'title': 'Thông báo',
        'sub': '3 thông báo mới',
        'screen': const NotificationScreen(),
      },
    ];

    return Drawer(
      backgroundColor: bgColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER ===
            Container(
              padding: const EdgeInsets.all(20),
              color: accent,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.devices_other, color: bgColor, size: 40),
                  const SizedBox(height: 12),
                  Text('IoT Devices',
                      style: TextStyle(
                        color: bgColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      )),
                  const SizedBox(height: 4),
                  Text('Menu điều khiển',
                      style: TextStyle(
                          color: bgColor.withValues(alpha: 0.7),
                          fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // === DANH SÁCH MENU ===
            ...menuItems.map((item) => ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'] as IconData,
                    color: accent, size: 20),
              ),
              title: Text(item['title'] as String,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              subtitle: Text(item['sub'] as String,
                  style: TextStyle(color: subColor, fontSize: 12)),
              trailing: Icon(Icons.chevron_right, color: subColor),
              onTap: () {
                Navigator.pop(context); // Đóng drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => item['screen'] as Widget),
                );
              },
            )),

            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('© 2026 IoT Devices',
                  style: TextStyle(color: subColor, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// WIDGET TẠM (Có thể xóa nếu không dùng)
// ==========================================
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Màn hình $title đang được phát triển',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}