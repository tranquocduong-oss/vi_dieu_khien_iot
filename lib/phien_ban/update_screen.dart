import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  // Bảng màu pastel
  final Color bgColor = const Color(0xFFF3F9F7);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF2D3142);
  final Color subTextColor = const Color(0xFF6C757D);
  final Color coralRed = const Color(0xFFDE7272);
  final Color mintGreen = const Color(0xFFB4E4D6);
  final Color blueButton = const Color(0xFF8BB1EA);

  // ==========================================
  // GIẢ LẬP SERVER (OTA)
  // Bạn hãy đổi thành 'true' nếu muốn giả lập OTA Server vừa phát hành bản 1.1.0
  // Mặc định là 'false' (Đã là bản mới nhất).
  // ==========================================
  bool _isServerHasNewUpdate = false;

  // Trạng thái
  int _status = 0;
  // 0: Đã là mới nhất (Ban đầu)
  // 1: Đang kiểm tra (Loading)
  // 2: Có bản cập nhật
  // 3: Đang tải xuống
  // 4: Đã cài đặt xong

  double _downloadProgress = 0.0;

  // Hàm kiểm tra
  void _checkForUpdates() async {
    setState(() => _status = 1); // Loading

    // Giả lập thời gian kết nối mạng (1.5 giây)
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    // Kiểm tra xem "Server" có bản mới không
    setState(() {
      if (_isServerHasNewUpdate) {
        _status = 2; // Có bản cập nhật
      } else {
        _status = 0; // Đã là mới nhất
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bạn đang sử dụng phiên bản mới nhất!')),
        );
      }
    });
  }

  // Hàm tải xuống
  void _startDownload() async {
    setState(() {
      _status = 3; // Đang tải xuống
      _downloadProgress = 0.0;
    });

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _downloadProgress = i / 10);
    }

    setState(() {
      _status = 4; // Đã cài đặt xong
      _isServerHasNewUpdate = false; // Đã cập nhật xong thì server hết bản mới
    });
  }

  @override
  Widget build(BuildContext context) {
    // Xác định xem có đang tải không
    bool isDownloading = _status == 3;
    bool isUpToDate = _status == 0;
    bool hasUpdate = _status == 2;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          'Cập nhật ứng dụng',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          // Nút ẩn dành cho Dev test (Bạn có thể xóa khi làm thật)
          IconButton(
            icon: const Icon(Icons.developer_mode, size: 20),
            tooltip: 'Giả lập Server có bản mới',
            onPressed: () {
              setState(() {
                _isServerHasNewUpdate = !_isServerHasNewUpdate;
                _status = 0; // Reset trạng thái
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_isServerHasNewUpdate ? 'OTA Server: Đã phát hành bản 1.1.0' : 'OTA Server: Không có bản mới')),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // ICON
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _status == 4 ? Colors.green.withValues(alpha: 0.1) : mintGreen.withValues(alpha: 0.3),
                border: Border.all(
                    color: _status == 4 ? Colors.green : mintGreen,
                    width: 2
                ),
              ),
              child: _status == 1
                  ? const Padding(
                padding: EdgeInsets.all(30.0),
                child: CircularProgressIndicator(color: Color(0xFF2D6A4F), strokeWidth: 3),
              )
                  : Icon(
                _status == 4 ? Icons.check_circle_outline : (hasUpdate ? Icons.system_update : Icons.verified_outlined),
                size: 60,
                color: _status == 4 ? Colors.green : const Color(0xFF2D6A4F),
              ),
            ),
            const SizedBox(height: 24),

            // TIÊU ĐỀ
            Text(
              _status == 1 ? 'Đang kiểm tra...' :
              hasUpdate ? 'Đã có phiên bản mới!' :
              isDownloading ? 'Đang tải xuống...' :
              _status == 4 ? 'Cập nhật hoàn tất!' : 'Ứng dụng đã mới nhất',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // PHỤ ĐỀ
            Text(
              _status == 1 ? 'Vui lòng chờ trong giây lát.' :
              hasUpdate ? 'Phiên bản 1.1.0 (15 MB)' :
              isDownloading ? '${(_downloadProgress * 100).toInt()}% hoàn thành' :
              _status == 4 ? 'Ứng dụng đã sẵn sàng để sử dụng.' : 'Phiên bản hiện tại: 1.0.0 (Mới nhất)',
              style: TextStyle(color: subTextColor, fontSize: 14),
            ),
            const SizedBox(height: 40),

            // KHỐI TÍNH NĂNG MỚI (Chỉ hiện khi có bản cập nhật hoặc đang tải)
            if (hasUpdate || isDownloading)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Có gì mới trong bản cập nhật này?',
                      style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildUpdateFeature('Cải thiện hiệu năng kết nối thiết bị IoT.'),
                    _buildUpdateFeature('Sửa lỗi hiển thị danh sách sản phẩm bị tràn viền.'),
                    _buildUpdateFeature('Thêm tính năng tự động lưu sản phẩm vào bộ nhớ.'),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // THANH TIẾN TRÌNH
            if (isDownloading) ...[
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _downloadProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: coralRed,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],

            // NÚT BẤM (Chỉ hiển thị khi không ở trạng thái Loading / Đang tải)
            if (_status != 1 && !isDownloading)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (hasUpdate) {
                      _startDownload();
                    } else if (_status == 4) {
                      Navigator.pop(context); // Hoàn tất
                    } else {
                      _checkForUpdates(); // Mặc định là Kiểm tra
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _status == 4
                        ? Colors.green
                        : (hasUpdate ? coralRed : blueButton),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(
                    hasUpdate ? 'Tải xuống & Cài đặt' :
                    _status == 4 ? 'Khởi động lại' : 'Kiểm tra cập nhật',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),

            const SizedBox(height: 20),
            Text(
              '© 2026 IoT App. All rights reserved.',
              style: TextStyle(color: subTextColor.withValues(alpha: 0.7), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateFeature(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, color: mintGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: textColor, fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }
}