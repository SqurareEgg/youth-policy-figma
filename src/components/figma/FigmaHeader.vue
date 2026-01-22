<template>
  <header style="background-color: white; border-bottom: 1px solid #E5E7EB; position: sticky; top: 0; z-index: 50;">
    <div class="container" style="height: 64px; display: flex; align-items: center; justify-content: space-between; padding: 0 1rem;">
      <!-- 로고 -->
      <button
        @click="handleLogoClick"
        style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer; border: none; background: none; padding: 0;"
      >
        <span style="font-size: 1.5rem; font-weight: 700; color: #1e3a8a;">
          청년있슈
        </span>
      </button>

      <!-- 중앙 카테고리 - Desktop -->
      <nav class="gt-md" style="display: flex; gap: 1.5rem;">
        <q-btn
          v-for="category in categories"
          :key="category.name"
          flat
          no-caps
          :label="category.name"
          @click="() => handleCategoryClick(category.name)"
          :style="{
            color: currentCategory === category.name ? '#F97316' : '#374151',
            fontWeight: currentCategory === category.name ? '600' : '400',
            backgroundColor: currentCategory === category.name ? '#FFF7ED' : 'transparent'
          }"
          style="font-size: 0.875rem;"
        />
      </nav>

      <!-- 우측 로그인/회원가입 - Desktop -->
      <div class="gt-sm" style="display: flex; align-items: center; gap: 0.75rem;">
        <q-btn
          flat
          no-caps
          label="로그인"
          @click="handleLoginClick"
          style="color: #374151; font-size: 0.875rem;"
        />
        <q-btn
          unelevated
          no-caps
          label="회원가입"
          @click="handleSignupClick"
          style="background-color: #F97316; color: white; font-size: 0.875rem; padding: 0.5rem 1rem;"
        />
      </div>

      <!-- Mobile Menu Button -->
      <q-btn
        flat
        dense
        round
        icon="menu"
        @click="mobileMenuOpen = !mobileMenuOpen"
        class="lg:hidden"
      />
    </div>

    <!-- Mobile Navigation -->
    <div v-if="mobileMenuOpen" style="background-color: white; border-top: 1px solid #E5E7EB;">
      <div class="container" style="padding: 1rem; display: flex; flex-direction: column; gap: 0.75rem;">
        <!-- 카테고리 -->
        <div style="padding-bottom: 0.75rem; border-bottom: 1px solid #E5E7EB;">
          <p style="font-size: 0.75rem; color: #6B7280; margin-bottom: 0.5rem;">카테고리</p>
          <q-btn
            v-for="category in categories"
            :key="category.name"
            flat
            no-caps
            align="left"
            :label="category.name"
            @click="() => handleCategoryClick(category.name)"
            :style="{
              color: currentCategory === category.name ? '#F97316' : '#374151',
              fontWeight: currentCategory === category.name ? '600' : '400',
              width: '100%',
              justifyContent: 'flex-start'
            }"
            style="font-size: 0.875rem; padding: 0.5rem 0;"
          />
        </div>
        <!-- 로그인/회원가입 -->
        <q-btn
          flat
          no-caps
          align="left"
          label="로그인"
          @click="handleLoginClick"
          style="color: #374151; font-size: 0.875rem; justify-content: flex-start; width: 100%;"
        />
        <q-btn
          unelevated
          no-caps
          label="회원가입"
          @click="handleSignupClick"
          style="background-color: #F97316; color: white; font-size: 0.875rem; width: 100%;"
        />
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'

interface Props {
  currentCategory?: string | null
}

const props = withDefaults(defineProps<Props>(), {
  currentCategory: null
})

const router = useRouter()
const mobileMenuOpen = ref(false)

const categories = [
  { name: '일자리' },
  { name: '주거' },
  { name: '교육' },
  { name: '금융･복지･문화' },
  { name: '참여' }
]

const handleCategoryClick = (categoryName: string) => {
  mobileMenuOpen.value = false
  router.push({ name: 'category', params: { category: categoryName } })
}

const handleLogoClick = () => {
  router.push('/figma')
}

const handleLoginClick = () => {
  router.push({ name: 'figma-login' })
}

const handleSignupClick = () => {
  router.push({ name: 'figma-signup' })
}
</script>

<style scoped>
.text-primary {
  color: #F97316;
}

.bg-primary {
  background-color: #F97316;
}

.hover\:text-primary:hover {
  color: #F97316;
}

.hover\:bg-orange-600:hover {
  background-color: #EA580C;
}
</style>
