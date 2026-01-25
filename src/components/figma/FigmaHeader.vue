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
          @click="() => handleCategoryClick(category.slug)"
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
        <template v-if="isAuthenticated">
          <span style="color: #374151; font-size: 0.875rem;">{{ profile?.name || user?.email }}님</span>
          <q-btn
            flat
            no-caps
            label="로그아웃"
            @click="handleLogout"
            style="color: #374151; font-size: 0.875rem;"
          />
        </template>
        <template v-else>
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
        </template>
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
            @click="() => handleCategoryClick(category.slug)"
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
        <template v-if="isAuthenticated">
          <div style="padding: 0.75rem 0; border-top: 1px solid #E5E7EB;">
            <p style="color: #374151; font-size: 0.875rem; margin-bottom: 0.5rem;">{{ profile?.name || user?.email }}님</p>
            <q-btn
              flat
              no-caps
              align="left"
              label="로그아웃"
              @click="handleLogout"
              style="color: #374151; font-size: 0.875rem; justify-content: flex-start; width: 100%;"
            />
          </div>
        </template>
        <template v-else>
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
        </template>
      </div>
    </div>
  </header>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { useAuth } from '../../composables/useAuth'

interface Props {
  currentCategory?: string | null
}

const props = withDefaults(defineProps<Props>(), {
  currentCategory: null
})

const router = useRouter()
const $q = useQuasar()
const { user, profile, isAuthenticated, signOut } = useAuth()
const mobileMenuOpen = ref(false)

const categories = [
  { name: '일자리', slug: 'job' },
  { name: '주거', slug: 'housing' },
  { name: '교육', slug: 'education' },
  { name: '금융･복지･문화', slug: 'finance-welfare-culture' },
  { name: '참여', slug: 'participation' }
]

const handleCategoryClick = (categorySlug: string) => {
  mobileMenuOpen.value = false
  router.push({ name: 'category', params: { category: categorySlug } })
}

const handleLogoClick = () => {
  router.push('/')
}

const handleLoginClick = () => {
  router.push({ name: 'login' })
}

const handleSignupClick = () => {
  router.push({ name: 'signup' })
}

const handleLogout = async () => {
  const result = await signOut()
  if (result.success) {
    $q.notify({
      type: 'positive',
      message: '로그아웃되었습니다.',
      position: 'top'
    })
    mobileMenuOpen.value = false
    router.push('/')
  } else {
    $q.notify({
      type: 'negative',
      message: '로그아웃에 실패했습니다.',
      position: 'top'
    })
  }
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
