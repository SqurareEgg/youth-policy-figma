<template>
  <section style="background-color: #F9FAFB; padding: 2rem 0;">
    <div style="width: 100%;">
      <!-- 섹션 헤더 -->
      <div class="mb-8 sm:mb-12">
        <h2 class="text-2xl sm:text-3xl font-bold mb-2 sm:mb-4">
          청년을 위한 5가지 정책
        </h2>
        <p class="text-sm sm:text-base text-gray-600">
          청년 여러분의 꿈을 응원하는 맞춤형 정책을 확인해보세요
        </p>
      </div>

      <!-- 카드 그리드 -->
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
        <div
          v-for="card in cards"
          :key="card.id"
          @click="() => handleCardClick(card.slug)"
          :style="{ background: card.gradient }"
          class="rounded-2xl p-6 text-white shadow-lg hover:shadow-xl transition-shadow cursor-pointer relative"
        >
          <!-- 카드 헤더 -->
          <div class="flex items-start justify-between mb-4 sm:mb-6">
            <h3 class="text-xl sm:text-2xl font-bold">{{ card.title }}</h3>
            <div
              class="w-10 h-10 sm:w-12 sm:h-12 bg-white/20 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform"
            >
              <q-icon :name="card.icon" size="20px" class="sm:w-6 sm:h-6" />
            </div>
          </div>

          <!-- 카드 설명 -->
          <p class="text-sm text-white/90 mb-4">
            {{ card.description }}
          </p>

          <!-- 인기 배지 -->
          <div v-if="card.popular" class="absolute top-2 right-2 bg-red-500 text-white text-xs px-2 py-1 rounded-full">
            인기
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useCategories } from '../../composables/useCategories'

const router = useRouter()
const { categories, fetchCategories } = useCategories()

const gradients = [
  'linear-gradient(135deg, #3B82F6 0%, #2563EB 100%)',
  'linear-gradient(135deg, #F97316 0%, #EA580C 100%)',
  'linear-gradient(135deg, #4ADE80 0%, #22C55E 100%)',
  'linear-gradient(135deg, #F472B6 0%, #EC4899 100%)',
  'linear-gradient(135deg, #2DD4BF 0%, #14B8A6 100%)'
]

const cards = ref<any[]>([])

onMounted(async () => {
  await fetchCategories()

  // 카테고리 데이터를 카드 형식으로 변환
  cards.value = categories.value.map((category, index) => ({
    id: category.id,
    title: category.name,
    icon: category.icon,
    description: category.description || '',
    gradient: gradients[index % gradients.length],
    category: category.name,
    slug: category.slug,
    popular: category.name === '참여'  // 참여 카테고리를 인기로 설정
  }))
})

const handleCardClick = (category: string) => {
  router.push({ name: 'category', params: { category } })
}
</script>

<style scoped>
.text-primary {
  color: #F97316;
}
</style>
