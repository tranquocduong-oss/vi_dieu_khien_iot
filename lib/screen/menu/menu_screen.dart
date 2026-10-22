import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/data/app_colors.dart';
import 'package:vi_dieu_khien_iot/data/theme_controller.dart';
import 'package:vi_dieu_khien_iot/screen/menu/home_tab.dart';
import 'package:vi_dieu_khien_iot/screen/menu/icon_tab.dart';
import 'package:vi_dieu_khien_iot/screen/menu/text_tab.dart';
import 'package:vi_dieu_khien_iot/screen/menu/profile_tab.dart';
import 'package:vi_dieu_khien_iot/screen/menu/app_drawer.dart';
import 'package:vi_dieu_khien_iot/screen/menu/add_options_sheet.dart';
import 'package:vi_dieu_khien_iot/screen/menu/custom_bottom_nav.dart';
import 'package:vi_dieu_khien_iot/screen/menu/add_icon_dialog.dart';
import 'package:vi_dieu_khien_iot/screen/menu/add_text_dialog.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 📋 Dữ liệu Text
  final List<Map<String, dynamic>> _texts = [
    {'icon': Icons.memory,               'text': 'IoT for the Real-Life', 'imageUrl': ''},
    {'icon': Icons.eco,                  'text': 'Bring Greenery to Life', 'imageUrl': ''},
    {'icon': Icons.local_florist,        'text': 'Curated plants for every space', 'imageUrl': ''},
    {'icon': Icons.home_rounded,         'text': 'Smart Home, Smart Life', 'imageUrl': ''},
    {'icon': Icons.wifi,                 'text': 'Connect Everything', 'imageUrl': ''},
    {'icon': Icons.sentiment_satisfied,  'text': 'Happy Planting', 'imageUrl': ''},
  ];

  // 📋 Dữ liệu Icon
  final List<Map<String, dynamic>> _icons = [
    {'icon': Icons.sentiment_satisfied, 'name': 'Happy'},
    {'icon': Icons.favorite,             'name': 'Heart'},
    {'icon': Icons.wb_sunny,             'name': 'Sun'},
    {'icon': Icons.edit,                 'name': 'Edit'},
    {'icon': Icons.stars,                'name': 'Score'},
    {'icon': Icons.thumb_up,             'name': 'Like'},
    {'icon': Icons.check_circle,         'name': 'Done'},
    {'icon': Icons.notifications,        'name': 'Alert'},
    {'icon': Icons.settings,             'name': 'Settings'},
    {'icon': Icons.home,                 'name': 'Home'},
  ];

  // Hàm loại bỏ dấu tiếng Việt
  String removeDiacritics(String text) {
    const withDiacritics = 'àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệđìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵ';
    const withoutDiacritics = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeediiiiioooooooooooooooooouuuuuuuuuuuyyyyy';
    String result = text;
    for (int i = 0; i < withDiacritics.length; i++) {
      result = result.replaceAll(withDiacritics[i], withoutDiacritics[i]);
      result = result.replaceAll(withDiacritics[i].toUpperCase(), withoutDiacritics[i].toUpperCase());
    }
    return result;
  }

  // ==========================================
  // HÀM GỬI LỆNH XUỐNG SERVER NODE.JS
  // ==========================================
  Future<void> sendCommand(String message) async {
    String safeMessage = removeDiacritics(message);
    if (safeMessage.length > 30) {
      safeMessage = safeMessage.substring(0, 30);
    }

    // ⚠️ THAY ĐỔI IP NÀY BẰNG IP MÁY TÍNH CỦA BẠN (lấy từ lệnh ipconfig)
    final url = Uri.parse('http://192.168.88.96:3000/api/control');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': safeMessage}),
      );

      if (response.statusCode == 200) {
        // 👇 ĐÃ XÓA THÔNG BÁO MÀU XANH TẠI ĐÂY
        // Chỉ in ra Terminal để biết đã gửi thành công
        print('✅ Đã gửi lệnh: $safeMessage');
      }
    } catch (e) {
      // Không hiện thông báo lỗi, chỉ in ra Terminal
      print('❌ Lỗi kết nối: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: ThemeController.isDarkMode,
      builder: (context, isDarkMode, child) {
        final Color bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;
        final Color cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;
        final Color textColor = isDarkMode ? AppColors.offWhite : AppColors.pureBlack;
        final Color subColor = isDarkMode ? AppColors.offWhite.withValues(alpha: 0.6) : Colors.grey[700]!;
        final Color accent = isDarkMode ? AppColors.neonGreen : AppColors.darkOlive;
        final Color highlight = AppColors.pink;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: bgColor,
          resizeToAvoidBottomInset: false,
          drawer: AppDrawer(
            bgColor: bgColor,
            cardColor: cardColor,
            textColor: textColor,
            subColor: subColor,
            accent: accent,
          ),
          body: SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                HomeTab(
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  textColor: textColor,
                  subColor: subColor,
                  accent: accent,
                  highlight: highlight,
                  onToggleTheme: ThemeController.toggleTheme,
                  onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                  onAddPressed: () => _showAddOptions(),
                  allIcons: _icons,
                  allTexts: _texts,
                  onSendCommand: sendCommand,
                ),
                // 🎨 TAB ICON
                IconTab(
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  subColor: subColor,
                  accent: accent,
                  icons: _icons,
                  onSendCommand: sendCommand,
                  onDelete: (index) {
                    setState(() {
                      _icons.removeAt(index);
                    });
                  },
                  onEdit: (index) {
                    showDialog(
                      context: context,
                      builder: (_) => AddIconDialog(
                        cardColor: cardColor,
                        bgColor: bgColor,
                        textColor: textColor,
                        subColor: subColor,
                        accent: accent,
                        highlight: highlight,
                        initialName: _icons[index]['name'],
                        initialIcon: _icons[index]['icon'],
                        onAdd: (icon, name) {
                          setState(() {
                            _icons[index]['icon'] = icon;
                            _icons[index]['name'] = name;
                          });
                        },
                      ),
                    );
                  },
                ),
                // 📝 TAB TEXT
                TextTab(
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  textColor: textColor,
                  subColor: subColor,
                  texts: _texts,
                  onSendCommand: sendCommand,
                  onDelete: (index) {
                    setState(() {
                      _texts.removeAt(index);
                    });
                  },
                  onEdit: (index) {
                    showDialog(
                      context: context,
                      builder: (_) => AddTextDialog(
                        cardColor: cardColor,
                        bgColor: bgColor,
                        textColor: textColor,
                        subColor: subColor,
                        accent: accent,
                        highlight: highlight,
                        initialText: _texts[index]['text'],
                        initialImageUrl: _texts[index]['imageUrl'],
                        onAdd: (text, imageUrl) {
                          setState(() {
                            _texts[index]['text'] = text;
                            _texts[index]['imageUrl'] = imageUrl;
                          });
                        },
                      ),
                    );
                  },
                ),
                // 👤 TAB PROFILE
                ProfileTab(
                  isDarkMode: isDarkMode,
                  cardColor: cardColor,
                  textColor: textColor,
                  subColor: subColor,
                  accent: accent,
                  highlight: highlight,
                  onToggleTheme: ThemeController.toggleTheme,
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) {
              FocusScope.of(context).unfocus();
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        );
      },
    );
  }

  // ============================================================
  // HÀM HIỂN THỊ BOTTOM SHEET (Chỉ dùng cho chức năng Thêm Mới)
  // ============================================================
  void _showAddOptions() {
    final isDarkMode = ThemeController.isDarkMode.value;
    final Color bgColor = isDarkMode ? AppColors.darkBg : AppColors.lightBg;
    final Color cardColor = isDarkMode ? AppColors.darkCard : AppColors.lightCard;

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddOptionsSheet(
        cardColor: cardColor,
        bgColor: bgColor,
        textColor: isDarkMode ? AppColors.offWhite : AppColors.pureBlack,
        subColor: isDarkMode ? AppColors.offWhite.withValues(alpha: 0.6) : Colors.grey[700]!,
        accent: isDarkMode ? AppColors.neonGreen : AppColors.darkOlive,
        highlight: AppColors.pink,

        onAddIcon: (icon, name) {
          setState(() {
            _icons.add({'icon': icon, 'name': name});
            _currentIndex = 1;
          });
        },

        onAddText: (text, imageUrl) {
          setState(() {
            _texts.add({
              'icon': Icons.description_outlined,
              'text': text,
              'imageUrl': imageUrl
            });
            _currentIndex = 2;
          });
        },
      ),
    );
  }
}