<template>
  <section style="background-color: white; padding: 2rem 0;">
    <div class="container">
      <div style="display: grid; grid-template-columns: 1fr; gap: 2rem; align-items: center;">
        <!-- Left Content -->
        <div style="order: 1;">
          <h1 style="font-size: 2rem; font-weight: 700; margin-bottom: 2rem; line-height: 1.25;">
            대전 청년에게 꼭 필요한<br />
            모든 혜택, 청년있슈
          </h1>

          <div class="gt-sm" style="display: flex; flex-wrap: wrap; gap: 1rem;">
            <div style="display: flex; align-items: center; gap: 0.5rem; background-color: white; border: 1px solid #E5E7EB; padding: 0.5rem 1rem; border-radius: 9999px; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);">
              <q-icon name="auto_awesome" size="20px" color="orange" />
              <span style="font-size: 0.875rem; font-weight: 500; color: #374151;">19~39세 청년 맞춤 정보</span>
            </div>

            <div style="display: flex; align-items: center; gap: 0.5rem; background-color: white; border: 1px solid #E5E7EB; padding: 0.5rem 1rem; border-radius: 9999px; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);">
              <q-icon name="workspace_premium" size="20px" color="green" />
              <span style="font-size: 0.875rem; font-weight: 500; color: #374151;">중앙·지자체 정책 통합 검색</span>
            </div>

            <div style="display: flex; align-items: center; gap: 0.5rem; background-color: white; border: 1px solid #E5E7EB; padding: 0.5rem 1rem; border-radius: 9999px; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);">
              <q-icon name="workspace_premium" size="20px" color="blue" />
              <span style="font-size: 0.875rem; font-weight: 500; color: #374151;">실시간 혜택 알림 서비스</span>
            </div>
          </div>
        </div>

        <!-- Right Carousel -->
        <div style="order: 2;">
          <q-carousel
            v-model="slide"
            animated
            arrows
            navigation
            infinite
            autoplay
            :autoplay-interval="4000"
            transition-prev="slide-right"
            transition-next="slide-left"
            style="background-color: transparent; border-radius: 1.5rem; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);"
            height="400px"
          >
            <q-carousel-slide
              v-for="(news, index) in newsSlides"
              :key="index"
              :name="index"
              style="padding: 1.5rem; background-color: white; border-radius: 1.5rem;"
            >
              <div style="height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;">
                <img
                  :src="news.image"
                  :alt="news.title"
                  style="width: 100%; height: 100%; object-fit: contain; border-radius: 0.75rem;"
                />
              </div>
            </q-carousel-slide>
          </q-carousel>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import cardNewsImage from '../../assets/images/08c6d18da65336d7d8948b092b853e4fa233a8cf.png'

const slide = ref(0)

const newsSlides = [
  {
    title: '2026 꼭 알아야 할 청년정책',
    image: cardNewsImage
  },
  {
    title: '청년 일자리 지원 확대',
    image: cardNewsImage
  },
  {
    title: '주거 안정 지원 정책',
    image: cardNewsImage
  }
]
</script>

<style scoped>
.text-primary {
  color: #F97316;
}

.text-secondary {
  color: #A7E8BD;
}
</style>
