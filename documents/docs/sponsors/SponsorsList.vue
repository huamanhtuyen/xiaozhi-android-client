<script setup>
import { ref, onMounted } from 'vue'
import sponsorsData from './data.js'

const sponsors = ref([])
const isLoading = ref(true)
const error = ref(null)

onMounted(() => {
  try {
    // Sử dụng trực tiếp dữ liệu được import thay vì qua fetch request
    sponsors.value = sponsorsData.sponsors
    isLoading.value = false
  } catch (err) {
    console.error('Tải dữ liệu nhà tài trợ thất bại:', err)
    error.value = 'Tải dữ liệu nhà tài trợ thất bại, vui lòng làm mới trang để thử lại'
    isLoading.value = false
  }
})
</script>

<template>
  <div class="sponsors-container">
    <!-- Thông tin đầu trang -->
    <div class="sponsor-header">
      <p>Dù là tài nguyên giao diện, kiểm tra tương thích thiết bị hay hỗ trợ tài chính, mọi sự giúp đỡ đều giúp dự án hoàn thiện hơn</p>
      <p>Do bận rộn, những ai đã tham gia xây dựng trước đây có thể liên hệ với tôi để thêm thông tin của mọi người vào đây</p>
    </div>

    <!-- Danh sách nhà tài trợ -->
    <div v-if="isLoading" class="loading">
      <p>Đang tải thông tin nhà tài trợ...</p>
    </div>
    
    <div v-else-if="error" class="error">
      <p>{{ error }}</p>
    </div>
    
    <div v-else class="sponsors-grid">
      <div v-for="sponsor in sponsors" :key="sponsor.name" class="sponsor-item">
        <div class="sponsor-avatar">
          <img :src="sponsor.image" :alt="`${sponsor.name} avatar`" loading="lazy">
        </div>
        <div class="sponsor-name">
          <a v-if="sponsor.url" :href="sponsor.url" target="_blank" rel="noopener noreferrer">
            {{ sponsor.name }}
          </a>
          <span v-else>{{ sponsor.name }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.sponsors-container {
  width: 100%;
}

.sponsor-header {
  text-align: center;
  margin-bottom: 3rem;
}

.sponsors-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
  gap: 2rem;
  margin: 3rem 0;
}

.sponsor-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  transition: transform 0.2s ease;
}

.sponsor-item:hover {
  transform: translateY(-5px);
}

.sponsor-avatar {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  overflow: hidden;
  margin-bottom: 0.75rem;
  border: 2px solid var(--vp-c-divider);
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.sponsor-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.sponsor-name {
  font-size: 1rem;
  font-weight: 500;
}

.sponsor-name a {
  color: var(--vp-c-brand);
  text-decoration: none;
}

.sponsor-name a:hover {
  text-decoration: underline;
}

.loading, .error {
  text-align: center;
  padding: 2rem;
  color: var(--vp-c-text-2);
}

@media (max-width: 768px) {
  .sponsors-grid {
    grid-template-columns: repeat(auto-fill, minmax(110px, 1fr));
    gap: 1.5rem;
  }
  
  .sponsor-avatar {
    width: 70px;
    height: 70px;
  }
}
</style> 