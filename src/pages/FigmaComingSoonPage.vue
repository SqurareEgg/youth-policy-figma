<template>
  <div style="min-height: 100vh; background-color: white;">
    <FigmaHeader />

    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: calc(100vh - 200px); padding: 2rem 1rem;">
      <div style="text-align: center; max-width: 600px;">
        <!-- 아이콘 -->
        <div style="margin-bottom: 2rem;">
          <q-icon name="construction" size="120px" color="orange" />
        </div>

        <!-- 제목 -->
        <h1 style="font-size: 3rem; font-weight: 700; color: #1e3a8a; margin-bottom: 1rem;">
          준비중입니다
        </h1>

        <!-- 설명 -->
        <p style="font-size: 1.25rem; color: #4B5563; margin-bottom: 2rem; line-height: 1.6;">
          청년정책카페는 현재 열심히 준비 중입니다.<br />
          곧 더 나은 서비스로 찾아뵙겠습니다!
        </p>

        <!-- 특징 카드들 -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
          <q-card style="padding: 1.5rem; background-color: #FFF7ED;">
            <q-icon name="forum" size="40px" color="orange" style="margin-bottom: 0.5rem;" />
            <p style="font-size: 0.875rem; font-weight: 600; color: #374151;">커뮤니티</p>
          </q-card>

          <q-card style="padding: 1.5rem; background-color: #FFF7ED;">
            <q-icon name="share" size="40px" color="orange" style="margin-bottom: 0.5rem;" />
            <p style="font-size: 0.875rem; font-weight: 600; color: #374151;">정보 공유</p>
          </q-card>

          <q-card style="padding: 1.5rem; background-color: #FFF7ED;">
            <q-icon name="question_answer" size="40px" color="orange" style="margin-bottom: 0.5rem;" />
            <p style="font-size: 0.875rem; font-weight: 600; color: #374151;">Q&A</p>
          </q-card>
        </div>

        <!-- 버튼 -->
        <div style="display: flex; gap: 1rem; justify-content: center;">
          <q-btn
            unelevated
            no-caps
            label="홈으로 돌아가기"
            icon="home"
            @click="goHome"
            style="background-color: #F97316; color: white; padding: 0.75rem 2rem; font-size: 1rem;"
          />

          <q-btn
            outline
            no-caps
            label="알림 신청"
            icon="notifications"
            @click="showNotify"
            style="border-color: #F97316; color: #F97316; padding: 0.75rem 2rem; font-size: 1rem;"
          />
        </div>
      </div>
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'

const router = useRouter()
const $q = useQuasar()

const goHome = () => {
  router.push('/')
}

const showNotify = () => {
  $q.notify({
    message: '오픈 알림이 신청되었습니다!',
    color: 'orange',
    icon: 'check_circle',
    position: 'top',
    timeout: 2000
  })
}
</script>
