---
# https://vitepress.dev/reference/default-theme-home-page
layout: home

hero:
  name: "Android-XIAOZHI"
  tagline: android-xiaozhi là một ứng dụng client đa nền tảng dựa trên Flutter cho Tiểu Trí, hỗ trợ iOS, Android, Web và nhiều nền tảng khác
  actions:
    - theme: brand
      text: Bắt đầu sử dụng
      link: /guide/00_文档目录
    - theme: alt
      text: Xem mã nguồn
      link: https://github.com/TOM88812/xiaozhi-android-client

features:
  - title: Hỗ trợ đa nền tảng
    details: Phát triển bằng Flutter, một bộ mã hỗ trợ iOS, Android, Web, Windows, macOS và Linux cùng nhiều nền tảng khác
  - title: Tích hợp đa mô hình AI
    details: Hỗ trợ dịch vụ AI Tiểu Trí, Dify, OpenAI và nhiều dịch vụ AI khác, có thể chuyển đổi giữa các mô hình khác nhau bất kỳ lúc nào
  - title: Nhiều cách tương tác phong phú
    details: Hỗ trợ đối thoại giọng nói thời gian thực, tin nhắn văn bản, tin nhắn hình ảnh, cũng như chức năng ngắt thủ công trong cuộc gọi
  - title: Công nghệ tối ưu hóa giọng nói
    details: Thực hiện khử tiếng vang AEC+NS trên thiết bị Android, nâng cao chất lượng tương tác giọng nói
  - title: Thiết kế giao diện tinh tế
    details: Thiết kế vật lý nhẹ, hiệu ứng hoạt hình mượt mà, bố cục UI tự thích ứng, mang lại trải nghiệm hình ảnh tốt hơn
  - title: Tùy chọn cấu hình linh hoạt
    details: Hỗ trợ quản lý cấu hình nhiều dịch vụ AI, có thể thêm nhiều Tiểu Trí vào danh sách trò chuyện
  - title: Nhận diện giọng nói thời gian thực
    details: Hệ thống nhận diện giọng nói phản hồi nhanh, cung cấp chức năng chuyển giọng nói thành văn bản thời gian thực
  - title: Nhiều nhà cung cấp dịch vụ
    details: Hỗ trợ dịch vụ Tiểu Trí chính thức, Dify, OpenAI và nhiều nhà cung cấp dịch vụ AI khác
  - title: Chế độ đối thoại liên tục
    details: Hỗ trợ đối thoại liên tục, duy trì tính liên tục ngữ cảnh của tương tác
  - title: Tối ưu hóa cục bộ
    details: Trải nghiệm hiệu suất được tối ưu hóa cho thiết bị di động, giảm tiêu thụ pin
  - title: Tương tác hình ảnh-văn bản
    details: Hỗ trợ đối thoại kết hợp hình ảnh và văn bản, cung cấp trải nghiệm tương tác đa phương thức
  - title: Đăng ký thiết bị tự động
    details: Hỗ trợ đăng ký thiết bị tự động theo cách OTA, đơn giản hóa quy trình cấu hình
---

<div class="developers-section">
  <h2>👨‍💻 Nhà phát triển</h2>
  <p>Cảm ơn các nhà phát triển sau đây vì những đóng góp của họ cho android-xiaozhi</p>
  
  <div class="contributors-wrapper">
    <a href="https://github.com/TOM88812/xiaozhi-android-client/graphs/contributors" class="contributors-link">
      <img src="https://contrib.rocks/image?repo=TOM88812/xiaozhi-android-client&max=20&columns=10" alt="contributors" class="contributors-image"/>
    </a>
  </div>
  
  <div class="developers-actions">
    <a href="/android-xiaozhi/contributors" class="dev-button">Xem những người đóng góp đặc biệt</a>
    <a href="/android-xiaozhi/contributing" class="dev-button outline">Cách tham gia đóng góp</a>
  </div>

  <div class="join-message">
    <h3>Tham gia hàng ngũ người đóng góp</h3>
    <p>Chúng tôi chào đón thêm nhiều nhà phát triển tham gia dự án! Xem <a href="/android-xiaozhi/contributing">hướng dẫn đóng góp</a> để biết cách tham gia đóng góp.</p>
  </div>

</div>

<style>
.developers-section {
  text-align: center;
  max-width: 960px;
  margin: 4rem auto 0;
  padding: 2rem;
  border-top: 1px solid var(--vp-c-divider);
}

.developers-section h2 {
  margin-bottom: 0.5rem;
  color: var(--vp-c-brand);
}

.contributors-wrapper {
  margin: 2rem auto;
  max-width: 600px;
  position: relative;
  overflow: hidden;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
}

.contributors-wrapper:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
}

.contributors-link {
  display: block;
  text-decoration: none;
  background-color: var(--vp-c-bg-soft);
}

.contributors-image {
  width: 100%;
  height: auto;
  display: block;
  transition: all 0.3s ease;
  max-height: 100px;
}

.developers-actions {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin-top: 1.5rem;
}

.developers-actions a {
  text-decoration: none;
}

.dev-button {
  display: inline-block;
  border-radius: 20px;
  padding: 0.5rem 1.5rem;
  font-weight: 500;
  transition: all 0.2s ease;
  text-decoration: none;
}

.dev-button:not(.outline) {
  background-color: var(--vp-c-brand);
  color: white;
}

.dev-button.outline {
  border: 1px solid var(--vp-c-brand);
  color: var(--vp-c-brand);
}

.dev-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

@media (max-width: 640px) {
  .developers-actions {
    flex-direction: column;
  }
  
  .contributors-wrapper {
    margin: 1.5rem auto;
  }
}

.join-message {
  text-align: center;
  margin-top: 2rem;
  padding: 2rem;
  border-top: 1px solid var(--vp-c-divider);
}

.join-message h3 {
  margin-bottom: 1rem;
}
</style>
