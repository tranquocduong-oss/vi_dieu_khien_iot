import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';
// 👇 SỬA ĐƯỜNG DẪN IMPORT TỚI THƯ MỤC SAN_PHAM
import 'package:vi_dieu_khien_iot/thongtincanha/truong_thanh_phan/dia_chi_model.dart'; // ✅ ĐÚNG

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;
    final cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;
    final subColor = isDarkMode ? AppColors.greenLight.withValues(alpha: 0.6) : Colors.grey[600]!;
    final primaryLight = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Địa chỉ giao hàng', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showEditDialog(context, null); // Thêm mới
        },
        backgroundColor: AppColors.pink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: DiaChiData.danhSach.length,
        itemBuilder: (context, index) {
          final diaChi = DiaChiData.danhSach[index];
          return _buildAddressCard(
            context,
            diaChi,
            cardColor,
            textColor,
            subColor,
            primaryLight,
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(
      BuildContext context,
      DiaChi diaChi,
      Color cardColor,
      Color textColor,
      Color subColor,
      Color primaryLight,
      ) {
    return GestureDetector(
      // Bấm vào thẻ để chọn làm mặc định
      onTap: () {
        setState(() {
          DiaChiData.datLamMacDinh(diaChi.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã chọn "${diaChi.ten}" làm mặc định'), backgroundColor: primaryLight),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: diaChi.isDefault ? Border.all(color: primaryLight, width: 2) : Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(diaChi.ten, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 12),
                    Text(diaChi.soDienThoai, style: TextStyle(color: subColor, fontSize: 14)),
                  ],
                ),
                if (diaChi.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text('Mặc định', style: TextStyle(color: primaryLight, fontSize: 10, fontWeight: FontWeight.bold)),
                  )
              ],
            ),
            const SizedBox(height: 12),
            Text(diaChi.diaChiChiTiet, style: TextStyle(color: subColor, fontSize: 14, height: 1.5)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    _showEditDialog(context, diaChi); // Sửa
                  },
                  icon: Icon(Icons.edit, size: 16, color: subColor),
                  label: Text('Sửa', style: TextStyle(color: subColor)),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Xử lý xóa
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Xóa địa chỉ'),
                        content: const Text('Bạn có chắc chắn muốn xóa địa chỉ này?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                DiaChiData.xoaDiaChi(diaChi.id);
                              });
                              Navigator.pop(ctx);
                            },
                            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.redAccent),
                  label: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // Hộp thoại Thêm / Sửa
  void _showEditDialog(BuildContext context, DiaChi? diaChi) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkMode ? AppColors.darkCard : Colors.white;
    final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;
    final primaryLight = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;

    final nameController = TextEditingController(text: diaChi?.ten ?? '');
    final phoneController = TextEditingController(text: diaChi?.soDienThoai ?? '');
    final addressController = TextEditingController(text: diaChi?.diaChiChiTiet ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        title: Text(diaChi == null ? 'Thêm địa chỉ mới' : 'Sửa địa chỉ', style: TextStyle(color: textColor)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: textColor),
                decoration: const InputDecoration(labelText: 'Tên người nhận'),
              ),
              TextField(
                controller: phoneController,
                style: TextStyle(color: textColor),
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                style: TextStyle(color: textColor),
                decoration: const InputDecoration(labelText: 'Địa chỉ chi tiết'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isEmpty || phoneController.text.isEmpty || addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập đủ thông tin!'), backgroundColor: Colors.red),
                );
                return;
              }

              setState(() {
                if (diaChi == null) {
                  // Thêm mới
                  DiaChiData.themDiaChi(DiaChi(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    ten: nameController.text,
                    soDienThoai: phoneController.text,
                    diaChiChiTiet: addressController.text,
                    isDefault: DiaChiData.danhSach.isEmpty, // Nếu là cái đầu tiên thì auto mặc định
                  ));
                } else {
                  // Cập nhật
                  diaChi.ten = nameController.text;
                  diaChi.soDienThoai = phoneController.text;
                  diaChi.diaChiChiTiet = addressController.text;
                }
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryLight),
            // 👇 SỬA LỖI MÀU CHỮ (Nền tối thì chữ sáng, nền sáng thì chữ tối)
            child: Text(
                'Lưu',
                style: TextStyle(color: isDarkMode ? Colors.black : Colors.white)
            ),
          ),
        ],
      ),
    );
  }
}