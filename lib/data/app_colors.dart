import 'package:flutter/material.dart';

class AppColors {
  // 🎨 BẢNG MÀU TỪ COLOR HUNT (Xanh Navy + Xanh Pastel)
  static const Color navyDark    = Color(0xFF202734); // Nền tối chủ đạo
  static const Color navyLight   = Color(0xFF36415A); // Card / Khối nổi
  static const Color greenPastel = Color(0xFFB7D894); // Xanh pastel đậm (nhấn)
  static const Color greenLight  = Color(0xFFE0F8C7); // Xanh pastel nhạt (chữ/nền)

  // --- CẤU HÌNH GIAO DIỆN ---
  // Nền Tối (Dark Mode)
  static const Color darkBg      = navyDark;
  static const Color darkCard    = navyLight;

  // Nền Sáng (Light Mode) - ĐÃ CHỈNH THÀNH XANH PASTEL NHẠT SÁNG
  static const Color lightBg     = Color(0xFFF3F9EC); // Xanh lá pha trắng, sáng dịu mắt
  static const Color lightCard   = Colors.white;      // Thẻ sản phẩm màu trắng nổi bật

  // Map các biến cũ để không lỗi code
  static const Color navy        = navyLight;
  static const Color cream       = greenLight;
  static const Color whiteCard   = Colors.white;

  static const Color neonGreen   = greenPastel;
  static const Color darkOlive   = navyDark;
  static const Color skyBlue     = greenPastel;
  static const Color pureBlack   = Color(0xFF1A1A1A); // Đen mềm
  static const Color offWhite    = greenLight;

  // Màu phụ trợ (Hồng cho nút Mua Ngay)
  static const Color pink        = Color(0xFFFF95A5);
}