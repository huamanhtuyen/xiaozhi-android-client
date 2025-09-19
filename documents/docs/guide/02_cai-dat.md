# Cài đặt Phụ thuộc Hệ thống

Android-Xiaozhi là ứng dụng đa nền tảng dựa trên Flutter, dưới đây là các phụ thuộc hệ thống cần thiết để chạy và phát triển dự án.

## Cài đặt Phụ thuộc Hệ thống

### Windows
1. **Cài đặt Flutter SDK**
   - Vui lòng tham khảo tài liệu [Hướng dẫn Cài đặt Flutter](huong-dan-cai-flutter.md) để hoàn tất cài đặt Flutter SDK

2. **Cài đặt Android Studio**
   - Tải xuống và cài đặt [Android Studio](https://developer.android.com/studio)
   - Cài đặt plugin Flutter và Dart

3. **Cài đặt Visual Studio Code (tùy chọn)**
   - Tải xuống và cài đặt [Visual Studio Code](https://code.visualstudio.com/)
   - Cài đặt plugin Flutter và Dart

### macOS
1. **Cài đặt Flutter SDK**
   - Vui lòng tham khảo tài liệu [Hướng dẫn Cài đặt Flutter](huong-dan-cai-flutter.md) để hoàn tất cài đặt Flutter SDK

2. **Cài đặt Xcode (dùng cho phát triển iOS)**
   - Tải xuống và cài đặt Xcode từ App Store
   - Cài đặt công cụ dòng lệnh Xcode: `xcode-select --install`

3. **Cài đặt Android Studio (dùng cho phát triển Android)**
   - Tải xuống và cài đặt [Android Studio](https://developer.android.com/studio)
   - Cài đặt plugin Flutter và Dart

4. **Cài đặt CocoaPods (dùng cho quản lý phụ thuộc iOS)**
   ```bash
   sudo gem install cocoapods
   ```

### Linux (Ubuntu)
1. **Cài đặt Flutter SDK**
   - Vui lòng tham khảo tài liệu [Hướng dẫn Cài đặt Flutter](huong-dan-cai-flutter.md) để hoàn tất cài đặt Flutter SDK

2. **Cài đặt công cụ phát triển**
   ```bash
   sudo apt-get update
   sudo apt-get install curl unzip git
   sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
   ```

3. **Cài đặt Android Studio**
   - Tải xuống và cài đặt [Android Studio](https://developer.android.com/studio)
   - Cài đặt plugin Flutter và Dart

## Cài đặt Phụ thuộc Dự án

Sau khi clone dự án, cần cài đặt phụ thuộc dự án:

```bash
# Vào thư mục dự án
cd xiaozhi-android-client

# Lấy phụ thuộc Flutter
flutter pub get
```

## Chạy Ứng dụng

Sau khi hoàn tất cài đặt phụ thuộc, có thể chạy ứng dụng:

```bash
# Kiểm tra thiết bị khả dụng
flutter devices

# Chạy ứng dụng
flutter run

# Hoặc chạy trên thiết bị cụ thể
flutter run -d <device_id>
```

## Lưu Ý
1. Đảm bảo phiên bản Flutter SDK phù hợp với yêu cầu dự án, khuyến nghị sử dụng phiên bản ổn định mới nhất
2. Phát triển Android cần cấu hình tốt môi trường Java và Android SDK
3. Phát triển iOS cần hệ thống macOS và tài khoản nhà phát triển Apple
4. Lần chạy đầu tiên có thể mất thời gian dài để build ứng dụng
5. Nếu gặp vấn đề, vui lòng tham khảo tài liệu chính thức của Flutter hoặc submit Issue