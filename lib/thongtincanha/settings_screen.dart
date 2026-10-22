import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ✅ Import ThemeController
import '../data/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  // Đã bỏ isDarkMode và onToggleTheme
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pauseNotifications = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // ✅ Sử dụng ValueListenableBuilder để lắng nghe sự thay đổi
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDarkMode,
      builder: (context, isDark, child) {

        final Color bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF3F9F7);
        final Color cardColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
        final Color textColor = isDark ? Colors.white : const Color(0xFF2D3142);
        final Color subTextColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6C757D);
        final Color iconColor = isDark ? Colors.white70 : Colors.black54;
        final Color neonGreen = const Color(0xFFA9FF00);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: Container(
              margin: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              decoration: BoxDecoration(color: cardColor, shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: textColor, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            title: Text('Settings', style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 18)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // KHỐI THÔNG TIN USER
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: iconColor,
                        backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                        child: user?.photoURL == null ? Icon(Icons.person, color: bgColor) : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.displayName ?? 'Người dùng', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text('@${user?.email?.split('@')[0] ?? 'user'}', style: TextStyle(color: subTextColor, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: subTextColor),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // KHỐI 1
                Container(
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildSwitchTile('Pause notifications', Icons.notifications_off_outlined, _pauseNotifications, (val) => setState(() => _pauseNotifications = val), neonGreen, textColor, iconColor),
                      _buildDivider(isDark),
                      _buildArrowTile('General settings', Icons.tune, textColor, iconColor, subTextColor, () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // KHỐI 2
                Container(
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      // ✅ NÚT GẠT GỌI HÀM CỦA THEMECONTROLLER
                      _buildSwitchTile(
                        'Dark mode',
                        Icons.dark_mode_outlined,
                        isDark,
                            (val) => ThemeController.toggleTheme(),
                        neonGreen,
                        textColor,
                        iconColor,
                      ),
                      _buildDivider(isDark),
                      _buildArrowTile('Language', Icons.translate, textColor, iconColor, subTextColor, () {}),
                      _buildDivider(isDark),
                      _buildArrowTile('My Contact', Icons.contact_phone_outlined, textColor, iconColor, subTextColor, () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // KHỐI 3
                Container(
                  decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      _buildArrowTile('FAQ', Icons.help_outline, textColor, iconColor, subTextColor, () {}),
                      _buildDivider(isDark),
                      _buildArrowTile('Terms of service', Icons.info_outline, textColor, iconColor, subTextColor, () {}),
                      _buildDivider(isDark),
                      _buildArrowTile('User policy', Icons.privacy_tip_outlined, textColor, iconColor, subTextColor, () {}),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // NÚT ĐĂNG XUẤT
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    onPressed: () async => await FirebaseAuth.instance.signOut(),
                    icon: const Icon(Icons.logout, color: Color(0xFFD32F2F)),
                    label: const Text('Log Out', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: isDark ? 0 : 2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile(String title, IconData icon, bool value, Function(bool) onChanged, Color activeColor, Color textColor, Color iconColor) {
    return SwitchListTile(
      secondary: Icon(icon, color: iconColor, size: 22),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 15)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.black,
      activeTrackColor: activeColor,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: Colors.grey[600],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildArrowTile(String title, IconData icon, Color textColor, Color iconColor, Color subColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 15)),
      trailing: Icon(Icons.chevron_right, color: subColor, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
      height: 1,
      indent: 50,
      endIndent: 16,
    );
  }
}