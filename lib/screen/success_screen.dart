import 'dart:async';
import 'package:flutter/material.dart';

// 👇 IMPORT MENU SCREEN — đường dẫn MỚI sau khi tách file
import 'package:vi_dieu_khien_iot/screen/menu/menu_screen.dart';

class SuccessScreen extends StatefulWidget {
  final String message;
  final String? subMessage;

  const SuccessScreen({
    super.key,
    this.message = 'Đăng nhập thành công!',
    this.subMessage,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _timer;

  // 🛡️ Cờ chống chuyển trang 2 lần
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // ===== Hiệu ứng phóng to icon =====
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    // ===== 🔥 TỰ ĐỘNG CHUYỂN SANG MENU SAU 2.5 GIÂY =====
    _timer = Timer(const Duration(milliseconds: 2500), () {
      _goToMenu();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  // 🔗 HÀM CHUYỂN SANG MENUSCREEN
  // ============================================================
  void _goToMenu() {
    if (_navigated) return; // Chống gọi 2 lần
    _navigated = true;

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const MenuScreen(), // 👈 ĐÂY
        transitionsBuilder: (_, animation, _, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
          (route) => false, // Xóa hết stack cũ
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A),
              Color(0xFF1A1A2E),
              Color(0xFF0A0A0A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ===== ICON TICK XANH CÓ ANIMATION =====
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00E676).withValues(alpha: 0.15),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF00E676),
                    size: 90,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ===== TEXT =====
              Text(
                widget.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.subMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subMessage!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],

              const SizedBox(height: 35),

              // ===== NÚT "GO TO MENU" =====
              SizedBox(
                width: 220,
                height: 50,
                child: ElevatedButton(
                  onPressed: _goToMenu, // 👈 Bấm cũng vào menu
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E676),
                    foregroundColor: Colors.black,
                    elevation: 4,
                    shadowColor:
                    const Color(0xFF00E676).withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_forward_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Go to Menu',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ===== LOADING NHỎ =====
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white54,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Đang chuyển trang...',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}