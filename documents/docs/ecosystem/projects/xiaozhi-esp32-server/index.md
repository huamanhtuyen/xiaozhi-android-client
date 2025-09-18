---
title: xiaozhi-esp32-server
description: Dịch vụ server mã nguồn mở xiaozhi-esp32 dựa trên ESP32, nhẹ nhàng và hiệu quả cho tương tác giọng nói
---

# xiaozhi-esp32-server

<div class="project-header">
  <div class="project-logo">
    <img src="./images/logo.png" alt="xiaozhi-esp32-server Logo" onerror="this.src='/py-xiaozhi/images/logo.png'; this.onerror=null;">
  </div>
  <div class="project-badges">
    <span class="badge platform">ESP32</span>
    <span class="badge language">Python</span>
    <span class="badge status">Đang phát triển tích cực</span>
  </div>
</div>

<div class="project-intro">
  <p>xiaozhi-esp32-server là dịch vụ backend được cung cấp cho dự án phần cứng thông minh mã nguồn mở <a href="https://github.com/78/xiaozhi-esp32" target="_blank">xiaozhi-esp32</a>, được triển khai bằng Python dựa trên <a href="https://ccnphfhqs21z.feishu.cn/wiki/M0XiwldO9iJwHikpXD5cEx71nKh" target="_blank">Giao thức giao tiếp xiaozhi</a>, giúp bạn nhanh chóng thiết lập server xiaozhi.</p>
</div>

## Đối tượng phù hợp

Dự án này cần được sử dụng cùng với thiết bị phần cứng ESP32. Nếu bạn đã mua phần cứng liên quan đến ESP32 và đã kết nối thành công với dịch vụ backend do xiaoge triển khai, và bạn muốn tự thiết lập dịch vụ backend `xiaozhi-esp32` độc lập, thì dự án này rất phù hợp với bạn.

<div class="warning-box">
  <h3>⚠️ Lưu ý quan trọng</h3>
  <ol>
    <li>Dự án này là phần mềm mã nguồn mở, không có bất kỳ mối quan hệ hợp tác thương mại nào với bất kỳ nhà cung cấp dịch vụ API bên thứ ba nào (bao gồm nhưng không giới hạn ở các nền tảng nhận dạng giọng nói, mô hình lớn, tổng hợp giọng nói, v.v.), không cung cấp bất kỳ hình thức bảo đảm nào cho chất lượng dịch vụ và an toàn tài chính của chúng. Khuyến nghị người dùng ưu tiên chọn các nhà cung cấp dịch vụ có giấy phép kinh doanh liên quan và đọc kỹ thỏa thuận dịch vụ cũng như chính sách bảo mật của họ. Phần mềm này không lưu trữ bất kỳ khóa tài khoản nào, không tham gia vào luồng tiền, không chịu trách nhiệm rủi ro mất tiền nạp.</li>
    <li>Dự án này được thành lập chưa lâu, chưa qua đánh giá an ninh mạng, vui lòng không sử dụng trong môi trường sản xuất. Nếu bạn triển khai dự án này trong môi trường mạng công cộng, hãy chắc chắn kích hoạt bảo vệ trong file cấu hình <code>config.yaml</code>.</li>
  </ol>
</div>

## Đặc điểm cốt lõi

<div class="features-container">
  <div class="feature-item">
    <div class="feature-icon">🔄</div>
    <h3>Giao thức giao tiếp</h3>
    <p>Dựa trên giao thức <code>xiaozhi-esp32</code>, thực hiện tương tác dữ liệu qua WebSocket</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">💬</div>
    <h3>Tương tác đối thoại</h3>
    <p>Hỗ trợ đánh thức đối thoại, đối thoại thủ công và ngắt lời thời gian thực, tự động ngủ khi không có đối thoại trong thời gian dài</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">🧠</div>
    <h3>Nhận dạng ý định</h3>
    <p>Hỗ trợ nhận dạng ý định LLM, gọi hàm function call, giảm phán đoán ý định mã hóa cứng</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">🌐</div>
    <h3>Nhận dạng đa ngôn ngữ</h3>
    <p>Hỗ trợ tiếng Quan Thoại, tiếng Quảng Đông, tiếng Anh, tiếng Nhật, tiếng Hàn (mặc định sử dụng FunASR)</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">🤖</div>
    <h3>Mô-đun LLM</h3>
    <p>Hỗ trợ chuyển đổi linh hoạt mô-đun LLM, mặc định sử dụng ChatGLMLLM, cũng có thể chọn Alibaba Bailian, DeepSeek, Ollama, v.v.</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">🔊</div>
    <h3>Mô-đun TTS</h3>
    <p>Hỗ trợ EdgeTTS (mặc định), Volcano Engine Doubao TTS và nhiều giao diện TTS khác, đáp ứng nhu cầu tổng hợp giọng nói</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">📝</div>
    <h3>Chức năng bộ nhớ</h3>
    <p>Hỗ trợ ba chế độ: bộ nhớ siêu dài, bộ nhớ tóm tắt cục bộ, không bộ nhớ, đáp ứng nhu cầu các cảnh khác nhau</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">🏠</div>
    <h3>Chức năng IOT</h3>
    <p>Hỗ trợ quản lý chức năng IOT thiết bị đăng ký, hỗ trợ điều khiển IoT thông minh dựa trên ngữ cảnh đối thoại</p>
  </div>
  
  <div class="feature-item">
    <div class="feature-icon">🖥️</div>
    <h3>Bảng điều khiển thông minh</h3>
    <p>Cung cấp giao diện quản lý Web, hỗ trợ quản lý agent thông minh, quản lý người dùng, cấu hình hệ thống, v.v.</p>
  </div>
</div>

## Cách triển khai

Dự án cung cấp hai cách triển khai, vui lòng chọn theo nhu cầu cụ thể của bạn:

<div class="deployment-table">
  <table>
    <thead>
      <tr>
        <th>Cách triển khai</th>
        <th>Đặc điểm</th>
        <th>Cảnh sử dụng phù hợp</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><strong>Cài đặt đơn giản nhất</strong></td>
        <td>Đối thoại thông minh, chức năng IOT, dữ liệu lưu trữ trong file cấu hình</td>
        <td>Môi trường cấu hình thấp, không cần cơ sở dữ liệu</td>
      </tr>
      <tr>
        <td><strong>Cài đặt đầy đủ mô-đun</strong></td>
        <td>Đối thoại thông minh, IOT, OTA, bảng điều khiển thông minh, dữ liệu lưu trữ trong cơ sở dữ liệu</td>
        <td>Trải nghiệm chức năng đầy đủ</td>
      </tr>
    </tbody>
  </table>
</div>

Tài liệu triển khai chi tiết vui lòng tham khảo:
- [Tài liệu triển khai Docker](https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/Deployment.md)
- [Tài liệu triển khai mã nguồn](https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/Deployment_all.md)

## Danh sách nền tảng hỗ trợ

xiaozhi-esp32-server hỗ trợ nhiều nền tảng và thành phần bên thứ ba phong phú:

### Mô hình ngôn ngữ LLM

<div class="platform-item">
  <h4>Gọi giao diện</h4>
  <p><strong>Nền tảng hỗ trợ:</strong> Alibaba Bailian, Volcano Engine Doubao, DeepSeek, Zhipu ChatGLM, Gemini, Ollama, Dify, Fastgpt, Coze</p>
  <p><strong>Nền tảng miễn phí:</strong> Zhipu ChatGLM, Gemini</p>
  <p><em>Thực tế, bất kỳ LLM nào hỗ trợ gọi giao diện openai đều có thể kết nối và sử dụng</em></p>
</div>

### Tổng hợp giọng nói TTS

<div class="platform-item">
  <h4>Gọi giao diện</h4>
  <p><strong>Nền tảng hỗ trợ:</strong> EdgeTTS, Volcano Engine Doubao TTS, Tencent Cloud, Alibaba Cloud TTS, CosyVoiceSiliconflow, TTS302AI, CozeCnTTS, GizwitsTTS, ACGNTTS, OpenAITTS</p>
  <p><strong>Nền tảng miễn phí:</strong> EdgeTTS, CosyVoiceSiliconflow (một phần)</p>
  
  <h4>Dịch vụ cục bộ</h4>
  <p><strong>Nền tảng hỗ trợ:</strong> FishSpeech, GPT_SOVITS_V2, GPT_SOVITS_V3, MinimaxTTS</p>
  <p><strong>Nền tảng miễn phí:</strong> FishSpeech, GPT_SOVITS_V2, GPT_SOVITS_V3, MinimaxTTS</p>
</div>

### Nhận dạng giọng nói ASR

<div class="platform-item">
  <h4>Gọi giao diện</h4>
  <p><strong>Nền tảng hỗ trợ:</strong> DoubaoASR</p>
  
  <h4>Dịch vụ cục bộ</h4>
  <p><strong>Nền tảng hỗ trợ:</strong> FunASR, SherpaASR</p>
  <p><strong>Nền tảng miễn phí:</strong> FunASR, SherpaASR</p>
</div>

### Các thành phần khác

- **Phát hiện hoạt động giọng nói VAD**: Hỗ trợ SileroVAD (sử dụng miễn phí cục bộ)
- **Lưu trữ bộ nhớ**: Hỗ trợ mem0ai (1000 lần/tháng), mem_local_short (tóm tắt cục bộ, miễn phí)
- **Nhận dạng ý định**: Hỗ trợ intent_llm (nhận dạng ý định qua mô hình lớn), function_call (hoàn thành ý định qua gọi hàm mô hình lớn)

## Tham gia đóng góp

xiaozhi-esp32-server là một dự án mã nguồn mở đang hoạt động tích cực, chào đón đóng góp mã nguồn hoặc gửi phản hồi vấn đề:

- [Kho GitHub](https://github.com/xinnan-tech/xiaozhi-esp32-server)
- [Phản hồi vấn đề](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues)
- [Thư ngỏ gửi nhà phát triển](https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/contributor_open_letter.md)

<style>
.project-header {
  display: flex;
  align-items: center;
  margin-bottom: 2rem;
}

.project-logo {
  width: 100px;
  height: 100px;
  margin-right: 1.5rem;
}

.project-logo img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

.project-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.badge {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 1rem;
  font-size: 0.85rem;
  font-weight: 500;
}

.badge.platform {
  background-color: var(--vp-c-brand-soft);
  color: var(--vp-c-brand-dark);
}

.badge.language {
  background-color: rgba(59, 130, 246, 0.2);
  color: rgb(59, 130, 246);
}

.badge.status {
  background-color: rgba(16, 185, 129, 0.2);
  color: rgb(16, 185, 129);
}

.project-intro {
  font-size: 1.1rem;
  line-height: 1.6;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background-color: var(--vp-c-bg-soft);
  border-radius: 8px;
  border-left: 4px solid var(--vp-c-brand);
}

.warning-box {
  margin: 2rem 0;
  padding: 1.5rem;
  background-color: rgba(234, 179, 8, 0.1);
  border-left: 4px solid rgba(234, 179, 8, 0.8);
  border-radius: 8px;
}

.warning-box h3 {
  color: rgb(234, 179, 8);
  margin-top: 0;
}

.features-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.feature-item {
  background-color: var(--vp-c-bg-soft);
  border-radius: 8px;
  padding: 1.5rem;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  border: 1px solid var(--vp-c-divider);
}

.feature-item:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.feature-icon {
  font-size: 2rem;
  margin-bottom: 1rem;
}

.feature-item h3 {
  color: var(--vp-c-brand);
  margin-top: 0;
  margin-bottom: 0.5rem;
}

.deployment-table {
  margin: 2rem 0;
  overflow-x: auto;
}

.deployment-table table {
  width: 100%;
  border-collapse: collapse;
}

.deployment-table th, 
.deployment-table td {
  padding: 1rem;
  text-align: left;
  border-bottom: 1px solid var(--vp-c-divider);
}

.deployment-table th {
  background-color: var(--vp-c-bg-soft);
  font-weight: 500;
}

.platform-item {
  margin: 1.5rem 0;
  padding: 1.5rem;
  background-color: var(--vp-c-bg-soft);
  border-radius: 8px;
}

.platform-item h4 {
  color: var(--vp-c-brand);
  margin-top: 0;
  margin-bottom: 1rem;
}

.platform-item p {
  margin: 0.5rem 0;
}

.demo-videos {
  margin: 2rem 0;
}

.video-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.5rem;
}

.video-item {
  display: block;
  text-decoration: none;
  color: inherit;
  border-radius: 8px;
  overflow: hidden;
  transition: transform 0.3s ease;
  background-color: var(--vp-c-bg-soft);
}

.video-item:hover {
  transform: translateY(-5px);
}

.video-thumbnail {
  width: 100%;
  aspect-ratio: 16 / 9;
  overflow: hidden;
}

.video-thumbnail img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.video-item:hover .video-thumbnail img {
  transform: scale(1.05);
}

.video-title {
  padding: 1rem;
  font-weight: 500;
}

.demo-more {
  text-align: center;
  margin-top: 1.5rem;
}

.demo-more a {
  display: inline-block;
  padding: 0.5rem 1.5rem;
  background-color: var(--vp-c-brand);
  color: white;
  border-radius: 4px;
  text-decoration: none;
  transition: background-color 0.3s ease;
}

.demo-more a:hover {
  background-color: var(--vp-c-brand-dark);
}

.related-projects {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.project-card {
  background-color: var(--vp-c-bg-soft);
  border-radius: 8px;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  border: 1px solid var(--vp-c-divider);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.project-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.project-card h3 {
  color: var(--vp-c-brand);
  margin-top: 0;
  margin-bottom: 1rem;
}

.project-link {
  margin-top: auto;
  display: inline-block;
  padding: 0.5rem 1rem;
  background-color: var(--vp-c-brand);
  color: white;
  text-decoration: none;
  border-radius: 4px;
  text-align: center;
  transition: background-color 0.3s ease;
}

.project-link:hover {
  background-color: var(--vp-c-brand-dark);
}

.contributors {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 2rem;
  margin: 2rem 0;
}

.contributor {
  background-color: var(--vp-c-bg-soft);
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
  border: 1px solid var(--vp-c-divider);
}

.contributor img {
  width: 120px;
  height: 60px;
  object-fit: contain;
  margin-bottom: 1rem;
}

.contributor h4 {
  color: var(--vp-c-brand);
  margin-top: 0;
  margin-bottom: 0.5rem;
}

@media (max-width: 768px) {
  .project-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .project-logo {
    margin-bottom: 1rem;
  }
  
  .contributors {
    grid-template-columns: 1fr;
  }
  
  .related-projects {
    grid-template-columns: 1fr;
  }
  
  .features-container {
    grid-template-columns: 1fr;
  }
}
</style>