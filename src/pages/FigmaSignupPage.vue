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
        <!-- 단계 표시 -->
        <q-stepper
          v-model="step"
          ref="stepper"
          color="orange"
          animated
          flat
          style="box-shadow: none;"
        >
          <!-- Step 1: 이메일 인증 -->
          <q-step
            :name="1"
            title="이메일 인증"
            icon="email"
            :done="step > 1"
          >
            <q-form @submit="handleSendOtp" style="display: flex; flex-direction: column; gap: 1rem;">
              <q-input
                v-model="formData.email"
                label="이메일"
                type="email"
                outlined
                :rules="[(val) => !!val || '이메일을 입력해주세요']"
                :disable="otpSent"
              />

              <q-btn
                v-if="!otpSent"
                type="submit"
                label="인증번호 발송"
                unelevated
                no-caps
                color="orange"
                :loading="loading"
              />

              <q-banner v-if="otpSent" class="bg-green-1 text-green-9" rounded dense>
                <template v-slot:avatar>
                  <q-icon name="check_circle" color="green" />
                </template>
                인증번호가 이메일로 발송되었습니다.
              </q-banner>
            </q-form>
          </q-step>

          <!-- Step 2: 인증번호 입력 -->
          <q-step
            :name="2"
            title="인증번호 확인"
            icon="verified_user"
            :done="step > 2"
          >
            <q-form @submit="handleVerifyOtp" style="display: flex; flex-direction: column; gap: 1rem;">
              <p style="color: #4B5563; font-size: 0.875rem;">
                <strong>{{ formData.email }}</strong>으로 발송된 6자리 인증번호를 입력해주세요.
              </p>

              <q-input
                v-model="formData.otp"
                label="인증번호"
                mask="######"
                placeholder="123456"
                outlined
                :rules="[
                  (val) => !!val || '인증번호를 입력해주세요',
                  (val) => val.length === 6 || '인증번호는 6자리입니다'
                ]"
              />

              <div style="display: flex; gap: 0.5rem;">
                <q-btn
                  flat
                  label="이메일 변경"
                  color="grey"
                  no-caps
                  @click="resetStep1"
                  style="flex: 1;"
                />
                <q-btn
                  type="submit"
                  label="인증 확인"
                  unelevated
                  no-caps
                  color="orange"
                  :loading="loading"
                  style="flex: 1;"
                />
              </div>

              <q-banner class="bg-orange-1 text-orange-9" rounded dense>
                <template v-slot:avatar>
                  <q-icon name="info" color="orange" />
                </template>
                인증번호가 오지 않았나요? 스팸 메일함을 확인해주세요.
              </q-banner>
            </q-form>
          </q-step>

          <!-- Step 3: 추가 정보 입력 -->
          <q-step
            :name="3"
            title="추가 정보 입력"
            icon="person"
          >
            <q-form @submit="handleCompleteSignup" style="display: flex; flex-direction: column; gap: 1rem;">
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

              <q-input
                v-model="formData.phone"
                label="전화번호"
                placeholder="010-1234-5678"
                outlined
                mask="###-####-####"
                :rules="[(val) => !!val || '전화번호를 입력해주세요']"
              />

              <div style="display: flex; flex-direction: column; gap: 0.5rem; margin-top: 0.5rem;">
                <q-checkbox
                  v-model="formData.agreeTerms"
                  label="이용약관 동의 (필수)"
                  color="orange"
                />
                <q-checkbox
                  v-model="formData.agreePrivacy"
                  label="개인정보 처리방침 동의 (필수)"
                  color="orange"
                />
                <q-checkbox
                  v-model="formData.agreeMarketing"
                  label="마케팅 정보 수신 동의 (선택)"
                  color="orange"
                />
              </div>

              <q-btn
                type="submit"
                label="회원가입 완료"
                unelevated
                no-caps
                style="background-color: #F97316; color: white; padding: 0.75rem; font-size: 1rem;"
                :loading="loading"
                :disable="!formData.agreeTerms || !formData.agreePrivacy"
              />
            </q-form>
          </q-step>
        </q-stepper>

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
const { sendOtp, verifyOtp, completeSignup } = useAuth()

const step = ref(1)
const otpSent = ref(false)
const loading = ref(false)

const formData = ref({
  email: '',
  otp: '',
  name: '',
  birthdate: '',
  phone: '',
  agreeTerms: false,
  agreePrivacy: false,
  agreeMarketing: false
})

// Step 1: 인증번호 발송
const handleSendOtp = async () => {
  loading.value = true

  try {
    const result = await sendOtp(formData.value.email)

    if (result.success) {
      otpSent.value = true
      step.value = 2
      $q.notify({
        type: 'positive',
        message: '인증번호가 이메일로 발송되었습니다.',
        position: 'top'
      })
    } else {
      $q.notify({
        type: 'negative',
        message: result.error || '인증번호 발송에 실패했습니다.',
        position: 'top'
      })
    }
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: '인증번호 발송 중 오류가 발생했습니다.',
      position: 'top'
    })
  } finally {
    loading.value = false
  }
}

// Step 2: 인증번호 확인
const handleVerifyOtp = async () => {
  loading.value = true

  try {
    const result = await verifyOtp(formData.value.email, formData.value.otp)

    if (result.success) {
      step.value = 3
      $q.notify({
        type: 'positive',
        message: '이메일 인증에 성공했습니다.',
        position: 'top'
      })
    } else {
      $q.notify({
        type: 'negative',
        message: result.error || '인증번호가 올바르지 않습니다.',
        position: 'top'
      })
    }
  } catch (error: any) {
    $q.notify({
      type: 'negative',
      message: '인증 확인 중 오류가 발생했습니다.',
      position: 'top'
    })
  } finally {
    loading.value = false
  }
}

// Step 3: 회원가입 완료
const handleCompleteSignup = async () => {
  loading.value = true

  try {
    const result = await completeSignup(
      formData.value.name,
      formData.value.birthdate,
      formData.value.phone,
      {
        terms: formData.value.agreeTerms,
        privacy: formData.value.agreePrivacy,
        marketing: formData.value.agreeMarketing
      }
    )

    if (result.success) {
      $q.notify({
        type: 'positive',
        message: '회원가입이 완료되었습니다!',
        position: 'top'
      })
      router.push('/')
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

// 이메일 변경 (Step 1로 돌아가기)
const resetStep1 = () => {
  step.value = 1
  otpSent.value = false
  formData.value.otp = ''
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
