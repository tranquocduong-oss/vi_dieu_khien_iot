// lib/data/order_model.dart

class Order {
  final String id;
  final String date;
  final String status;
  final String total;
  final String items;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
  });
}

class OrderData {
  // Danh sách đơn hàng (Mặc định có sẵn vài đơn để test UI)
  static List<Order> orders = [
    Order(
      id: 'DH001',
      date: '20/10/2026',
      status: 'Đang giao',
      total: '1.200.000đ',
      items: '3 sản phẩm',
    ),
    Order(
      id: 'DH002',
      date: '15/10/2026',
      status: 'Đã giao',
      total: '450.000đ',
      items: '1 sản phẩm',
    ),
  ];
}