<template>
  <div style="display: flex; align-items: center; justify-content: center; min-height: 100vh; background-color: #F9FAFB; padding: 2rem 1rem;">
    <div style="width: 100%; max-width: 28rem;">
      <!-- 타이틀 -->
      <div style="text-align: center; margin-bottom: 2rem;">
        <h2 style="font-size: 1.875rem; font-weight: 700; color: #111827; margin-bottom: 0.5rem;">회원가입</h2>
      </div>

      <!-- 회원가입 카드 -->
      <q-card style="border-radius: 1rem; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); padding: 2rem;">
        <q-form @submit="handleSignup" style="display: flex; flex-direction: column; gap: 1.5rem;">
          <!-- 이름 -->
          <div>
            <label style="display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem;">이름</label>
            <q-input
              v-model="formData.name"
              outlined
              placeholder="홍길동"
              :rules="[(val) => !!val || '이름을 입력해주세요']"
              style="--q-field-border-radius: 0.5rem;"
            >
              <template v-slot:prepend>
                <q-icon name="person" color="grey-5" />
              </template>
            </q-input>
          </div>

          <!-- 소속 -->
          <div>
            <label style="display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem;">소속</label>
            <q-select
              v-model="formData.school"
              outlined
              :options="schoolOptions"
              placeholder="소속을 선택하세요"
              :rules="[(val) => !!val || '소속을 선택해주세요']"
              style="--q-field-border-radius: 0.5rem;"
            >
              <template v-slot:prepend>
                <q-icon name="business" color="grey-5" />
              </template>
            </q-select>
          </div>

          <!-- 학번 -->
          <div>
            <label style="display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem;">학번</label>
            <q-input
              v-model="formData.studentId"
              outlined
              placeholder="202312345"
              maxlength="20"
              :rules="[(val) => !!val || '학번을 입력해주세요']"
              style="--q-field-border-radius: 0.5rem;"
            >
              <template v-slot:prepend>
                <q-icon name="tag" color="grey-5" />
              </template>
            </q-input>
          </div>

          <!-- 이메일 -->
          <div>
            <label style="display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem;">이메일</label>
            <q-input
              v-model="formData.email"
              type="email"
              outlined
              placeholder="example@email.com"
              :rules="[(val) => !!val || '이메일을 입력해주세요']"
              style="--q-field-border-radius: 0.5rem;"
            >
              <template v-slot:prepend>
                <q-icon name="email" color="grey-5" />
              </template>
            </q-input>
          </div>

          <!-- 비밀번호 -->
          <div>
            <label style="display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem;">비밀번호</label>
            <q-input
              v-model="formData.password"
              :type="showPassword ? 'text' : 'password'"
              outlined
              placeholder="••••••••"
              :rules="[
                (val) => !!val || '비밀번호를 입력해주세요',
                (val) => val.length >= 6 || '비밀번호는 6자 이상이어야 합니다'
              ]"
              style="--q-field-border-radius: 0.5rem;"
            >
              <template v-slot:prepend>
                <q-icon name="lock" color="grey-5" />
              </template>
              <template v-slot:append>
                <q-icon
                  :name="showPassword ? 'visibility_off' : 'visibility'"
                  color="grey-5"
                  class="cursor-pointer"
                  @click="showPassword = !showPassword"
                />
              </template>
            </q-input>
          </div>

          <!-- 비밀번호 확인 -->
          <div>
            <label style="display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem;">비밀번호 확인</label>
            <q-input
              v-model="formData.passwordConfirm"
              :type="showPasswordConfirm ? 'text' : 'password'"
              outlined
              placeholder="••••••••"
              :rules="[
                (val) => !!val || '비밀번호를 다시 입력해주세요',
                (val) => val === formData.password || '비밀번호가 일치하지 않습니다'
              ]"
              style="--q-field-border-radius: 0.5rem;"
            >
              <template v-slot:prepend>
                <q-icon name="lock" color="grey-5" />
              </template>
              <template v-slot:append>
                <q-icon
                  :name="showPasswordConfirm ? 'visibility_off' : 'visibility'"
                  color="grey-5"
                  class="cursor-pointer"
                  @click="showPasswordConfirm = !showPasswordConfirm"
                />
              </template>
            </q-input>
          </div>

          <!-- 가입하기 버튼 -->
          <q-btn
            type="submit"
            label="가입하기"
            unelevated
            no-caps
            style="background-color: #F97316; color: white; padding: 0.75rem; font-size: 1rem; margin-top: 1rem; border-radius: 0.5rem; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);"
            :loading="loading"
          />
        </q-form>

        <!-- 로그인 링크 -->
        <div style="margin-top: 1.5rem; text-align: center;">
          <p style="font-size: 0.875rem; color: #6B7280;">
            이미 계정이 있으신가요?
            <q-btn
              flat
              no-caps
              dense
              label="로그인"
              @click="goToLogin"
              style="color: #F97316; font-weight: 500; padding: 0; margin-left: 0.25rem;"
            />
          </p>
        </div>
      </q-card>
    </div>
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
const showPassword = ref(false)
const showPasswordConfirm = ref(false)

const schoolOptions = [
  '대전과학기술대학교',
  '한국폴리텍 대전캠퍼스',
  '타학교'
]

const formData = ref({
  name: '',
  school: '',
  studentId: '',
  email: '',
  password: '',
  passwordConfirm: ''
})

const handleSignup = async () => {
  loading.value = true

  try {
    const result = await signUp(
      formData.value.email,
      formData.value.password,
      formData.value.name,
      '2000-01-01', // 생년월일 기본값
      formData.value.school,
      formData.value.studentId,
      {
        terms: true,
        privacy: true,
        marketing: false
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
