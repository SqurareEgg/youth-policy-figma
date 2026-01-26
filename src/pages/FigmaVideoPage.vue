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
            <div
              :id="'youtube-player-' + videoId"
              style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
            ></div>
          </div>

          <!-- 진행률 -->
          <div v-if="user" style="background-color: white; padding: 1.5rem; border-radius: 0.5rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
              <span style="font-weight: 600;">시청 진행률</span>
              <span style="color: #F97316; font-weight: 600;">{{ Math.round(watchProgress) }}%</span>
            </div>
            <q-linear-progress :value="watchProgress / 100" color="orange" size="8px" />

            <div v-if="player" style="margin-top: 0.5rem; font-size: 0.875rem; color: #6B7280;">
              시청 시간: {{ formatTime(totalWatchTime) }} / {{ video.duration }}
            </div>

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
const totalWatchTime = ref(0) // 총 시청 시간 (초)

let progressInterval: any = null
let player: any = null
let lastUpdateTime = 0

// YouTube URL 파싱
const getYouTubeVideoId = (url: string) => {
  const regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|&v=)([^#&?]*).*/
  const match = url.match(regExp)
  return match && match[2].length === 11 ? match[2] : null
}

const youtubeVideoId = computed(() => {
  if (!video.value?.video_url) return ''
  return getYouTubeVideoId(video.value.video_url) || ''
})

// 초를 MM:SS 형식으로 변환
const formatTime = (seconds: number) => {
  const mins = Math.floor(seconds / 60)
  const secs = Math.floor(seconds % 60)
  return `${mins}:${secs.toString().padStart(2, '0')}`
}

// YouTube IFrame API 로드
const loadYouTubeAPI = () => {
  return new Promise((resolve, reject) => {
    // 이미 로드되어 있으면 바로 resolve
    if ((window as any).YT && (window as any).YT.Player) {
      resolve(true)
      return
    }

    // API 로드 중이면 대기
    if ((window as any).YT) {
      const checkInterval = setInterval(() => {
        if ((window as any).YT.Player) {
          clearInterval(checkInterval)
          resolve(true)
        }
      }, 100)

      setTimeout(() => {
        clearInterval(checkInterval)
        reject(new Error('YouTube API 로드 시간 초과'))
      }, 10000)
      return
    }

    // 스크립트 추가
    const tag = document.createElement('script')
    tag.src = 'https://www.youtube.com/iframe_api'
    tag.onerror = () => reject(new Error('YouTube API 로드 실패'))

    const firstScriptTag = document.getElementsByTagName('script')[0]
    if (firstScriptTag && firstScriptTag.parentNode) {
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag)
    } else {
      document.head.appendChild(tag)
    }

    // 전역 콜백 설정
    ;(window as any).onYouTubeIframeAPIReady = () => {
      resolve(true)
    }
  })
}

// YouTube Player 초기화
const initYouTubePlayer = async () => {
  try {
    console.log('YouTube API 로드 시작...')
    await loadYouTubeAPI()
    console.log('YouTube API 로드 완료')

    if (!youtubeVideoId.value) {
      console.error('YouTube Video ID가 없습니다:', video.value?.video_url)
      throw new Error('올바른 YouTube URL이 아닙니다.')
    }

    console.log('YouTube Player 초기화:', youtubeVideoId.value)

    const playerId = `youtube-player-${videoId.value}`
    const element = document.getElementById(playerId)

    if (!element) {
      console.error('Player 엘리먼트를 찾을 수 없습니다:', playerId)
      throw new Error('Player 엘리먼트를 찾을 수 없습니다.')
    }

    player = new (window as any).YT.Player(playerId, {
      videoId: youtubeVideoId.value,
      playerVars: {
        autoplay: 0,
        rel: 0,
        modestbranding: 1
      },
      events: {
        onReady: onPlayerReady,
        onStateChange: onPlayerStateChange,
        onError: onPlayerError
      }
    })

    console.log('YouTube Player 초기화 완료')
  } catch (error) {
    console.error('YouTube Player 초기화 에러:', error)
    throw error
  }
}

// Player 준비 완료
const onPlayerReady = (event: any) => {
  console.log('YouTube Player 준비 완료')
  // 이전 시청 위치가 있으면 그 위치로 이동
  if (lastUpdateTime > 0) {
    event.target.seekTo(lastUpdateTime, true)
  }
}

// Player 상태 변경
const onPlayerStateChange = (event: any) => {
  const YT = (window as any).YT

  if (event.data === YT.PlayerState.PLAYING) {
    // 재생 중일 때만 진행률 추적 시작
    startProgressTracking()
  } else if (event.data === YT.PlayerState.PAUSED || event.data === YT.PlayerState.ENDED) {
    // 일시정지 또는 종료 시 진행률 저장
    saveProgress()

    if (event.data === YT.PlayerState.ENDED) {
      // 영상 종료 시 자동 완료
      markAsCompleted()
    }
  }
}

// Player 에러 처리
const onPlayerError = (event: any) => {
  console.error('YouTube Player 에러:', event.data)
  let errorMessage = '영상 재생 중 오류가 발생했습니다.'

  switch (event.data) {
    case 2:
      errorMessage = '잘못된 YouTube 동영상 ID입니다.'
      break
    case 5:
      errorMessage = 'HTML5 플레이어 오류가 발생했습니다.'
      break
    case 100:
      errorMessage = '동영상을 찾을 수 없습니다.'
      break
    case 101:
    case 150:
      errorMessage = '동영상 소유자가 삽입을 허용하지 않았습니다.'
      break
  }

  $q.notify({
    type: 'negative',
    message: errorMessage,
    position: 'top'
  })
}

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

    // video_url 검증
    if (!videoData.video_url) {
      throw new Error('영상 URL이 설정되지 않았습니다. 관리자에게 문의하세요.')
    }

    // YouTube Video ID 검증
    const extractedVideoId = getYouTubeVideoId(videoData.video_url)
    if (!extractedVideoId) {
      throw new Error('올바른 YouTube URL이 아닙니다. 관리자에게 문의하세요.')
    }

    console.log('영상 정보:', {
      title: videoData.title,
      url: videoData.video_url,
      youtubeId: extractedVideoId
    })

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
        lastUpdateTime = progressData.last_position || 0
        totalWatchTime.value = progressData.last_position || 0
      }
    }

    // YouTube Player 초기화
    await initYouTubePlayer()
  } catch (error: any) {
    console.error('영상 로딩 에러:', error)

    let errorMessage = error.message || '영상을 불러오는 중 오류가 발생했습니다.'

    // 추가 힌트 제공
    if (errorMessage.includes('URL이 설정되지 않았습니다') ||
        errorMessage.includes('올바른 YouTube URL이 아닙니다')) {
      errorMessage += '\n\n💡 데이터베이스에 영상 URL을 설정해야 합니다. DATABASE_SETUP_STEPS.md를 참고하세요.'
    }

    $q.notify({
      type: 'negative',
      message: errorMessage,
      position: 'top',
      timeout: 5000,
      html: true
    })
    router.back()
  } finally {
    loading.value = false
  }
}

// 진행률 추적 시작
const startProgressTracking = () => {
  if (!user.value || !player) return

  // 기존 interval 제거
  if (progressInterval) {
    clearInterval(progressInterval)
  }

  // 5초마다 진행률 업데이트
  progressInterval = setInterval(async () => {
    if (!player || !player.getCurrentTime || isCompleted.value) return

    try {
      const currentTime = player.getCurrentTime() // 현재 재생 위치 (초)
      const duration = player.getDuration() // 전체 길이 (초)

      if (duration > 0) {
        // 진행률 계산 (0-100)
        watchProgress.value = Math.min((currentTime / duration) * 100, 100)
        totalWatchTime.value = currentTime

        // 30초마다 DB에 저장 (5초 × 6회 = 30초)
        if (Math.floor(currentTime) % 30 === 0 && Math.floor(currentTime) !== lastUpdateTime) {
          lastUpdateTime = Math.floor(currentTime)
          await saveProgress()
        }

        // 80% 이상 시청하면 완료로 표시
        if (watchProgress.value >= 80 && !isCompleted.value) {
          await markAsCompleted()
        }
      }
    } catch (error) {
      console.error('진행률 추적 에러:', error)
    }
  }, 5000) // 5초마다
}

// 진행률 저장
const saveProgress = async () => {
  if (!user.value || !player) return

  try {
    const currentTime = Math.floor(player.getCurrentTime() || 0)

    await updateVideoProgress(
      user.value.id,
      videoId.value,
      currentTime,
      isCompleted.value
    )
  } catch (error) {
    console.error('진행률 저장 에러:', error)
  }
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

  if (isCompleted.value) return // 이미 완료된 경우

  marking.value = true

  try {
    const currentTime = player ? Math.floor(player.getCurrentTime() || 0) : totalWatchTime.value

    const result = await updateVideoProgress(
      user.value.id,
      videoId.value,
      currentTime, // 현재 재생 위치 저장
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

      // 완료 시 interval 정지
      if (progressInterval) {
        clearInterval(progressInterval)
        progressInterval = null
      }
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
  // interval 정리
  if (progressInterval) {
    clearInterval(progressInterval)
    progressInterval = null
  }

  // 마지막 진행률 저장
  if (player && user.value && !isCompleted.value) {
    saveProgress()
  }

  // player 정리
  if (player && player.destroy) {
    player.destroy()
    player = null
  }
})
</script>

<style scoped>
.container {
  max-width: 1280px;
  margin: 0 auto;
}
</style>
