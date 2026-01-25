<template>
  <div style="min-height: 100vh; background-color: white;">
    <FigmaHeader />

    <div style="min-height: 100vh; background-color: #F9FAFB;">
      <!-- Back Button & Header -->
      <div style="background-color: white; border-bottom: 1px solid #E5E7EB;">
        <div class="container" style="padding: 1.5rem 1rem;">
          <q-btn
            flat
            icon="arrow_back"
            label="뒤로 가기"
            @click="handleBack"
            style="color: #4B5563; margin-bottom: 1rem;"
            no-caps
          />

          <div v-if="video">
            <h1 style="font-size: 1.875rem; font-weight: 700; margin-bottom: 0.5rem;">{{ video.title }}</h1>
            <div style="display: flex; align-items: center; gap: 1rem; color: #4B5563;">
              <div style="display: flex; align-items: center; gap: 0.25rem;">
                <q-icon name="schedule" size="18px" />
                <span style="font-size: 0.875rem;">{{ video.duration }}</span>
              </div>
              <q-badge v-if="isCompleted" color="green" label="완료" />
            </div>
          </div>
        </div>
      </div>

      <div class="container" style="padding: 2rem 1rem; max-width: 1200px; margin: 0 auto;">
        <!-- 로딩 중 -->
        <div v-if="loading" style="text-align: center; padding: 3rem;">
          <q-spinner size="50px" color="orange" />
          <p style="margin-top: 1rem; color: #4B5563;">영상을 불러오는 중...</p>
        </div>

        <!-- 영상 플레이어 -->
        <div v-else-if="video" style="display: flex; flex-direction: column; gap: 2rem;">
          <!-- YouTube Player -->
          <div style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; border-radius: 0.5rem; background-color: black;">
            <iframe
              :id="'youtube-player-' + videoId"
              :src="youtubeEmbedUrl"
              style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
              frameborder="0"
              allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
              allowfullscreen
            ></iframe>
          </div>

          <!-- 진행률 -->
          <div v-if="user" style="background-color: white; padding: 1.5rem; border-radius: 0.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
              <span style="font-weight: 600;">시청 진행률</span>
              <span style="color: #F97316; font-weight: 600;">{{ Math.round(watchProgress) }}%</span>
            </div>
            <q-linear-progress :value="watchProgress / 100" color="orange" size="8px" />
            <p v-if="!isCompleted && watchProgress >= 80" style="margin-top: 0.5rem; font-size: 0.875rem; color: #15803d;">
              80% 이상 시청하면 완료로 표시됩니다!
            </p>
            <p v-if="isCompleted" style="margin-top: 0.5rem; font-size: 0.875rem; color: #15803d; display: flex; align-items: center; gap: 0.25rem;">
              <q-icon name="check_circle" size="18px" />
              영상 시청을 완료했습니다!
            </p>
          </div>

          <!-- 영상 설명 -->
          <div style="background-color: white; padding: 1.5rem; border-radius: 0.5rem;">
            <h2 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem;">영상 정보</h2>
            <div style="color: #4B5563; line-height: 1.6;">
              <p v-if="video.description">{{ video.description }}</p>
              <p v-else>이 영상에서는 {{ categoryName }} 관련 정책을 자세히 안내합니다.</p>
            </div>
          </div>

          <!-- 액션 버튼 -->
          <div style="display: flex; gap: 1rem;">
            <q-btn
              label="목록으로 돌아가기"
              outline
              color="grey"
              no-caps
              @click="handleBack"
              style="flex: 1; padding: 0.75rem; font-size: 1rem;"
            />
            <q-btn
              v-if="!isCompleted && user"
              label="완료로 표시"
              color="orange"
              unelevated
              no-caps
              @click="markAsCompleted"
              :loading="marking"
              style="flex: 1; padding: 0.75rem; font-size: 1rem;"
            />
          </div>
        </div>

        <!-- 영상이 없을 때 -->
        <div v-else style="text-align: center; padding: 3rem;">
          <q-icon name="videocam_off" size="80px" color="grey" style="opacity: 0.5;" />
          <p style="margin-top: 1rem; color: #4B5563; font-size: 1.125rem;">영상을 찾을 수 없습니다.</p>
        </div>
      </div>
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
import { useAuth } from '../composables/useAuth'
import { useLearning } from '../composables/useLearning'
import { supabase } from '../lib/supabase'

const route = useRoute()
const router = useRouter()
const $q = useQuasar()

const { user } = useAuth()
const { updateVideoProgress } = useLearning()

const videoId = computed(() => parseInt(route.params.videoId as string))
const categorySlug = computed(() => route.params.category as string)

const video = ref<any>(null)
const categoryName = ref<string>('')
const loading = ref(true)
const marking = ref(false)

const watchProgress = ref(0)
const isCompleted = ref(false)

let progressInterval: any = null

// YouTube URL 파싱
const getYouTubeVideoId = (url: string) => {
  const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/
  const match = url.match(regExp)
  return match && match[2].length === 11 ? match[2] : null
}

const youtubeEmbedUrl = computed(() => {
  if (!video.value?.video_url) return ''
  const videoId = getYouTubeVideoId(video.value.video_url)
  return `https://www.youtube.com/embed/${videoId}?enablejsapi=1&rel=0`
})

// 영상 데이터 로드
const loadVideo = async () => {
  loading.value = true

  try {
    // 영상 정보 가져오기
    const { data: videoData, error: videoError } = await supabase
      .from('videos')
      .select(`
        *,
        categories!inner(name, slug)
      `)
      .eq('id', videoId.value)
      .single()

    if (videoError) throw videoError
    if (!videoData) {
      throw new Error('영상을 찾을 수 없습니다.')
    }

    video.value = videoData
    categoryName.value = videoData.categories.name

    // 사용자의 시청 기록 가져오기
    if (user.value) {
      const { data: progressData } = await supabase
        .from('user_video_progress')
        .select('*')
        .eq('user_id', user.value.id)
        .eq('video_id', videoId.value)
        .single()

      if (progressData) {
        isCompleted.value = progressData.completed
        // last_position은 초 단위, 대략적인 진행률로 변환
        watchProgress.value = progressData.completed ? 100 : 0
      }

      // 진행률 자동 업데이트 시작 (30초마다)
      startProgressTracking()
    }
  } catch (error: any) {
    console.error('영상 로딩 에러:', error)
    $q.notify({
      type: 'negative',
      message: error.message || '영상을 불러오는 중 오류가 발생했습니다.',
      position: 'top'
    })
    router.back()
  } finally {
    loading.value = false
  }
}

// 진행률 추적 시작
const startProgressTracking = () => {
  if (!user.value) return

  // 30초마다 진행률 업데이트
  progressInterval = setInterval(async () => {
    if (watchProgress.value < 100 && !isCompleted.value) {
      // 시청 중이면 진행률 증가 (간단한 시뮬레이션)
      watchProgress.value = Math.min(watchProgress.value + 5, 100)

      // 80% 이상 시청하면 완료로 표시
      if (watchProgress.value >= 80 && !isCompleted.value) {
        await markAsCompleted()
      }
    }
  }, 30000) // 30초
}

// 완료로 표시
const markAsCompleted = async () => {
  if (!user.value) {
    $q.notify({
      type: 'warning',
      message: '로그인이 필요합니다.',
      position: 'top'
    })
    router.push({ name: 'login' })
    return
  }

  marking.value = true

  try {
    const result = await updateVideoProgress(
      user.value.id,
      videoId.value,
      0, // last_position (초 단위, 여기서는 0으로 설정)
      true // completed
    )

    if (result.success) {
      isCompleted.value = true
      watchProgress.value = 100

      $q.notify({
        type: 'positive',
        message: '영상 시청이 완료되었습니다! 🎉',
        position: 'top'
      })
    }
  } catch (error: any) {
    console.error('완료 표시 에러:', error)
    $q.notify({
      type: 'negative',
      message: '완료 표시 중 오류가 발생했습니다.',
      position: 'top'
    })
  } finally {
    marking.value = false
  }
}

// 뒤로 가기
const handleBack = () => {
  if (categorySlug.value) {
    router.push({ name: 'category', params: { category: categorySlug.value } })
  } else {
    router.back()
  }
}

onMounted(() => {
  loadVideo()
})

onUnmounted(() => {
  if (progressInterval) {
    clearInterval(progressInterval)
  }
})
</script>

<style scoped>
.container {
  max-width: 1280px;
  margin: 0 auto;
}
</style>
