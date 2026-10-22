import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String price;
  final String imageUrl;
  final IconData icon;

  CartItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.icon,
  });
}

// Class quản lý giỏ hàng toàn cục
class CartData {
  static final List<CartItem> items = [];

  static void addToCart(CartItem item) {
    items.add(item);
  }

  static void removeFromCart(CartItem item) {
    items.remove(item);
  }
}