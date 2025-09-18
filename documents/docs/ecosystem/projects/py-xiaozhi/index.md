---
title: Phiên bản Python của Tiểu Trí
description: Phiên bản Python của Tiểu Trí sử dụng Python để thực hiện, nhằm học tập qua mã nguồn và trải nghiệm chức năng giọng nói của AI Tiểu Trí mà không cần phần cứng
---

# Phiên bản Python của Tiểu Trí

<div class="project-header">
  <div class="project-badges">
    <span class="badge platform">Đa nền tảng</span>
    <span class="badge language">Python</span>
    <span class="badge status">Phiên bản ổn định</span>
  </div>
</div>

## Giới thiệu dự án

py-xiaozhi là một phiên bản Python của Tiểu Trí, nhằm học tập qua mã nguồn và trải nghiệm chức năng giọng nói của AI Tiểu Trí mà không cần phần cứng. Hỗ trợ đầu vào và nhận dạng giọng nói, thực hiện tương tác thông minh giữa người và máy, cung cấp trải nghiệm đối thoại tự nhiên và mượt mà.

<div class="app-showcase">
  <div class="showcase-description">
    <p>py-xiaozhi cung cấp trải nghiệm tương tác giọng nói đa nền tảng của Tiểu Trí, không chỉ hỗ trợ giao diện GUI mà còn cung cấp chế độ dòng lệnh, phù hợp với các môi trường khác nhau. Thông qua giao diện đơn giản và dễ sử dụng cùng các chức năng phong phú, giúp người dùng dễ dàng giao tiếp giọng nói và văn bản với AI.</p>
  </div>
</div>

## Chức năng cốt lõi

<div class="features-grid">
  <div class="feature-card">
    <div class="feature-icon">🗣️</div>
    <h3>Tương tác giọng nói AI</h3>
    <p>Hỗ trợ đầu vào và nhận dạng giọng nói, thực hiện tương tác thông minh giữa người và máy, cung cấp trải nghiệm đối thoại tự nhiên và mượt mà</p>
  </div>
  
  <div class="feature-card">
    <div class="feature-icon">👁️</div>
    <h3>Đa phương thức hình ảnh</h3>
    <p>Hỗ trợ nhận dạng và xử lý hình ảnh, cung cấp khả năng tương tác đa phương thức, hiểu nội dung hình ảnh</p>
  </div>
  
  <div class="feature-card">
    <div class="feature-icon">🏠</div>
    <h3>Tích hợp thiết bị IoT</h3>
    <p>Hỗ trợ điều khiển thiết bị gia đình thông minh, thực hiện nhiều chức năng IoT hơn, xây dựng hệ sinh thái gia đình thông minh</p>
  </div>
  
  <div class="feature-card">
    <div class="feature-icon">🎵</div>
    <h3>Phát nhạc trực tuyến</h3>
    <p>Trình phát nhạc hiệu suất cao dựa trên pygame, hỗ trợ hiển thị lời bài hát và bộ nhớ đệm cục bộ</p>
  </div>
  
  <div class="feature-card">
    <div class="feature-icon">🔊</div>
    <h3>Đánh thức bằng giọng nói</h3>
    <p>Hỗ trợ kích hoạt tương tác bằng từ đánh thức, tránh phiền hà của thao tác thủ công (mặc định tắt, cần kích hoạt thủ công)</p>
  </div>
  
  <div class="feature-card">
    <div class="feature-icon">💬</div>
    <h3>Chế độ đối thoại tự động</h3>
    <p>Thực hiện trải nghiệm đối thoại liên tục, nâng cao độ mượt mà của tương tác người dùng</p>
  </div>
</div>

## Điểm nổi bật chức năng

### Giao diện đồ họa và chế độ dòng lệnh

<div class="feature-highlight">
  <div class="highlight-content">
    <h3>Các chế độ chạy đa dạng</h3>
    <ul>
      <li>Cung cấp GUI trực quan và dễ sử dụng, hỗ trợ biểu cảm Tiểu Trí và hiển thị văn bản</li>
      <li>Hỗ trợ chạy CLI, phù hợp với thiết bị nhúng hoặc môi trường không có GUI</li>
      <li>Hỗ trợ đa nền tảng, tương thích với Windows 10+, macOS 10.15+ và hệ thống Linux</li>
      <li>Giao diện điều khiển âm lượng thống nhất, thích ứng với nhu cầu môi trường khác nhau</li>
    </ul>
  </div>
</div>

### Kết nối an toàn và ổn định

<div class="feature-highlight reverse">
  <div class="highlight-content">
    <h3>Trải nghiệm kết nối tối ưu</h3>
    <ul>
      <li>Hỗ trợ giao thức WSS, đảm bảo an toàn dữ liệu âm thanh</li>
      <li>Lần đầu sử dụng, chương trình tự động sao chép mã xác thực và mở trình duyệt</li>
      <li>Tự động lấy địa chỉ MAC, tránh xung đột địa chỉ</li>
      <li>Chức năng kết nối lại khi ngắt, đảm bảo độ ổn định kết nối</li>
      <li>Tối ưu hóa tương thích đa nền tảng</li>
    </ul>
  </div>
</div>

## Yêu cầu hệ thống

- **Python**: 3.8+
- **Hệ điều hành**: Windows 10+, macOS 10.15+, Linux
- **Phụ thuộc**: PyAudio, PyQt5, pygame, websocket-client v.v.

## Cài đặt và sử dụng

### Phương pháp cài đặt

1. Sao chép kho dự án:
```bash
git clone https://github.com/huangjunsen0406/py-xiaozhi.git
```

2. Cài đặt phụ thuộc:
```bash
pip install -r requirements.txt
```

3. Chạy ứng dụng:
```bash
python main.py
```

## Giải thích cấu hình

Ứng dụng khách hỗ trợ nhiều tùy chọn cấu hình:

- Chọn thiết bị đầu vào/đầu ra giọng nói
- Điều khiển âm lượng
- Thiết lập từ đánh thức
- Thiết lập kết nối máy chủ
- Chuyển đổi chế độ GUI/CLI

## Liên kết liên quan

- [Kho GitHub của dự án](https://github.com/huangjunsen0406/py-xiaozhi)
- [Phản hồi vấn đề](https://github.com/huangjunsen0406/py-xiaozhi/issues)

<style>
.project-header {
  display: flex;
  align-items: center;
  margin-bottom: 2rem;
}

.project-badges {
  display: flex;
  gap: 0.5rem;
}

.badge {
  padding: 0.25rem 0.75rem;
  border-radius: 20px;
  font-size: 0.8rem;
  font-weight: 500;
}

.badge.platform {
  background-color: #e6f7ff;
  color: #0070f3;
}

.badge.language {
  background-color: #f0f0f0;
  color: #333;
}

.badge.status {
  background-color: #d4edda;
  color: #155724;
}

.app-showcase {
  margin: 2rem 0;
  padding: 1.5rem;
  background-color: var(--vp-c-bg-soft);
  border-radius: 8px;
}

.showcase-description {
  font-size: 1.1rem;
  line-height: 1.6;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.feature-card {
  padding: 1.5rem;
  border-radius: 8px;
  background-color: var(--vp-c-bg-soft);
  transition: all 0.3s ease;
}

.feature-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.feature-icon {
  font-size: 2rem;
  margin-bottom: 1rem;
}

.feature-card h3 {
  margin-bottom: 0.5rem;
  color: var(--vp-c-brand);
}

.feature-highlight {
  display: flex;
  margin: 3rem 0;
  gap: 2rem;
  align-items: center;
}

.feature-highlight.reverse {
  flex-direction: row-reverse;
}

.highlight-content {
  flex: 1;
}

.highlight-content h3 {
  color: var(--vp-c-brand);
  margin-bottom: 1rem;
}

.highlight-content ul {
  padding-left: 1.5rem;
}

.highlight-content li {
  margin-bottom: 0.5rem;
}

@media (max-width: 768px) {
  .feature-highlight {
    flex-direction: column;
  }
  
  .feature-highlight.reverse {
    flex-direction: column;
  }
  
  .features-grid {
    grid-template-columns: 1fr;
  }
}
</style>