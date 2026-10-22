import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';

class AllItemsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> icons;
  final List<Map<String, dynamic>> texts;
  final bool isDarkMode;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final Color accent;

  // 👇 Nhận hàm gửi lệnh từ HomeTab
  final Function(String message) onSendCommand;

  const AllItemsScreen({
    super.key,
    required this.icons,
    required this.texts,
    required this.isDarkMode,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.accent,
    required this.onSendCommand, // 👈 Yêu cầu truyền vào
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            'Tất cả danh mục',
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: accent,
            unselectedLabelColor: subColor,
            indicatorColor: accent,
            tabs: const [
              Tab(text: 'Icons'),
              Tab(text: 'Texts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ================= TAB ICONS =================
            GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
              ),
              itemCount: icons.length,
              itemBuilder: (context, index) {
                final item = icons[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    onSendCommand(item['name'] as String); // 👈 Gửi lệnh
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.neonGreen.withValues(alpha: 0.2)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          item['icon'],
                          color: isDarkMode ? AppColors.neonGreen : AppColors.pureBlack,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name'],
                        style: TextStyle(color: textColor, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),

            // ================= TAB TEXTS =================
            ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: texts.length,
              itemBuilder: (context, index) {
                final item = texts[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      onSendCommand(item['text'] as String); // 👈 Gửi lệnh
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.neonGreen.withValues(alpha: 0.1)
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'],
                            color: isDarkMode ? AppColors.neonGreen : AppColors.pureBlack,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item['text'],
                              style: TextStyle(color: textColor, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}