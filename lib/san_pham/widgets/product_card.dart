import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';
import '../product_mode1.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int index;
  final bool isDarkMode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.index,
    this.isDarkMode = false,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định màu sắc dựa trên Theme Sáng/Tối
    final cardColor = isDarkMode ? AppColors.darkCard : Colors.white;
    final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;
    final subTextColor = isDarkMode ? AppColors.greenLight.withValues(alpha: 0.6) : Colors.grey[600];
    final iconColor = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;

    // Màu nền nhẹ cho ô chứa ảnh
    final imageBgColor = isDarkMode ? AppColors.navyDark : AppColors.lightBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          // Đổ bóng nhẹ ở chế độ Sáng
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: AppColors.navyDark.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
          ],
          // Viền mờ ở chế độ Tối
          border: isDarkMode
              ? Border.all(color: AppColors.greenPastel.withValues(alpha: 0.1))
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // 1. Ảnh sản phẩm (Hình vuông bo góc)
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: imageBgColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.memory,
                            color: iconColor,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // 2. Thông tin sản phẩm
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Tên & Danh mục
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                product.category,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          // Hàng dưới: Giá, Đánh giá
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  // Giá
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.price,
                                        style: TextStyle(
                                          color: isDarkMode ? AppColors.greenPastel : AppColors.navyDark,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                          color: subTextColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  // Đánh giá
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.orange, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${product.rating}',
                                            style: TextStyle(
                                              color: textColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'Rating',
                                        style: TextStyle(
                                          color: subTextColor,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Nút Sửa & Xóa (Góc trên phải)
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onEdit,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.blueAccent, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.delete, color: Colors.redAccent, size: 16),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}