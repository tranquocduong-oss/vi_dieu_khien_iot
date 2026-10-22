import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';

class IconTab extends StatelessWidget {
  final bool isDarkMode;
  final Color cardColor;
  final Color subColor;
  final Color accent;
  final List<Map<String, dynamic>> icons;
  final Function(int index) onEdit;
  final Function(int index) onDelete;
  final Function(String name) onSendCommand; // Gửi tên icon

  const IconTab({
    super.key,
    required this.isDarkMode,
    required this.cardColor,
    required this.subColor,
    required this.accent,
    required this.icons,
    required this.onEdit,
    required this.onDelete,
    required this.onSendCommand,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? AppColors.offWhite : AppColors.pureBlack;
    final iconColor = isDarkMode ? AppColors.neonGreen : accent;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Icons Library',
                  style: TextStyle(color: titleColor, fontSize: 22, fontWeight: FontWeight.bold)),
              Text('${icons.length} mục', style: TextStyle(color: subColor, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          if (icons.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Text('Chưa có icon nào', style: TextStyle(color: subColor)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: icons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (_, i) {
                final item = icons[i];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // 👇 BẤM VÀO ICON SẼ GỬI TÊN CỦA ICON ĐÓ
                    onSendCommand(item['name'] as String);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode ? AppColors.neonGreen.withValues(alpha: 0.2) : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item['icon'] as IconData, color: iconColor, size: 34),
                              const SizedBox(height: 8),
                              Text(
                                item['name'] as String,
                                style: TextStyle(color: titleColor, fontSize: 12, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => onEdit(i),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.edit, color: Colors.blue, size: 16),
                                ),
                              ),
                              InkWell(
                                onTap: () => onDelete(i),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Icon(Icons.close, color: Colors.red, size: 18),
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
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}