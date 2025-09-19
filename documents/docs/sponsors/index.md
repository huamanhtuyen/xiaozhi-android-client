---
title: Hỗ trợ tài trợ
description: Cảm ơn sự hỗ trợ của tất cả nhà tài trợ
sidebar: false
outline: deep
---

<script setup>
import SponsorsList from './SponsorsList.vue'
</script>

<div class="sponsors-page">

# Hỗ trợ tài trợ

<div class="header-content">
  <h2>Cảm ơn sự hỗ trợ của tất cả nhà tài trợ ❤️</h2>
</div>

<div class="sponsors-section">

<SponsorsList />

## Trở thành nhà tài trợ

Vui lòng tài trợ qua các cách sau:
Sự tài trợ của bạn sẽ được sử dụng cho:
- Hỗ trợ kiểm tra tương thích thiết bị
- Phát triển và bảo trì tính năng mới

<div class="payment-container">
  <div class="payment-method">
    <h4>Thanh toán WeChat</h4>
    <div class="qr-code">
      <img src="./images/zsm.jpg" alt="Mã thu WeChat">
    </div>
  </div>
</div>

### Hỗ trợ tương thích thiết bị

Bạn có thể hỗ trợ tương thích thiết bị qua các cách sau:
- Trong ghi chú tài trợ, chỉ rõ model thiết bị của bạn, tôi sẽ ưu tiên hỗ trợ những thiết bị này
- Trực tiếp tài trợ/quyên góp thiết bị phần cứng, giúp tôi phát triển và kiểm tra tương thích
- Cung cấp thông số chi tiết và kịch bản sử dụng của thiết bị, để tôi phát triển tốt hơn

::: tip Thông tin liên hệ
Đối với tài trợ phần cứng, vui lòng liên hệ qua email trên trang GitHub của tôi để thảo luận cách gửi và địa chỉ
:::

</div>

</div>

<style>
.sponsors-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 2rem 1.5rem;
}

.sponsors-page h1 {
  text-align: center;
  margin-bottom: 1rem;
}

.header-content {
  text-align: center;
}

.header-content h2 {
  color: var(--vp-c-brand);
  margin-bottom: 1rem;
}

.sponsors-section h2, .sponsors-section h3 {
  margin-top: 3rem;
  padding-top: 1rem;
  border-top: 1px solid var(--vp-c-divider);
}

.payment-container {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 2.5rem;
  margin: 2rem 0;
}

.payment-method {
  text-align: center;
  border: 1px solid var(--vp-c-divider);
  border-radius: 8px;
  padding: 1.5rem;
  transition: all 0.3s ease;
}

.payment-method:hover {
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  transform: translateY(-5px);
}

.payment-method h4 {
  margin-top: 0;
  margin-bottom: 1rem;
}

.qr-code {
  width: 200px;
  height: 200px;
  margin: 0 auto;
  overflow: hidden;
}

.qr-code img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

@media (max-width: 768px) {
  .payment-container {
    grid-template-columns: 1fr;
  }
  
  .qr-code {
    width: 180px;
    height: 180px;
  }
}
</style>