import 'package:flutter/material.dart';
import 'package:vi_dieu_khien_iot/san_pham/cart_model.dart'; // 👈 Thêm dấu ; ở đây

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
  });
}

class OrderData {
  static final List<Order> orders = [];
  static void addOrder(Order order) {
    orders.add(order);
  }
}