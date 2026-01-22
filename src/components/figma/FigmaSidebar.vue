<template>
  <aside
    class="gt-md"
    style="position: sticky; top: 80px; height: fit-content; width: 250px;"
  >
    <q-card style="padding: 1.5rem;">
      <q-card-section style="padding: 0;">
        <h3 style="font-size: 1.125rem; font-weight: 700; margin-bottom: 1rem; color: #1e3a8a;">
          빠른 메뉴
        </h3>

        <div style="display: flex; flex-direction: column; gap: 0.5rem;">
          <q-btn
            unelevated
            no-caps
            align="left"
            icon="local_cafe"
            label="청년정책카페"
            @click="goToCafe"
            style="background: linear-gradient(135deg, #F97316 0%, #EA580C 100%); color: white; padding: 0.75rem 1rem; justify-content: flex-start; font-weight: 600;"
          />

          <q-separator style="margin: 0.5rem 0;" />

          <div style="padding: 0.5rem 0;">
            <p style="font-size: 0.75rem; color: #6B7280; margin-bottom: 0.5rem;">정책 카테고리</p>

            <q-btn
              v-for="category in categories"
              :key="category.name"
              flat
              no-caps
              dense
              align="left"
              :label="category.name"
              :icon="category.icon"
              @click="() => goToCategory(category.name)"
              style="width: 100%; justify-content: flex-start; color: #374151; padding: 0.5rem; font-size: 0.875rem;"
              class="hover-bg-gray"
            />
          </div>
        </div>
      </q-card-section>
    </q-card>

    <!-- 추가 정보 카드 -->
    <q-card style="padding: 1.5rem; margin-top: 1rem; background-color: #FFF7ED;">
      <q-card-section style="padding: 0;">
        <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.75rem;">
          <q-icon name="info" size="20px" color="orange" />
          <h4 style="font-size: 0.875rem; font-weight: 600; color: #1e3a8a;">알림</h4>
        </div>
        <p style="font-size: 0.75rem; color: #4B5563; line-height: 1.5;">
          청년정책카페에서 다른 청년들과 정보를 공유하고 소통하세요!
        </p>
      </q-card-section>
    </q-card>
  </aside>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'

const router = useRouter()

const categories = [
  { name: '일자리', icon: 'work' },
  { name: '주거', icon: 'home' },
  { name: '교육', icon: 'school' },
  { name: '금융･복지･문화', icon: 'account_balance' },
  { name: '참여', icon: 'groups' }
]

const goToCafe = () => {
  router.push('/coming-soon')
}

const goToCategory = (categoryName: string) => {
  router.push({ name: 'category', params: { category: categoryName } })
}
</script>

<style scoped>
.hover-bg-gray:hover {
  background-color: #F3F4F6;
}
</style>
