# Trợ lý AI Tiểu Trí cho Android và iOS
<p align="center">
  <a href="https://github.com/TOM88812/xiaozhi-android-client/releases/latest">
    <img src="https://img.shields.io/github/v/release/TOM88812/xiaozhi-android-client?style=flat-square&logo=github&color=blue" alt="Release"/>
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img src="https://img.shields.io/badge/License-Apache_2.0-green.svg?style=flat-square" alt="License: Apache-2.0"/>
  </a>
  <a href="https://github.com/TOM88812/xiaozhi-android-client/stargazers">
    <img src="https://img.shields.io/github/stars/TOM88812/xiaozhi-android-client?style=flat-square&logo=github" alt="Stars"/>
  </a>
  <a href="https://github.com/TOM88812/xiaozhi-android-client/releases/latest">
    <img src="https://img.shields.io/github/downloads/TOM88812/xiaozhi-android-client/total?style=flat-square&logo=github&color=52c41a1&maxAge=86400" alt="Download"/>
  </a>
  <a href="https://wiki.lhht.cc/welcome">
    <img src="https://img.shields.io/badge/文档-Wiki-yellow?logo=wikipedia">
  </a>

</p>

> Phiên bản mới đã được phát hành, kính mời trải nghiệm! Flutter iOS và Android đã thực hiện loại bỏ tiếng vọng, ~~chào mừng mọi người PR~~.
> Nếu bạn thấy dự án hữu ích, có thể ủng hộ một chút, mỗi lần ủng hộ của bạn là động lực tiến bộ của tôi.
> Dify hỗ trợ gửi tương tác hình ảnh. Có thể thêm nhiều agent thông minh Tiểu Trí vào danh sách chat.

Một ứng dụng trò chuyện giọng nói Android dựa trên WebSocket, hỗ trợ tương tác giọng nói thời gian thực và trò chuyện văn bản.
Trợ lý AI Tiểu Trí được phát triển dựa trên khung Flutter, hỗ trợ triển khai đa nền tảng (iOS、Android、Web、Windows、macOS、Linux), cung cấp chức năng tương tác giọng nói thời gian thực và trò chuyện văn bản.

<table>
  <tr>
    <td align="center" valign="bottom" height="500">
      <table>
        <tr>
          <td align="center">
            <a href="https://www.bilibili.com/video/BV178EqzAEFf" target="_blank">
              <img src="1234.jpg" alt="Phiên bản mới"  width="200" height="430"/>
            </a>
          </td>
        </tr>
        <tr>
          <td align="center">
            <small>
  Phiên bản mới iOS, Android (có thể tự đóng gói phiên bản WEB, PC)<br>
  <a href="https://www.bilibili.com/video/BV1fgXvYqE61" style="color: red; text-decoration: none;">Xem video demo nhấp để chuyển hướng</a>
</small>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

## Tính năng nổi bật (một số tính năng chưa được thực hiện trong phiên bản cộng đồng)

- **Hỗ trợ đa nền tảng**: Sử dụng khung Flutter, một bộ mã hỗ trợ đa nền tảng
- **Hỗ trợ đa mô hình AI**:
  - Tích hợp dịch vụ AI Tiểu Trí
  - Hỗ trợ Dify
  - Hỗ trợ OpenAI - tin nhắn hình ảnh - đầu ra dòng chảy
  - Hỗ trợ Tiểu Trí chính thức - đăng ký thiết bị một chạm
- **Các cách tương tác phong phú**:
  - Hỗ trợ cuộc gọi giọng nói thời gian thực (đối thoại liên tục)
  - Hỗ trợ tương tác tin nhắn văn bản
  - Hỗ trợ tin nhắn hình ảnh
  - Hỗ trợ ngắt cuộc gọi thủ công
  - Hỗ trợ giữ để nói
  - Hỗ trợ ngắt giọng nói thời gian thực
  - Hỗ trợ thêm nhiều agent thông minh
  - Hỗ trợ tương tác cảm xúc độc đáo
  - Hỗ trợ thị giác
  - Hỗ trợ live2d (đồng bộ miệng)
- **Giao diện đa dạng**:
  - Thích ứng chủ đề tối/sáng
  - Thiết kế nhẹ nhàng giống vật lý
  - Bố cục UI thích ứng
  - Hiệu ứng hoạt hình tinh tế
- **Chức năng hệ thống**:
  - Quản lý cấu hình dịch vụ AI đa dạng
  - Cơ chế kết nối lại tự động
  - Lịch sử hội thoại giọng nói/văn bản hỗn hợp
  - Android AEC+NS loại bỏ tiếng vọng
  - iOS loại bỏ tiếng vọng
  - Hỗ trợ công tắc chế độ suy nghĩ cho mô hình Qwen3
  - Hỗ trợ xem trước mã HTML


## Nhà cung cấp dịch vụ được hỗ trợ

- Hỗ trợ cấu hình nhiều địa chỉ dịch vụ Tiểu Trí
- Hỗ trợ cấu hình nhiều dịch vụ Dify
- Hỗ trợ nhiều dịch vụ OpenAI

## Kế hoạch phát triển
- [x] Thích ứng chủ đề tối/sáng
- [x] Hỗ trợ nhiều nhà cung cấp dịch vụ AI hơn
- [x] Cải thiện độ chính xác nhận diện giọng nói
- [x] Hỗ trợ đăng ký thiết bị OTA tự động
- [x] Hỗ trợ ngắt giọng nói thời gian thực
- [x] Hỗ trợ chế độ suy nghĩ
- [x] Hỗ trợ xem trước mã HTML
- [x] live2d chuyển đổi tự do đa mô hình
  - Tích hợp hai mô hình live2d tải miễn phí chính thức
  - Nhập live2d tự do
  - Đồng bộ miệng
- [x] Hỗ trợ chức năng iot
- [x] Hỗ trợ thị giác
- [x] Chế độ cảm xúc sáng tạo
- [ ] Hỗ trợ TTS
- [x] Hỗ trợ MCP_Client
- [x] Hỗ trợ giao diện OpenAI tìm kiếm mạng 🔍
- [x] Hỗ trợ phát video ▶️
- [x] Hỗ trợ đo tốc độ token đầu tiên openai

## Thông tin liên hệ

> Tất cả chức năng tạm thời chưa mở cho cộng đồng, phiên bản đầy đủ hiện chỉ cung cấp cho phiên bản thương mại.

- **email**
> lhht0606@163.com

- **wechat**
> Forever-Destin

## Hỗ trợ cung cấp phát triển client tùy chỉnh có thể liên hệ WeChat

## Công cụ triển khai đồ họa phía máy chủ
- https://space.bilibili.com/298384872
- https://znhblog.com/

## 🌟 Hỗ trợ

Mỗi start⭐ hoặc ủng hộ💖 của bạn là động lực tiến bộ không ngừng của chúng tôi🛸.
<div style="display: flex;">
<img src="zsm.jpg" width="260" height="280" alt="Ủng hộ" style="border-radius: 12px;" />
</div>

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/V7V71I0TE0)

# Bảng xếp hạng ủng hộ
- ### ***Công ty TNHH Truyền thông Văn hóa Wo Ou Thượng Hải***

## Lịch sử Star

[![Star History Chart](https://api.star-history.com/svg?repos=TOM88812/xiaozhi-android-client&type=Date)](https://star-history.com/#TOM88812/xiaozhi-android-client&Date)
