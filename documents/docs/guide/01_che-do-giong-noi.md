# Hướng Dẫn Chế Độ Tương Tác Giọng Nói

## Tổng Quan Dự Án

Android-xiaozhi là một trợ lý tương tác giọng nói thông minh, được phát triển dựa trên Flutter, tối ưu hóa dành riêng cho nền tảng Android. Hỗ trợ nhiều chế độ hoạt động và chức năng, bao gồm đối thoại giọng nói, trò chuyện văn bản và các khả năng tương tác AI phong phú. Tài liệu này chủ yếu giới thiệu phương pháp sử dụng cơ bản của tương tác giọng nói.

## Chế Độ Tương Tác Giọng Nói

Tương tác giọng nói hỗ trợ hai chế độ, bạn có thể chọn cách tương tác phù hợp dựa trên nhu cầu thực tế:

### 1. Chế Độ Nhấn Dài Đối Thoại

- **Phương Pháp Hoạt Động**: Nhấn giữ nút nói, thả tay để gửi
- **Tình Huống Áp Dụng**: Trao đổi câu ngắn, kiểm soát chính xác thời gian bắt đầu và kết thúc đối thoại
- **Ưu Điểm**: Tránh kích hoạt nhầm, kiểm soát chính xác
- **Cách Hủy**: Kéo lên trong khi nhấn dài để hủy gửi
- **Phản Hồi Rung**: Cung cấp phản hồi xúc giác, xác nhận hoạt động đã được nhận diện

### 2. Chế Độ Đối Thoại Tự Động

- **Phương Pháp Hoạt Động**: Nhấp vào bắt đầu đối thoại, hệ thống tự động phát hiện giọng nói và gửi
- **Tình Huống Áp Dụng**: Trao đổi câu dài, không cần kiểm soát thủ công
- **Ưu Điểm**: Giải phóng đôi tay, trao đổi tự nhiên
- **Gợi Ý Giao Diện**: Hiển thị "Đang Lắng Nghe" để chỉ ra hệ thống đang nhận giọng nói của bạn
- **Hoạt Ảnh Sóng**: Hiển thị hoạt ảnh sóng theo cường độ âm thanh thời gian thực, phản hồi trực quan

### Chuyển Đổi Chế Độ

- Ở góc dưới bên phải giao diện hiển thị chế độ hiện tại
- Nhấp vào nút để chuyển đổi chế độ
- Có thể thiết lập chế độ mặc định qua menu thiết lập

## Kiểm Soát Đối Thoại

### Chức Năng Ngắt Lời

Khi hệ thống đang trả lời giọng nói, bạn có thể ngắt lời bất cứ lúc nào:
- Sử dụng nút ngắt lời trên giao diện

### Chuyển Trạng Thái

Hệ thống tương tác giọng nói có các trạng thái sau:

```
                        +----------------+
                        |                |
                        v                |
+------+    Nút       +------------+   |   +------------+
| IDLE | -----------> | CONNECTING | --+-> | LISTENING  |
+------+              +------------+       +------------+
   ^                                            |
   |                                            | Nhận diện giọng nói hoàn tất
   |          +------------+                    v
   +--------- |  SPEAKING  | <-----------------+
     Hoàn tất phát +------------+
```

- **IDLE**: Trạng thái rảnh rỗi, chờ kích hoạt nút
- **CONNECTING**: Đang kết nối máy chủ
- **LISTENING**: Đang lắng nghe giọng nói người dùng
- **SPEAKING**: Hệ thống đang trả lời giọng nói

## Đặc Trưng Hệ Thống

### Tối Ưu Âm Học

- **Loại Bỏ Tiếng Vang (AEC)**: Công nghệ loại bỏ tiếng vang âm học tích hợp, tránh đầu ra loa can thiệp vào đầu vào micro
- **Xử Lý Giảm Nhiễu (NS)**: Giảm nhiễu thời gian thực, lọc tiếng ồn môi trường, nâng cao độ chính xác nhận diện giọng nói
- **Hỗ Trợ Tần Số Làm Tươi Cao**: Tự động phát hiện và thích ứng màn hình tần số làm tươi cao, cung cấp trải nghiệm giao diện mượt mà

### Tối Ưu Hiệu Suất

- Chế độ ghi âm tiết kiệm năng lượng thấp, kéo dài thời gian sử dụng pin
- Nén giọng nói thông minh, tiết kiệm lưu lượng dữ liệu
- Tải trước tài nguyên nền, giảm thời gian chờ đợi

## Nhận Hỗ Trợ

Nếu gặp vấn đề:

1. Ưu tiên kiểm tra GitHub Issues xem có vấn đề tương tự đã được giải quyết không
2. Gửi vấn đề qua GitHub Issues
3. Liên hệ tác giả