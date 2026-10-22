import 'package:flutter/material.dart';

class VersionScreen extends StatelessWidget {
  const VersionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Bảng màu từ ảnh Color Palette
    final Color coralRed = const Color(0xFFDE7272);
    final Color lightOrange = const Color(0xFFFFCA88);
    final Color lightYellow = const Color(0xFFFFF6A9);
    final Color mintGreen = const Color(0xFFB4E4D6);

    // Giao diện PASTEL (NỀN SÁNG)
    final Color bgColor = const Color(0xFFF3F9F7);
    final Color cardColor = Colors.white;
    final Color textColor = const Color(0xFF2D3142);
    final Color subTextColor = const Color(0xFF6C757D);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Thông tin ứng dụng',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Giảm padding hai bên để ảnh chữ nhật trông rộng rãi hơn
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // ==========================================
            // 1. HÌNH ẢNH APP (ĐÃ ĐỔI THÀNH HÌNH CHỮ NHẬT EXPAND)
            // ==========================================
            Container(
              width: double.infinity, // ✅ Tràn hết chiều ngang màn hình
              height: 200, // ✅ Chiều cao của bức ảnh (bạn có thể tăng giảm tùy ý)
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Bo góc nhẹ giống ảnh bìa
                boxShadow: [
                  BoxShadow(
                    color: coralRed.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Cắt góc cho ảnh khớp với khung
                child: Image.network(
                  // 👇 DÁN LINK ẢNH CỦA BẠN VÀO ĐÂY
                  'https://imgs.search.brave.com/s_UUHzI4lWlRH2CD3u2JRH14uqK6UZsQkA_1I9qaCvE/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9naXRo/dWIuY29tL2h6ZWxs/ZXIvcnBpLXJnYi1s/ZWQtbWF0cml4L3Jh/dy9tYXN0ZXIvaW1n/L3RleHQtZ2hvc3Rp/bmcuanBn',
                  fit: BoxFit.cover, // Ảnh phủ kín khung chữ nhật
                  // Nếu mạng lỗi hoặc link sai, nó sẽ hiện icon con chip
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.developer_board,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Tên App & Phiên bản
            Text(
              'Bảng LED 16X8',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: mintGreen.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: mintGreen),
              ),
              child: Text(
                'Phiên bản 1.0.0',
                style: TextStyle(
                  color: const Color(0xFF2D6A4F),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 3. Thanh thông số
            Text(
              'Dung lượng & Hiệu năng',
              style: TextStyle(
                color: subTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: coralRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: lightYellow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLegend(coralRed, 'Bộ nhớ đệm', subTextColor),
                _buildLegend(lightOrange, 'Dữ liệu', subTextColor),
                _buildLegend(lightYellow, 'Bộ nhớ tạm', subTextColor),
              ],
            ),
            const SizedBox(height: 40),

            // 4. Thông tin chi tiết
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoTile(
                    icon: Icons.person_outline,
                    title: 'Nhà phát triển',
                    subtitle: 'Trần Quốc Dương',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    iconColor: lightOrange,
                  ),
                  _buildDivider(),
                  _buildInfoTile(
                    icon: Icons.email_outlined,
                    title: 'Liên hệ hỗ trợ',
                    subtitle: 'duong@gmail.com',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    iconColor: mintGreen,
                  ),
                  _buildDivider(),
                  _buildInfoTile(
                    icon: Icons.update,
                    title: 'Cập nhật lần cuối',
                    subtitle: '20/10/2026',
                    textColor: textColor,
                    subTextColor: subTextColor,
                    iconColor: coralRed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 5. Nút Liên kết
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bạn đang sử dụng phiên bản mới nhất!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: coralRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Kiểm tra cập nhật mới',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Footer
            Text(
              '© 2026 IoT App. All rights reserved.',
              style: TextStyle(color: subTextColor.withValues(alpha: 0.7), fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget phụ trợ tạo các dòng thông tin
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textColor,
    required Color subTextColor,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: subTextColor, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.withValues(alpha: 0.2),
      height: 1,
      indent: 20,
      endIndent: 20,
    );
  }

  // Widget phụ trợ tạo chú thích cho thanh màu
  Widget _buildLegend(Color color, String text, Color subTextColor) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: subTextColor, fontSize: 11),
        ),
      ],
    );
  }
}