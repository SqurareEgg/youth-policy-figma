<template>
  <header style="background-color: white; border-bottom: 1px solid #E5E7EB; box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06); position: sticky; top: 0; z-index: 50;">
    <div class="container mx-auto px-4" style="height: 64px;">
      <!-- Desktop Layout -->
      <div class="gt-md header-desktop">
        <!-- 로고 -->
        <button
          @click="handleLogoClick"
          style="display: flex; align-items: center; cursor: pointer; border: none; background: none; padding: 0;"
        >
          <span style="font-size: 1.5rem; font-weight: 700; color: #1e3a8a;">
            청년있슈
          </span>
        </button>

        <!-- 중앙 카테고리 -->
        <nav style="display: flex; gap: 0.25rem;">
          <q-btn
            v-for="category in categories"
            :key="category.name"
            flat
            no-caps
            :label="category.name"
            @click="() => handleCategoryClick(category.slug)"
            class="nav-menu-item"
            :class="{ 'active': currentCategory === category.name }"
          />
        </nav>

        <!-- 우측 로그인/회원가입 -->
        <div style="display: flex; align-items: center; gap: 0.75rem; justify-content: flex-end;">
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
              style="background-color: #F97316; color: white; font-size: 0.875rem; padding: 0.5rem 1rem; border-radius: 0.5rem;"
            />
          </template>
        </div>
      </div>

      <!-- Mobile Layout -->
      <div class="lt-lg header-mobile">
        <!-- 로고 -->
        <button
          @click="handleLogoClick"
          style="display: flex; align-items: center; cursor: pointer; border: none; background: none; padding: 0;"
        >
          <span style="font-size: 1.5rem; font-weight: 700; color: #1e3a8a;">
            청년있슈
          </span>
        </button>

        <!-- 우측 버튼들 -->
        <div style="display: flex; align-items: center; gap: 0.5rem;">
          <!-- 로그인/회원가입 버튼 -->
          <template v-if="isAuthenticated">
            <q-btn
              flat
              dense
              no-caps
              label="로그아웃"
              @click="handleLogout"
              style="color: #374151; font-size: 0.75rem;"
            />
          </template>
          <template v-else>
            <q-btn
              flat
              dense
              no-caps
              label="로그인"
              @click="handleLoginClick"
              style="color: #374151; font-size: 0.75rem;"
            />
          </template>

          <!-- Mobile Menu Button -->
          <q-btn
            flat
            dense
            round
            :icon="mobileMenuOpen ? 'close' : 'menu'"
            @click="mobileMenuOpen = !mobileMenuOpen"
            :style="{
              backgroundColor: mobileMenuOpen ? '#FFF7ED' : 'transparent',
              color: mobileMenuOpen ? '#F97316' : '#374151'
            }"
          />
        </div>
      </div>
    </div>

    <!-- Mobile Navigation -->
    <div v-if="mobileMenuOpen" style="background-color: white; border-top: 1px solid #E5E7EB;">
      <div class="container" style="padding: 1rem; display: flex; flex-direction: column; gap: 0.75rem;">
        <!-- 카테고리 -->
        <div>
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
        <!-- 회원가입 버튼 (비로그인 시에만 표시) -->
        <template v-if="!isAuthenticated">
          <q-btn
            unelevated
            no-caps
            label="회원가입"
            @click="handleSignupClick"
            style="background-color: #F97316; color: white; font-size: 0.875rem; width: 100%; margin-top: 0.5rem;"
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
  try {
    console.log('🔓 [Header] 로그아웃 시작...')
    const result = await signOut()

    if (result.success) {
      console.log('✅ [Header] 로그아웃 성공')
      $q.notify({
        type: 'positive',
        message: '로그아웃되었습니다.',
        position: 'top'
      })
      mobileMenuOpen.value = false

      // 홈으로 이동 후 페이지 새로고침하여 상태 완전히 초기화
      await router.push('/')
      window.location.reload()
    } else {
      console.error('❌ [Header] 로그아웃 실패:', result.error)
      $q.notify({
        type: 'negative',
        message: result.error || '로그아웃에 실패했습니다.',
        position: 'top'
      })
    }
  } catch (error: any) {
    console.error('❌ [Header] 로그아웃 에러:', error)
    $q.notify({
      type: 'negative',
      message: '로그아웃 중 오류가 발생했습니다.',
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

/* Header layouts */
.header-desktop {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 2rem;
}

.header-mobile {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

/* Navigation menu items */
.nav-menu-item {
  font-size: 0.875rem;
  color: #374151;
  font-weight: 400;
  padding: 0.5rem 0.75rem;
  border-radius: 0.5rem;
  transition: all 0.2s;
}

.nav-menu-item.active {
  color: #F97316;
  font-weight: 600;
  background-color: #FFF7ED;
}

.nav-menu-item:hover {
  background-color: #F9FAFB;
}
</style>
