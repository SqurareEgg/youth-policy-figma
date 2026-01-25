<template>
  <div style="display: flex; align-items: center; justify-content: center; min-height: 100vh; background-color: #F9FAFB; padding: 2rem 1rem;">
    <q-card style="width: 100%; max-width: 28rem; padding: 2rem;">
      <!-- 로고 -->
      <q-card-section style="text-align: center; padding-bottom: 2rem;">
        <h1 style="font-size: 1.875rem; font-weight: 700; color: #1e3a8a; margin-bottom: 0.5rem;">청년있슈</h1>
        <p style="color: #4B5563;">로그인하고 더 많은 혜택을 받아보세요</p>
      </q-card-section>

      <!-- 로그인 폼 -->
      <q-card-section style="padding-top: 0;">
        <q-form @submit="handleLogin" style="display: flex; flex-direction: column; gap: 1rem;">
          <q-input
            v-model="email"
            label="이메일"
            type="email"
            outlined
            :rules="[(val) => !!val || '이메일을 입력해주세요']"
          />

          <q-input
            v-model="password"
            label="비밀번호"
            type="password"
            outlined
            :rules="[(val) => !!val || '비밀번호를 입력해주세요']"
          />

          <div style="display: flex; align-items: center; justify-content: space-between; font-size: 0.875rem;">
            <q-checkbox v-model="rememberMe" label="로그인 상태 유지" />
            <a href="#" style="color: #F97316; text-decoration: none;">비밀번호 찾기</a>
          </div>

          <q-btn
            type="submit"
            label="로그인"
            unelevated
            no-caps
            style="background-color: #F97316; color: white; padding: 0.75rem; font-size: 1rem;"
            :loading="loading"
          />
        </q-form>

        <!-- 소셜 로그인 -->
        <div style="margin-top: 1.5rem;">
          <q-separator />
          <div style="text-align: center; margin: 1rem 0; color: #6B7280; font-size: 0.875rem;">
            또는
          </div>

          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem;">
            <q-btn outline no-caps label="카카오" @click="handleSocialLogin('kakao')" />
            <q-btn outline no-caps label="네이버" @click="handleSocialLogin('naver')" />
          </div>
        </div>

        <!-- 회원가입 링크 -->
        <div style="margin-top: 1.5rem; text-align: center; font-size: 0.875rem;">
          <span style="color: #4B5563;">아직 회원이 아니신가요?</span>
          <q-btn
            flat
            no-caps
            dense
            label="회원가입"
            @click="goToSignup"
            style="color: #F97316; font-weight: 600; padding: 0; margin-left: 0.25rem;"
          />
        </div>

        <!-- 홈으로 -->
        <div style="margin-top: 1rem; text-align: center;">
          <q-btn
            flat
            no-caps
            dense
            label="홈으로 돌아가기"
            @click="goToHome"
            style="color: #4B5563; font-size: 0.875rem;"
          />
        </div>
      </q-card-section>
    </q-card>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import { useAuth } from '../composables/useAuth'

const router = useRouter()
const $q = useQuasar()
const { signIn } = useAuth()

const email = ref('')
const password = ref('')
const rememberMe = ref(false)
const loading = ref(false)

const handleLogin = async () => {
  loading.value = true

  try {
    const result = await signIn(email.value, password.value)

    if (result.success) {
      $q.notify({
        type: 'positive',
        message: '로그인 성공!',
        position: 'top'
      })
      router.push('/')
    } else {
      $q.notify({
        type: 'negative',
        message: result.error || '로그인에 실패했습니다.',
        position: 'top'
      })
    }
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: '로그인 중 오류가 발생했습니다.',
      position: 'top'
    })
  } finally {
    loading.value = false
  }
}

const handleSocialLogin = (provider: string) => {
  $q.notify({
    type: 'info',
    message: `${provider} 로그인은 준비 중입니다.`,
    position: 'top'
  })
}

const goToSignup = () => {
  router.push({ name: 'signup' })
}

const goToHome = () => {
  router.push('/')
}
</script>

<style scoped>
.text-primary {
  color: #f97316;
}
</style>
