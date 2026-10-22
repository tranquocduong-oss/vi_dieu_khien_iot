// lib/san_pham/dia_chi_model.dart

class DiaChi {
  final String id;
  // 👇 Đã bỏ từ khóa 'final' để có thể chỉnh sửa thông tin
  String ten;
  String soDienThoai;
  String diaChiChiTiet;
  bool isDefault;

  DiaChi({
    required this.id,
    required this.ten,
    required this.soDienThoai,
    required this.diaChiChiTiet,
    this.isDefault = false,
  });
}

class DiaChiData {
  // Danh sách các địa chỉ
  static List<DiaChi> danhSach = [
    DiaChi(
      id: '1',
      ten: 'Trần Quốc Dương',
      soDienThoai: '0123 456 789',
      diaChiChiTiet: '123 Đường Nguyễn Văn Linh, Phường Tân Phong, Quận 7, TP.HCM',
      isDefault: true,
    ),
    DiaChi(
      id: '2',
      ten: 'Trần Quốc Dương',
      soDienThoai: '0987 654 321',
      diaChiChiTiet: 'Tòa nhà Bitexco, Số 2 Hải Triều, Quận 1, TP.HCM',
      isDefault: false,
    ),
  ];

  // 1. Hàm lấy ra địa chỉ mặc định (Dùng cho trang Thanh toán)
  static DiaChi? getMacDinh() {
    try {
      return danhSach.firstWhere((element) => element.isDefault);
    } catch (e) {
      return danhSach.isNotEmpty ? danhSach.first : null;
    }
  }

  // 2. Hàm thêm địa chỉ mới
  static void themDiaChi(DiaChi diaChiMoi) {
    danhSach.add(diaChiMoi);
  }

  // 3. Hàm xóa địa chỉ
  static void xoaDiaChi(String id) {
    danhSach.removeWhere((element) => element.id == id);
  }

  // 4. Hàm đặt làm địa chỉ mặc định
  static void datLamMacDinh(String id) {
    for (var i = 0; i < danhSach.length; i++) {
      // Địa chỉ nào có ID trùng thì set true, còn lại set false
      danhSach[i].isDefault = (danhSach[i].id == id);
    }
  }
}