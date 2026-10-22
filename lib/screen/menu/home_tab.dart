import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';
import 'package:vi_dieu_khien_iot/screen/menu/thanh_tk.dart';
import 'package:vi_dieu_khien_iot/screen/menu/all_items_screen.dart';
import 'package:vi_dieu_khien_iot/san_pham/cart_screen.dart';
import 'package:vi_dieu_khien_iot/san_pham/cart_model.dart';
import 'package:vi_dieu_khien_iot/san_pham/shop_screen.dart';

class HomeTab extends StatefulWidget {
  final bool isDarkMode;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final Color accent;
  final Color highlight;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenDrawer;
  final VoidCallback onAddPressed;
  final List<Map<String, dynamic>> allIcons;
  final List<Map<String, dynamic>> allTexts;

  // Biến nhận hàm gửi lệnh từ MenuScreen
  final Function(String) onSendCommand;

  const HomeTab({
    super.key,
    required this.isDarkMode,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.accent,
    required this.highlight,
    required this.onToggleTheme,
    required this.onOpenDrawer,
    required this.onAddPressed,
    required this.allIcons,
    required this.allTexts,
    required this.onSendCommand,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final PageController _bannerCtrl = PageController();
  int _currentBanner = 0;
  Timer? _bannerTimer;
  String _searchQuery = '';

  static const List<String> bannerImages = [
    'https://i.pinimg.com/736x/1c/e9/37/1ce93733d76916c06c8f28d39568e3b1.jpg',
    'https://i.pinimg.com/736x/c1/fc/11/c1fc117fbdaafa356b9ea5ebb4c6c338.jpg',
    'https://images.unsplash.com/photo-1558346490-a72e53ae2d4f?w=800&q=80',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || !_bannerCtrl.hasClients) return;
      final next = (_currentBanner + 1) % bannerImages.length;
      _bannerCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final card = widget.cardColor;
    final txt = widget.textColor;
    final sub = widget.subColor;
    final acc = widget.accent;
    final hi = widget.highlight;

    final filteredIcons = widget.allIcons.where((p) {
      return p['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ===== HEADER =====
              Row(
                children: [
                  GestureDetector(
                    onTap: widget.onOpenDrawer,
                    child: Icon(Icons.menu_rounded, color: txt, size: 26),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'IoT Devices',
                        style: TextStyle(
                          color: txt,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CartScreen(),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: card,
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Icon(Icons.shopping_cart_outlined, color: txt, size: 20),
                        ),
                        if (CartData.items.isNotEmpty)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: hi,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '${CartData.items.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: widget.onToggleTheme,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: card,
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (!isDark) BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: acc,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // ===== SEARCH BAR =====
              CustomSearchBar(
                cardColor: card,
                subColor: sub,
                highlight: hi,
                onAddPressed: widget.onAddPressed,
                onChanged: (value) => setState(() => _searchQuery = value),
              ),

              const SizedBox(height: 18),

              // ===== BANNER CAROUSEL =====
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopScreen(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(22),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: PageView.builder(
                      controller: _bannerCtrl,
                      onPageChanged: (i) => setState(() => _currentBanner = i),
                      itemCount: bannerImages.length,
                      itemBuilder: (_, i) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: (isDark ? Colors.black : AppColors.navyDark).withValues(alpha: 0.15),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Image.network(
                                    bannerImages[i],
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Container(color: AppColors.navyDark),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          AppColors.navyDark.withValues(alpha: 0.95),
                                          AppColors.navyDark.withValues(alpha: 0.3),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'IoT for the\nReal-Life',
                                        style: TextStyle(
                                          color: AppColors.greenLight,
                                          fontSize: 26,
                                          height: 1.15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'serif',
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      _ShopNowButton(),
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
                ),
              ),
              const SizedBox(height: 16),

              // ===== DOTS =====
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  bannerImages.length,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _currentBanner == i ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentBanner == i ? acc : sub.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ===== BEST CHOICES & VIEW ALL =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Best Choices',
                    style: TextStyle(color: txt, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllItemsScreen(
                            icons: widget.allIcons,
                            texts: widget.allTexts,
                            isDarkMode: isDark,
                            cardColor: card,
                            textColor: txt,
                            subColor: sub,
                            accent: acc,
                            onSendCommand: widget.onSendCommand, // 👈 ĐÃ THÊM DÒNG NÀY ĐỂ HẾT LỖI
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text('View All', style: TextStyle(color: acc, fontSize: 13, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 10, color: acc),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ===== DANH SÁCH ICON =====
              filteredIcons.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Không tìm thấy kết quả', style: TextStyle(color: sub)),
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredIcons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (_, i) {
                  final p = filteredIcons[i];
                  return _ProductCard(
                    name: p['name'],
                    price: '\$9.99',
                    icon: p['icon'],
                    cardColor: card,
                    textColor: txt,
                    accent: acc,
                    highlight: hi,
                    isDarkMode: isDark,
                    onTap: () {
                      widget.onSendCommand(p['name']);
                    },
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// CÁC WIDGET CON
// ============================================================

class _ShopNowButton extends StatelessWidget {
  const _ShopNowButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.pink,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Text(
        'Shop Now',
        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final IconData icon;
  final Color cardColor;
  final Color textColor;
  final Color accent;
  final Color highlight;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _ProductCard({
    required this.name,
    required this.price,
    required this.icon,
    required this.cardColor,
    required this.textColor,
    required this.accent,
    required this.highlight,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: AppColors.navyDark.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
          border: isDarkMode
              ? Border.all(color: AppColors.greenPastel.withValues(alpha: 0.1))
              : null,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Icon(icon, size: 46, color: iconColor),
              ),
            ),
            Text(
              name,
              style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.favorite_border, color: highlight, size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }
}