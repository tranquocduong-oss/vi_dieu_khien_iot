import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';

class TextTab extends StatelessWidget {
  final bool isDarkMode;
  final Color cardColor;
  final Color textColor;
  final Color subColor;
  final List<Map<String, dynamic>> texts;
  final Function(String) onSendCommand;
  // 👇 1. Thêm 2 biến này
  final Function(int) onDelete;
  final Function(int) onEdit;

  const TextTab({
    super.key,
    required this.isDarkMode,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
    required this.texts,
    required this.onSendCommand,
    required this.onDelete, // 👈 2. Yêu cầu truyền vào
    required this.onEdit,   // 👈 2. Yêu cầu truyền vào
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isDarkMode ? AppColors.offWhite : AppColors.pureBlack;
    final itemColor = isDarkMode ? AppColors.offWhite : textColor;
    final iconBoxColor = isDarkMode ? AppColors.pureBlack.withValues(alpha: 0.5) : AppColors.offWhite;
    final iconColor = isDarkMode ? AppColors.neonGreen : AppColors.darkOlive;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Text Library',
                style: TextStyle(color: titleColor, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '${texts.length} mục',
                style: TextStyle(color: subColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (texts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.inbox_outlined, size: 60, color: subColor.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    Text('Chưa có text nào', style: TextStyle(color: subColor, fontSize: 14)),
                  ],
                ),
              ),
            )
          else
            ...texts.asMap().entries.map(
                  (entry) => Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    onSendCommand(entry.value['text'] as String);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDarkMode ? AppColors.neonGreen.withValues(alpha: 0.1) : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: iconBoxColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDarkMode ? AppColors.neonGreen.withValues(alpha: 0.2) : Colors.transparent,
                            ),
                          ),
                          child: Icon(entry.value['icon'] as IconData, color: iconColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mục ${entry.key + 1}', style: TextStyle(color: subColor, fontSize: 10)),
                              const SizedBox(height: 2),
                              Text(
                                entry.value['text'] as String,
                                style: TextStyle(color: itemColor, fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        // 👇 3. THÊM 2 NÚT SỬA VÀ XÓA
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                              onPressed: () => onEdit(entry.key),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                              onPressed: () => onDelete(entry.key),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}