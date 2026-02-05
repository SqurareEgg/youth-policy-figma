<template>
  <section class="py-12 sm:py-16 lg:py-20 bg-white">
    <div class="container mx-auto px-4 sm:px-6">
      <!-- 섹션 헤더 -->
      <div class="mb-10 sm:mb-12">
        <h2 class="text-2xl sm:text-3xl font-bold mb-3" style="line-height: 1.3;">분야별 청년정책</h2>
        <p class="text-base sm:text-lg text-gray-600" style="line-height: 1.5;">
          내게 필요한 정책을 분야별로 확인하세요
        </p>
      </div>

      <!-- 카드 그리드 -->
      <div class="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-3 gap-3 sm:gap-6">
        <div
          v-for="(card, index) in cards"
          :key="card.id"
          @click="() => handleCardClick(card.slug)"
          :class="[
            'bg-white rounded-2xl p-4 sm:p-7 transition-all cursor-pointer',
            index === 0 ? 'sm:col-span-2 lg:col-span-1' : ''
          ]"
          style="border: 1px solid #E5E7EB; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);"
        >
          <!-- 카드 헤더 -->
          <div class="card-header">
            <div
              class="card-icon"
              :style="{ backgroundColor: card.iconBgColor }"
            >
              <q-icon :name="card.icon" class="card-icon-svg" :style="{ color: card.iconColorHex }" />
            </div>
            <div class="card-content">
              <h3 class="card-title">
                {{ card.title }}
              </h3>
              <p class="card-description">
                {{ card.description }}
              </p>
            </div>
          </div>

          <!-- 주요 정책 예시 -->
          <div class="card-examples">
            <p class="examples-title">주요 정책 예시</p>
            <ul class="examples-list">
              <li
                v-for="(example, idx) in card.examples"
                :key="idx"
                class="example-item"
              >
                <span class="example-bullet">·</span>
                <span class="example-text">{{ example }}</span>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

const cards = [
  {
    id: 1,
    title: '일자리',
    icon: 'business_center',
    iconBgColor: '#EFF6FF',
    iconColorHex: '#2563EB',
    description: '취업 준비부터 직장 생활까지, 청년 고용을 돕는 정책',
    slug: 'job',
    examples: [
      '청년도전지원사업',
      '국민취업지원제도',
      '청년내일채움공제'
    ]
  },
  {
    id: 2,
    title: '주거',
    icon: 'home',
    iconBgColor: '#FFF7ED',
    iconColorHex: '#EA580C',
    description: '주거비 부담을 줄이고 안정적인 삶의 터전 마련 지원',
    slug: 'housing',
    examples: [
      '청년 전월세보증금 대출',
      '행복주택',
      '주거급여'
    ]
  },
  {
    id: 3,
    title: '교육',
    icon: 'school',
    iconBgColor: '#F0FDF4',
    iconColorHex: '#16A34A',
    description: '배움의 기회 확대와 미래를 위한 역량 개발 지원',
    slug: 'education',
    examples: [
      '학자금 대출',
      '평생교육 바우처',
      '직업능력개발훈련'
    ]
  },
  {
    id: 4,
    title: '금융･복지･문화',
    icon: 'favorite',
    iconBgColor: '#FDF2F8',
    iconColorHex: '#DB2777',
    description: '생활비 지원부터 문화생활까지, 청년의 일상을 돕는 정책',
    slug: 'finance-welfare-culture',
    examples: [
      '청년내일저축계좌',
      '문화누리카드',
      '청년 마음건강 지원'
    ]
  },
  {
    id: 5,
    title: '참여',
    icon: 'groups',
    iconBgColor: '#FAF5FF',
    iconColorHex: '#9333EA',
    description: '정책 제안과 권리보호, 청년의 목소리를 반영하는 활동',
    slug: 'participation',
    examples: [
      '청년정책참여단',
      '청년활동지원금',
      '청년정책네트워크'
    ]
  },
  {
    id: 6,
    title: '청년정책 카페',
    icon: 'local_cafe',
    iconBgColor: '#F0FDFA',
    iconColorHex: '#0D9488',
    description: '청년들의 소통 공간, 정책 의견 공유 및 토론',
    slug: 'cafe',
    examples: [
      '자유게시판',
      '정책제안',
      '질문과 답변'
    ]
  }
]

const handleCardClick = (slug: string) => {
  // 청년 정책 카페는 준비중 페이지로 이동
  if (slug === 'cafe') {
    router.push({ name: 'coming-soon' })
  } else {
    router.push({ name: 'category', params: { category: slug } })
  }
}
</script>

<style scoped>
.text-primary {
  color: #F97316;
}

/* 카드 헤더 */
.card-header {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.75rem;
  text-align: center;
}

@media (min-width: 640px) {
  .card-header {
    flex-direction: row;
    align-items: flex-start;
    gap: 1rem;
    margin-bottom: 1.25rem;
    text-align: left;
  }
}

.card-icon {
  width: 40px;
  height: 40px;
  border-radius: 0.75rem;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-top: 0;
}

@media (min-width: 640px) {
  .card-icon {
    width: 52px;
    height: 52px;
    margin-top: 3px;
  }
}

.card-icon-svg {
  font-size: 20px;
}

@media (min-width: 640px) {
  .card-icon-svg {
    font-size: 26px;
  }
}

.card-content {
  flex: 1;
  min-width: 0;
}

.card-title {
  font-size: 0.9375rem;
  font-weight: 700;
  margin-bottom: 0.25rem;
  line-height: 1.3;
  color: #111827;
  margin-top: 0;
}

@media (min-width: 640px) {
  .card-title {
    font-size: 1.5rem;
    margin-bottom: 0.375rem;
  }
}

.card-description {
  font-size: 0.6875rem;
  color: #6B7280;
  line-height: 1.4;
  margin: 0;
}

@media (min-width: 640px) {
  .card-description {
    font-size: 0.875rem;
    line-height: 1.5;
  }
}

/* 주요 정책 예시 */
.card-examples {
  padding-top: 0.5rem;
  border-top: 1px solid #F3F4F6;
}

@media (min-width: 640px) {
  .card-examples {
    padding-top: 0.75rem;
  }
}

.examples-title {
  font-size: 0.625rem;
  color: #9CA3AF;
  margin-bottom: 0.25rem;
  padding: 0;
}

@media (min-width: 640px) {
  .examples-title {
    font-size: 0.75rem;
    margin-bottom: 0.5rem;
  }
}

.examples-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
}

@media (min-width: 640px) {
  .examples-list {
    gap: 0.375rem;
  }
}

.example-item {
  display: flex;
  align-items: flex-start;
  gap: 0.25rem;
  padding: 0;
  margin: 0;
}

@media (min-width: 640px) {
  .example-item {
    gap: 0.5rem;
  }
}

.example-bullet {
  color: #D1D5DB;
  margin-top: 0.125rem;
  flex-shrink: 0;
  line-height: 1.4;
}

.example-text {
  flex: 1;
  font-size: 0.6875rem;
  color: #374151;
  line-height: 1.4;
}

@media (min-width: 640px) {
  .example-text {
    font-size: 0.875rem;
    line-height: 1.5;
  }
}
</style>
