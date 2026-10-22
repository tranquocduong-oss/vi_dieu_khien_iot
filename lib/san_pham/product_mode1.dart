class Product {
  final String id;
  final String name;
  final String price;
  final double rating;
  final String category;
  final String imageUrl; // ✅ Thêm dòng này

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.category,
    required this.imageUrl, // ✅ Bắt buộc phải có
  });
}

class ProductData {
  static final List<String> categories = [
    'Tất cả',
    'Cảm biến',
    'Vi điều khiển',
    'Mạch',
    'Phụ kiện'
  ];

  // ✅ Đã bỏ chữ 'final' để có thể thêm sản phẩm mới
  static List<Product> products = [
    Product(
      id: '1',
      name: 'ESP32 DevKit V1',
      price: '150.000đ',
      rating: 4.8,
      category: 'Vi điều khiển',
      imageUrl: 'https://i.pinimg.com/736x/9b/46/75/9b4675c9418f68c6de76dee92401a81d.jpg',
    ),
    Product(
      id: '2',
      name: 'Cảm biến nhiệt độ DHT11',
      price: '35.000đ',
      rating: 4.5,
      category: 'Cảm biến',
      imageUrl: 'https://i.pinimg.com/736x/5c/10/c9/5c10c9525efcfbba66181fc9e657a3b6.jpg',
    ),
    Product(
      id: '3',
      name: 'Module Relay 5V',
      price: '45.000đ',
      rating: 4.9,
      category: 'Mạch',
      imageUrl: 'https://i.pinimg.com/736x/aa/95/3f/aa953f66b23c15b409223e7f7ea1508c.jpg',
    ),
    Product(
      id: '4',
      name: 'Màn hình LCD 16x2',
      price: '60.000đ',
      rating: 4.6,
      category: 'Phụ kiện',
      imageUrl: 'https://i.pinimg.com/736x/fc/25/9f/fc259fe45967f9e6e10e4176f93c34a1.jpg',
    ),
    Product(
      id: '5',
      name: 'Cảm biến chuyển động PIR',
      price: '40.000đ',
      rating: 4.7,
      category: 'Cảm biến',
      imageUrl: 'https://i.pinimg.com/1200x/aa/a8/44/aaa8441101970cc37d76e8097c448d0b.jpg',
    ),
    Product(
      id: '6',
      name: 'Arduino Uno R3',
      price: '180.000đ',
      rating: 4.9,
      category: 'Vi điều khiển',
      imageUrl: 'https://i.pinimg.com/1200x/db/c7/85/dbc7858242959a5c57b1c27424593a67.jpg',
    ),
  ];
}