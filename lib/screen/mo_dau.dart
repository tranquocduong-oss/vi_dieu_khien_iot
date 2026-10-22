import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const SplashScreen({super.key, required this.toggleTheme});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // =====================================================================
  // 👇 CHỖ BẠN CẦN SỬA: DÁN LINK ẢNH TỪ PINTEREST VÀO ĐÂY
  // =====================================================================
  final String logoUrl = 'https://i.pinimg.com/736x/b3/23/c6/b323c6b7db43cd7d2d658993343fed0b.jpg';

  // Nếu bạn để logoUrl = ''; thì app sẽ tự động dùng Icon Chip mặc định
  // =====================================================================

  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;

  late AnimationController _textController;
  late Animation<double> _fadeTextAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Hiệu ứng Logo nảy lên (Elastic)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    // 2. Hiệu ứng chữ mờ dần hiện ra (Fade In)
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_textController);

    // Bắt đầu chạy hiệu ứng
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 500), () {
      _textController.forward();
    });

    // 3. Tự động chuyển sang Login sau 3.5 giây
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, _, _) => LoginScreen(toggleTheme: widget.toggleTheme),
            transitionsBuilder: (_, animation, _, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1A14), // Nền tối
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ============================================================
            // 👇 KHỐI HIỂN THỊ LOGO (TỰ ĐỘNG NHẬN DIỆN ẢNH HOẶC ICON)
            // ============================================================
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 150, // Kích thước khung logo
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Cắt ảnh thành hình tròn (nếu ảnh vuông)
                  color: const Color(0xFF1A2B22), // Màu nền lót sau ảnh
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB8D4A0).withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ClipOval( // Đảm bảo ảnh bo tròn theo khung
                  child: logoUrl.isNotEmpty
                      ? Image.network(
                    logoUrl,
                    fit: BoxFit.cover,
                    // Hiển thị vòng xoay trong lúc đang tải ảnh từ mạng
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Color(0xFFB8D4A0)),
                      );
                    },
                    // Nếu mất mạng hoặc link hỏng, tự động hiện Icon Chip
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.memory,
                        size: 70,
                        color: Color(0xFFB8D4A0),
                      );
                    },
                  )
                  // Nếu không dán link, hiện Icon mặc định
                      : const Icon(
                    Icons.memory,
                    size: 70,
                    color: Color(0xFFB8D4A0),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 👇 CHỮ HIỆN DẦN
            FadeTransition(
              opacity: _fadeTextAnimation,
              child: const Column(
                children: [
                  Text(
                    'IoT for the',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'REAL-LIFE',
                    style: TextStyle(
                      color: Color(0xFFB8D4A0),
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // 👇 VÒNG XOAY LOADING
            FadeTransition(
              opacity: _fadeTextAnimation,
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Color(0xFFB8D4A0),
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}