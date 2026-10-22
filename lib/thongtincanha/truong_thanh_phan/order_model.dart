// lib/san_pham/order_model.dart

import 'dia_chi_model.dart'; // ✅ Import để dùng class DiaChi

class Order {
  final String id;
  final String date;
  final String status;
  final String total;
  final String items;

  // ✅ Lưu trực tiếp đối tượng DiaChi
  DiaChi diaChiGiaoHang;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.total,
    required this.items,
    required this.diaChiGiaoHang,
  });
}

class OrderData {
  static List<Order> orders = [
    Order(
      id: 'DH001',
      date: '20/10/2026',
      status: 'Đang giao',
      total: '1.200.000đ',
      items: '3 sản phẩm',
      // Lấy địa chỉ mặc định từ DiaChiData
      diaChiGiaoHang: DiaChiData.getMacDinh()!,
    ),
    Order(
      id: 'DH002',
      date: '15/10/2026',
      status: 'Đã giao',
      total: '450.000đ',
      items: '1 sản phẩm',
      diaChiGiaoHang: DiaChiData.danhSach[1], // Lấy địa chỉ thứ 2
    ),
  ];
}