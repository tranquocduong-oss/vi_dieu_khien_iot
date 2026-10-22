// lib/data/theme_controller.dart
import 'package:flutter/material.dart';

class ThemeController {
  // Biến toàn cục để quản lý Dark Mode
  static ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  // Hàm đổi theme
  static void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}