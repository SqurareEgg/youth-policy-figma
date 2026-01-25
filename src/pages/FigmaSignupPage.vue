<template>
  <div style="display: flex; align-items: center; justify-content: center; min-height: 100vh; background-color: #F9FAFB; padding: 2rem 1rem;">
    <q-card style="width: 100%; max-width: 28rem; padding: 2rem;">
      <!-- 로고 -->
      <q-card-section style="text-align: center; padding-bottom: 2rem;">
        <h1 style="font-size: 1.875rem; font-weight: 700; color: #1e3a8a; margin-bottom: 0.5rem;">청년있슈</h1>
        <p style="color: #4B5563;">회원가입하고 청년 정책 혜택을 받아보세요</p>
      </q-card-section>

      <!-- 회원가입 폼 -->
      <q-card-section style="padding-top: 0;">
        <q-form @submit="handleSignup" style="display: flex; flex-direction: column; gap: 1rem;">
          <q-input
            v-model="formData.email"
            label="이메일"
            type="email"
            outlined
            :rules="[(val) => !!val || '이메일을 입력해주세요']"
          />

          <q-input
            v-model="formData.password"
            label="비밀번호"
            type="password"
            outlined
            :rules="[
              (val) => !!val || '비밀번호를 입력해주세요',
              (val) => val.length >= 6 || '비밀번호는 6자 이상이어야 합니다'
            ]"
          />

          <q-input
            v-model="formData.passwordConfirm"
            label="비밀번호 확인"
            type="password"
            outlined
            :rules="[
              (val) => !!val || '비밀번호를 다시 입력해주세요',
              (val) => val === formData.password || '비밀번호가 일치하지 않습니다'
            ]"
          />

          <q-input
            v-model="formData.name"
            label="이름"
            outlined
            :rules="[(val) => !!val || '이름을 입력해주세요']"
          />

          <q-input
            v-model="formData.birthdate"
            label="생년월일"
            mask="####-##-##"
            placeholder="YYYY-MM-DD"
            outlined
            :rules="[(val) => !!val || '생년월일을 입력해주세요']"
          />

          <q-select
            v-model="formData.school"
            label="학교"
            outlined
            :options="schoolOptions"
            :rules="[(val) => !!val || '학교를 선택해주세요']"
          />

          <q-input
            v-model="formData.studentId"
            label="학번"
            placeholder="20240001"
            outlined
            mask="########"
            :rules="[(val) => !!val || '학번을 입력해주세요']"
          />

          <div style="display: flex; flex-direction: column; gap: 0.5rem;">
            <q-checkbox
              v-model="formData.agreeTerms"
              label="이용약관 동의 (필수)"
            />
            <q-checkbox v-model="formData.agreePrivacy" label="개인정보 처리방침 동의 (필수)" />
            <q-checkbox v-model="formData.agreeMarketing" label="마케팅 정보 수신 동의 (선택)" />
          </div>

          <q-btn
            type="submit"
            label="회원가입"
            unelevated
            no-caps
            style="background-color: #F97316; color: white; padding: 0.75rem; font-size: 1rem;"
            :loading="loading"
            :disable="!formData.agreeTerms || !formData.agreePrivacy"
          />
        </q-form>

        <!-- 로그인 링크 -->
        <div style="margin-top: 1.5rem; text-align: center; font-size: 0.875rem;">
          <span style="color: #4B5563;">이미 회원이신가요?</span>
          <q-btn
            flat
            no-caps
            dense
            label="로그인"
            @click="goToLogin"
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
const { signUp } = useAuth()

const loading = ref(false)

const schoolOptions = [
  '대전보건대학교',
  '대전과학기술대학교',
  '한국폴리텍대학 대전캠퍼스',
  '대전대학교',
  '목원대학교',
  '배재대학교',
  '충남대학교',
  '한남대학교',
  'KAIST'
]

const formData = ref({
  email: '',
  password: '',
  passwordConfirm: '',
  name: '',
  birthdate: '',
  school: '',
  studentId: '',
  agreeTerms: false,
  agreePrivacy: false,
  agreeMarketing: false
})

const handleSignup = async () => {
  loading.value = true

  try {
    const result = await signUp(
      formData.value.email,
      formData.value.password,
      formData.value.name,
      formData.value.birthdate,
      formData.value.school,
      formData.value.studentId,
      {
        terms: formData.value.agreeTerms,
        privacy: formData.value.agreePrivacy,
        marketing: formData.value.agreeMarketing
      }
    )

    if (result.success) {
      $q.notify({
        type: 'positive',
        message: '회원가입 성공! 로그인 페이지로 이동합니다.',
        position: 'top'
      })
      router.push({ name: 'login' })
    } else {
      $q.notify({
        type: 'negative',
        message: result.error || '회원가입에 실패했습니다.',
        position: 'top'
      })
    }
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: '회원가입 중 오류가 발생했습니다.',
      position: 'top'
    })
  } finally {
    loading.value = false
  }
}

const goToLogin = () => {
  router.push({ name: 'login' })
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
