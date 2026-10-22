import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';

class PersonalInfoScreen extends StatefulWidget {
  final bool isDarkMode;

  const PersonalInfoScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _emailController;
  late TextEditingController _avatarUrlController;

  final List<String> _presetAvatars = [
    'https://api.dicebear.com/7.x/adventurer/png?seed=Felix',
    'https://api.dicebear.com/7.x/adventurer/png?seed=Aneka',
    'https://api.dicebear.com/7.x/adventurer/png?seed=John',
    'https://api.dicebear.com/7.x/adventurer/png?seed=Sarah',
    'https://api.dicebear.com/7.x/bottts/png?seed=Robot1',
    'https://api.dicebear.com/7.x/bottts/png?seed=Robot2',
    'https://api.dicebear.com/7.x/avataaars/png?seed=David',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Lucy',
    'https://api.dicebear.com/7.x/avataaars/png?seed=Max',
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    _nameController = TextEditingController(text: user?.displayName ?? 'Người dùng');
    _emailController = TextEditingController(text: user?.email ?? 'Chưa có email');
    _phoneController = TextEditingController(text: 'Chưa cập nhật');
    _dobController = TextEditingController(text: 'Chưa cập nhật');
    _avatarUrlController = TextEditingController(text: user?.photoURL ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.updateDisplayName(_nameController.text);

        if (_avatarUrlController.text.trim().isNotEmpty) {
          await user.updatePhotoURL(_avatarUrlController.text.trim());
        }

        setState(() {
          _isEditing = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã lưu thông tin thành công!'),
              backgroundColor: Color(0xFF08CB00),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: $e')),
          );
        }
      }
    }
  }

  void _showAvatarPicker(Color cardColor, Color textColor, Color primaryLight, Color bgColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chọn ảnh đại diện',
                  style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chọn một avatar có sẵn hoặc dán link ảnh của bạn ở dưới.',
                  style: TextStyle(color: textColor.withValues(alpha: 0.6), fontSize: 13),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 200,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _presetAvatars.length,
                    itemBuilder: (context, index) {
                      final avatarUrl = _presetAvatars[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _avatarUrlController.text = avatarUrl;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _avatarUrlController.text == avatarUrl ? primaryLight : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: cardColor,
                            backgroundImage: NetworkImage(avatarUrl),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _avatarUrlController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Hoặc dán link ảnh (URL)',
                    labelStyle: TextStyle(color: textColor.withValues(alpha: 0.6)),
                    prefixIcon: Icon(Icons.link, color: primaryLight),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryLight, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryLight,
                      foregroundColor: Colors.white, // Sửa thành màu trắng
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    // 👇 ÁP DỤNG BẢNG MÀU MỚI
    final bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;
    final cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDarkMode ? AppColors.greenLight : AppColors.navyDark;
    final subColor = isDarkMode ? AppColors.greenLight.withValues(alpha: 0.6) : Colors.grey[700]!;

    // Nút bấm: Ở Sáng dùng Xanh Navy, ở Tối dùng Xanh Pastel
    final primaryLight = isDarkMode ? AppColors.greenPastel : AppColors.navyDark;
    final pinkCoral = AppColors.pink;

    final String avatarUrl = _avatarUrlController.text.trim();
    final bool hasAvatar = avatarUrl.isNotEmpty && avatarUrl.startsWith('http');

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Thông tin cá nhân', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () {
              if (_isEditing) {
                _saveData();
              } else {
                setState(() => _isEditing = true);
              }
            },
            icon: Icon(_isEditing ? Icons.save : Icons.edit, color: primaryLight, size: 20),
            label: Text(
              _isEditing ? 'Lưu' : 'Sửa',
              style: TextStyle(color: primaryLight, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: primaryLight.withValues(alpha: 0.2),
                      backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                      child: !hasAvatar ? Icon(Icons.person, size: 70, color: primaryLight) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          if (_isEditing) {
                            _showAvatarPicker(cardColor, textColor, primaryLight, bgColor);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Bấm "Sửa" để thay đổi ảnh đại diện')),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _isEditing ? pinkCoral : primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: bgColor, width: 2),
                          ),
                          child: Icon(
                              Icons.camera_alt,
                              // Đổi màu icon camera cho dễ nhìn
                              color: (_isEditing || isDarkMode) ? Colors.white : Colors.white,
                              size: 20
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildInputField(
                label: 'Họ và tên',
                controller: _nameController,
                icon: Icons.badge_outlined,
                isEditing: _isEditing,
                cardColor: cardColor,
                textColor: textColor,
                subColor: subColor,
                primaryLight: primaryLight,
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập họ tên' : null,
              ),

              _buildInputField(
                label: 'Email',
                controller: _emailController,
                icon: Icons.email_outlined,
                isEditing: false,
                cardColor: cardColor,
                textColor: textColor,
                subColor: subColor,
                primaryLight: primaryLight,
              ),

              _buildInputField(
                label: 'Số điện thoại',
                controller: _phoneController,
                icon: Icons.phone_outlined,
                isEditing: _isEditing,
                cardColor: cardColor,
                textColor: textColor,
                subColor: subColor,
                primaryLight: primaryLight,
                keyboardType: TextInputType.phone,
              ),

              _buildInputField(
                label: 'Ngày sinh',
                controller: _dobController,
                icon: Icons.cake_outlined,
                isEditing: _isEditing,
                cardColor: cardColor,
                textColor: textColor,
                subColor: subColor,
                primaryLight: primaryLight,
              ),

              const SizedBox(height: 30),

              // ===== NÚT LƯU THÔNG TIN (ĐÃ SỬA LỖI ĐEN) =====
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_isEditing) {
                      _saveData();
                    } else {
                      setState(() => _isEditing = true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditing ? pinkCoral : primaryLight,
                    // 👇 SỬA LOGIC MÀU CHỮ: Nếu là nút Hồng (Lưu) -> Chữ Trắng.
                    // Nếu là nút Xanh (Cập nhật) -> Tự động chọn màu tương phản (Sáng thì Trắng, Tối thì Đen)
                    foregroundColor: _isEditing
                        ? Colors.white
                        : (isDarkMode ? AppColors.navyDark : Colors.white),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    _isEditing ? 'Lưu thay đổi' : 'Cập nhật thông tin',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isEditing,
    required Color cardColor,
    required Color textColor,
    required Color subColor,
    required Color primaryLight,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        // Viền màu khi đang sửa
        border: isEditing
            ? Border.all(color: primaryLight.withValues(alpha: 0.5))
            : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Icon(icon, color: isEditing ? primaryLight : subColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: isEditing,
              keyboardType: keyboardType,
              validator: validator,
              style: TextStyle(
                  color: isEditing ? textColor : subColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                    color: isEditing ? primaryLight : subColor,
                    fontSize: 12
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 12, bottom: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}