import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:vi_dieu_khien_iot/thongtincanha/my_orders_screen.dart';
import 'package:vi_dieu_khien_iot/thongtincanha/personal_info_screen.dart';
import 'package:vi_dieu_khien_iot/thongtincanha/settings_screen.dart';
import 'package:vi_dieu_khien_iot/thongtincanha/shipping_address_screen.dart';
import 'package:vi_dieu_khien_iot/phien_ban/notification_screen.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';

class ProfileTab extends StatelessWidget {
  final bool isDarkMode;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final Color accent;
  final Color highlight;
  final VoidCallback onToggleTheme;

  const ProfileTab({
    super.key,
    required this.isDarkMode,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.accent,
    required this.highlight,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 👇 Sử dụng hệ màu mới
    final iconColor = isDarkMode ? AppColors.neonGreen : accent;
    final nameColor = isDarkMode ? AppColors.offWhite : textColor;
    final String? photoUrl = user?.photoURL;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ================= AVATAR =================
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cardColor,
              // Viền avatar màu hồng nổi bật
              border: Border.all(color: highlight, width: 3),
              image: photoUrl != null && photoUrl.isNotEmpty
                  ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: photoUrl == null || photoUrl.isEmpty
                ? Icon(Icons.person, size: 55, color: iconColor)
                : null,
          ),

          const SizedBox(height: 16),

          // Tên và Email
          Text(
            user?.displayName ?? 'Người dùng',
            style: TextStyle(color: nameColor, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(user?.email ?? 'Chưa có email', style: TextStyle(color: subColor, fontSize: 13)),
          const SizedBox(height: 30),

          // ================= CÁC NÚT MENU =================
          _item(
            context,
            icon: Icons.person_outline,
            title: 'Thông tin cá nhân',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PersonalInfoScreen(isDarkMode: isDarkMode),
                ),
              );
              (context as Element).markNeedsBuild();
            },
          ),
          _item(
            context,
            icon: Icons.shopping_bag_outlined,
            title: 'Đơn hàng của tôi',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
            ),
          ),
          _item(
            context,
            icon: Icons.location_on_outlined,
            title: 'Địa chỉ giao hàng',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ShippingAddressScreen()),
            ),
          ),
          _item(
            context,
            icon: Icons.notifications_none,
            title: 'Thông báo',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            ),
          ),
          _item(
            context,
            icon: Icons.settings_outlined,
            title: 'Cài đặt',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),

          const SizedBox(height: 20),

          // ================= NÚT ĐĂNG XUẤT =================
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: highlight, // Nền màu hồng
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        // Thêm viền mờ phát sáng cho các nút Menu
        border: Border.all(
          color: isDarkMode
              ? AppColors.neonGreen.withValues(alpha: 0.1)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: ListTile(
        // Icon của Menu dùng màu hồng (highlight) hoặc Neon
        leading: Icon(icon, color: highlight),
        title: Text(title, style: TextStyle(color: textColor, fontSize: 14)),
        trailing: Icon(Icons.chevron_right, color: textColor),
        onTap: onTap,
      ),
    );
  }
}