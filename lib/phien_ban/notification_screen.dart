import 'dart:async'; // Cần import thư viện này để dùng Timer
import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/san_pham/shop_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Bảng màu
  final Color purpleDark = const Color(0xFF5003C0);
  final Color purpleMagenta = const Color(0xFFAB03A9);
  final Color pinkCoral = const Color(0xFFFF467A);
  final Color yellowBright = const Color(0xFFFFD51E);

  final Color bgColor = const Color(0xFF0F111A);
  final Color cardColor = const Color(0xFF1E2130);
  final Color textColor = Colors.white;
  final Color subTextColor = Colors.white70;

  // ================= LOGIC CAROUSEL =================
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  Timer? _timer;

  // Danh sách hình ảnh khuyến mãi (Bạn có thể thay bằng link ảnh của bạn)
  final List<String> _promoImages = [
    'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=800&auto=format&fit=crop', // Ảnh sale
    'https://images.unsplash.com/photo-1550009158-9ebf69173e03?q=80&w=800&auto=format&fit=crop', // Ảnh linh kiện
    'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=800&auto=format&fit=crop', // Ảnh mạch
  ];

  @override
  void initState() {
    super.initState();
    // Thiết lập Timer tự động chuyển ảnh sau mỗi 3 giây
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _promoImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0; // Quay lại ảnh đầu tiên
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi thoát màn hình để tránh rò rỉ bộ nhớ
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read_outlined, color: Colors.white),
            tooltip: 'Đánh dấu tất cả đã đọc',
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        children: [
          // ================= BANNER CAROUSEL TỰ ĐỘNG CHẠY =================
          SizedBox(
            height: 180, // Chiều cao của banner
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _promoImages.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: pinkCoral.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Hình ảnh
                        Image.network(
                          _promoImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: cardColor,
                            child: const Center(
                              child: Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                        ),
                        // Lớp phủ tối (để nổi bật chữ)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                        // Nội dung chữ trên ảnh
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: yellowBright,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'DEAL SỐC',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Giảm giá lên đến 50%\ncho linh kiện IoT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Nút mua ngay nhỏ
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ShopScreen()),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: pinkCoral,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    'Mua Ngay',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Chỉ báo chấm tròn (Dots Indicator)
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _promoImages.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? pinkCoral : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),

          // ================= CÁC THẺ THÔNG BÁO (Giữ nguyên) =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cập nhật mới nhất',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildAnnouncementCard(
                  context,
                  gradientColors: [pinkCoral, purpleMagenta],
                  icon: Icons.local_shipping,
                  title: 'Miễn phí vận chuyển',
                  description: 'Cho mọi đơn hàng linh kiện từ 500.000đ.',
                  actionText: 'Mua ngay',
                  textColor: Colors.white,
                  onTapAction: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopScreen()),
                    );
                  },
                ),
                const SizedBox(height: 16),

                _buildAnnouncementCard(
                  context,
                  gradientColors: [purpleDark, purpleMagenta],
                  icon: Icons.new_releases,
                  title: 'Tính năng mới',
                  description: 'Đã cập nhật giao diện điều khiển Bảng LED 16x8.',
                  actionText: 'Khám phá',
                  textColor: Colors.white,
                ),
                const SizedBox(height: 30),

                const Text(
                  'Trước đó',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildOldNotification(
                  title: 'Chào mừng bạn đến với IoT Store!',
                  time: '2 ngày trước',
                  cardColor: cardColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
                _buildOldNotification(
                  title: 'Hệ thống bảo trì định kỳ.',
                  time: '1 tuần trước',
                  cardColor: cardColor,
                  textColor: textColor,
                  subTextColor: subTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= WIDGET THẺ THÔNG BÁO (Giữ nguyên) =================
  Widget _buildAnnouncementCard(
      BuildContext context, {
        required List<Color> gradientColors,
        required IconData icon,
        required String title,
        required String description,
        String? actionText,
        required Color textColor,
        VoidCallback? onTapAction,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: textColor == Colors.white
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: textColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (actionText != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onTapAction,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: gradientColors.last,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildOldNotification({
    required String title,
    required String time,
    required Color cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.notifications_none, color: subTextColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(color: subTextColor, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}