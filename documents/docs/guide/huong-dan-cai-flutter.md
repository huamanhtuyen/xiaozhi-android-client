# Hướng dẫn Cài đặt và Cấu hình Flutter

Tài liệu này cung cấp hướng dẫn chi tiết về cài đặt và cấu hình ứng dụng AI Assistant, bao gồm thiết lập môi trường, cài đặt phụ thuộc và các bước cấu hình cụ thể cho nền tảng.

## 1. Cài đặt Flutter SDK

### Windows
1. Tải xuống [Flutter SDK](https://flutter.dev/docs/get-started/install/windows)
2. Giải nén vào thư mục không chứa ký tự đặc biệt và khoảng trắng (ví dụ: `C:\flutter`)
3. Thêm `flutter\bin` vào biến môi trường PATH của hệ thống
4. Mở Command Prompt hoặc PowerShell, chạy `flutter doctor` để xác thực và giải quyết các vấn đề tiềm ẩn

### macOS
1. Sử dụng Homebrew để cài đặt (khuyến nghị):
   ```bash
   brew install --cask flutter
   ```
2. Hoặc tải xuống [Flutter SDK](https://flutter.dev/docs/get-started/install/macos) và giải nén thủ công
3. Thêm Flutter vào PATH:
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. Chạy `flutter doctor` để kiểm tra cấu hình

### Linux
1. Tải xuống [Flutter SDK](https://flutter.dev/docs/get-started/install/linux)
2. Giải nén file:
   ```bash
   tar xf flutter_linux_3.7.0-stable.tar.xz
   ```
3. Thêm Flutter vào PATH:
   ```bash
   export PATH="$PATH:`pwd`/flutter/bin"
   ```
4. Chạy `flutter doctor` để kiểm tra cấu hình

## 2. Cài đặt Công cụ Phát triển

Khuyến nghị sử dụng một trong các IDE sau để phát triển:

- **Visual Studio Code**
  - Cài đặt [Plugin Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
  - Cài đặt [Plugin Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)

- **Android Studio / IntelliJ IDEA**
  - Cài đặt plugin Flutter và Dart (Preferences > Plugins > Tìm kiếm "Flutter")

## 3. Cài đặt Cụ thể cho Nền tảng

### Phát triển Android
1. Cài đặt [Android Studio](https://developer.android.com/studio)
2. Cài đặt Android SDK (qua SDK Manager của Android Studio)
3. Thiết lập thiết bị Android để phát triển:
   - Bật gỡ lỗi USB (Tùy chọn Nhà phát triển)
   - Hoặc sử dụng trình giả lập Android

### Phát triển iOS (chỉ dành cho macOS)
1. Cài đặt [Xcode](https://apps.apple.com/us/app/xcode/id497799835)
2. Cấu hình trình giả lập iOS hoặc thiết bị thực tế
3. Cài đặt CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

### Phát triển Web
1. Đảm bảo đã cài đặt trình duyệt Chrome
2. Bật hỗ trợ web cho Flutter:
   ```bash
   flutter config --enable-web
   ```

### Phát triển Ứng dụng Màn hình Mới cho Windows/macOS/Linux
1. Bật hỗ trợ nền tảng tương ứng:
   ```bash
   # Windows
   flutter config --enable-windows-desktop
   
   # macOS
   flutter config --enable-macos-desktop
   
   # Linux
   flutter config --enable-linux-desktop
   ```

## 4. Thiết lập Dự án

1. Clone kho lưu trữ dự án:
   ```bash
   git clone https://github.com/your-username/ai_assistant.git
   cd ai_assistant
   ```

2. Lấy phụ thuộc:
   ```bash
   flutter pub get
   ```

3. Cấu hình Firebase hoặc các dịch vụ đám mây khác nếu cần (nếu áp dụng)

## 5. Cấu hình Dịch vụ AI

### Cấu hình Dịch vụ XiaoZhi
1. Trong ứng dụng, điều hướng đến "Cài đặt" > "Dịch vụ XiaoZhi"
2. Nhập thông tin sau:
   - Tên: Chỉ định một tên nhận dạng cho cấu hình này
   - WebSocket URL: Địa chỉ kết nối WebSocket của máy chủ XiaoZhi
   - Địa chỉ MAC: Địa chỉ MAC của thiết bị (áp dụng cho thiết bị Bluetooth)
   - Token: Token xác thực

### Cấu hình Dify
1. Truy cập [Trang web chính thức của Dify](https://dify.ai/) để tạo tài khoản và lấy khóa API
2. Thêm cấu hình Dify mới trong cài đặt ứng dụng:
   - Tên: Tên cấu hình tùy chỉnh
   - API Key: Khóa từ bảng điều khiển Dify
   - API URL: Điểm cuối API của dịch vụ Dify

### Cấu hình OpenAI
1. Lấy khóa API từ [Nền tảng Nhà phát triển OpenAI](https://platform.openai.com/)
2. Cấu hình trong cài đặt ứng dụng:
   - API Key: Khóa API OpenAI
   - ID Tổ chức (tùy chọn): Điền nếu có tài khoản tổ chức
   - Mô hình: Chọn mô hình GPT cần thiết (ví dụ: gpt-4, gpt-3.5-turbo)
   - Lời nhắc hệ thống: Thiết lập lời nhắc hệ thống mặc định

## 6. Chạy Ứng dụng

```bash
# Chạy trên thiết bị kết nối
flutter run

# Chạy trên nền tảng cụ thể
flutter run -d windows
flutter run -d macos
flutter run -d chrome
flutter run -d <device-id>
```

## 7. Xây dựng Phiên bản Phát hành

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 8. Giải thích Quyền

Ứng dụng có thể cần các quyền sau:
- **Microphone**: Dùng cho nhận dạng giọng nói và chức năng ghi âm
- **Bluetooth**: Dùng để kết nối thiết bị IoT
- **Camera**: Dùng cho chức năng nhận dạng hình ảnh
- **Lưu trữ**: Dùng để lưu file âm thanh và hình ảnh

Vui lòng đảm bảo cấp quyền cần thiết trước khi sử dụng các chức năng tương ứng.

## 9. Khắc phục Sự cố

### Các Vấn đề Thường Gặp

1. **Flutter SDK Không Được Tìm Thấy**
   - Xác nhận Flutter đã được thêm đúng vào PATH hệ thống
   - Kiểm tra đầu ra của `flutter doctor` có lỗi không

2. **Lấy Phụ Thuộc Thất Bại**
   - Thử sử dụng nguồn gương trong nước:
     ```bash
     export PUB_HOSTED_URL=https://pub.flutter-io.cn
     export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
     ```
   - Xóa bộ đệm và thử lại:
     ```bash
     flutter clean
     flutter pub cache repair
     flutter pub get
     ```

3. **Lỗi Biên Dịch**
   - Xem thông tin lỗi chi tiết: `flutter run -v`
   - Đảm bảo sử dụng phiên bản Flutter SDK được hỗ trợ (^3.7.0)

4. **Xây dựng iOS Thất Bại**
   - Xóa thư mục Pods và cài đặt lại:
     ```bash
     cd ios
     rm -rf Pods
     pod install
     cd ..
     flutter run
     ```

5. **Đồng bộ Gradle Android Thất Bại**
   - Chỉnh sửa `android/gradle.properties` để thêm cài đặt proxy hoặc sử dụng gương trong nước

## 10. Tài nguyên Tham khảo

- [Tài liệu Chính thức Flutter](https://flutter.dev/docs)
- [Tài liệu Chính thức Dart](https://dart.dev/guides)
- [Quản lý Gói Flutter Pub](https://pub.dev/)
- [Tài nguyên Cộng đồng Flutter Tiếng Trung](https://flutter.cn/)