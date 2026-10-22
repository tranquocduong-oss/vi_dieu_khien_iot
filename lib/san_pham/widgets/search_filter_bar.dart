import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart'; // Thêm import để nhận diện màu

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;

  final List<String> categories;
  final int selectedCategoryIndex;
  final Function(int) onCategorySelected;

  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  final Color primaryLight;

  const SearchFilterBar({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
    required this.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ================= 1. THANH TÌM KIẾM =================
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: textColor),
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm linh kiện...',
                hintStyle: TextStyle(color: subTextColor),
                prefixIcon: Icon(Icons.search, color: subTextColor),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear, color: subTextColor),
                  onPressed: onClearSearch,
                )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),

        // ================= 2. DANH MỤC =================
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final isSelected = selectedCategoryIndex == index;

              return GestureDetector(
                onTap: () => onCategorySelected(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    // 👇 Nền: Nếu chọn thì dùng primaryLight, không thì dùng cardColor
                    color: isSelected ? primaryLight : cardColor,
                    borderRadius: BorderRadius.circular(20),
                    // Thêm viền cho nút chưa chọn để tách biệt với nền
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : subTextColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        // 👇 SỬA LỖI CHỮ ĐEN:
                        // Nếu đang chọn: Nền Navy -> Chữ Trắng, Nền Pastel -> Chữ Đen.
                        // Nếu không chọn: Chữ màu xám (subTextColor)
                        color: isSelected
                            ? (primaryLight == AppColors.greenPastel
                            ? AppColors.navyDark
                            : Colors.white)
                            : subTextColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}