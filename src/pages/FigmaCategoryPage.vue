<template>
  <div style="min-height: 100vh; background-color: white;">
    <FigmaHeader :current-category="category" />

    <div style="min-height: 100vh; background-color: #F9FAFB;">
      <!-- Back Button & Header -->
      <div style="background-color: white; border-bottom: 1px solid #E5E7EB;">
        <div class="container" style="padding: 1.5rem 1rem;">
          <q-btn
            flat
            icon="arrow_back"
            label="홈으로 돌아가기"
            @click="handleBack"
            style="color: #4B5563; margin-bottom: 1rem;"
            no-caps
          />

          <div style="display: flex; flex-direction: column; gap: 1rem; margin-bottom: 1.5rem;">
            <div>
              <h1 style="font-size: 1.875rem; font-weight: 700; margin-bottom: 0.5rem;">{{ category }} 정책</h1>
              <p style="color: #4B5563;">청년을 위한 {{ category }} 관련 정책을 학습하고 혜택을 받아보세요</p>
            </div>

            <!-- Completion Rate Card -->
            <q-card style="background: linear-gradient(135deg, #F97316 0%, #EA580C 100%); color: white; padding: 1rem; max-width: 200px;">
              <div style="font-size: 0.875rem; opacity: 0.9; margin-bottom: 0.25rem;">전체 이수율</div>
              <div style="font-size: 1.875rem; font-weight: 700;">{{ completionRate }}%</div>
            </q-card>
          </div>

          <!-- Progress Bar -->
          <div>
            <div style="display: flex; justify-content: space-between; font-size: 0.875rem; margin-bottom: 0.5rem;">
              <span style="color: #4B5563;">학습 진행률</span>
              <span style="color: #F97316; font-weight: 600;">{{ completionRate }}% 완료</span>
            </div>
            <q-linear-progress :value="completionRate / 100" color="orange" size="12px" />
          </div>
        </div>
      </div>

      <div class="container" style="padding: 2rem 1rem;">
        <!-- 로딩 중 -->
        <div v-if="loading" style="text-align: center; padding: 3rem;">
          <q-spinner size="50px" color="orange" />
          <p style="margin-top: 1rem; color: #4B5563;">데이터를 불러오는 중...</p>
        </div>

        <div v-else style="display: flex; flex-direction: column; gap: 2rem;">
          <!-- Policy Visit Section -->
          <section>
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1rem;">
              <q-icon name="menu_book" size="24px" style="background-color: #F97316; color: white; padding: 0.5rem; border-radius: 0.5rem;" />
              <h2 style="font-size: 1.5rem; font-weight: 700;">정책 방문</h2>
            </div>

            <div style="display: flex; flex-direction: column; gap: 1rem;">
              <q-card
                v-for="policy in policies"
                :key="policy.id"
                style="padding: 1.5rem; cursor: pointer;"
                @click="() => viewPolicy(policy.id)"
              >
                <div style="display: flex; align-items: flex-start; justify-content: space-between; gap: 1rem;">
                  <div style="flex: 1;">
                    <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.5rem;">
                      <h3 style="font-size: 1.125rem; font-weight: 700;">{{ policy.title }}</h3>
                      <q-icon
                        v-if="policy.visited"
                        name="check_circle"
                        size="20px"
                        color="green"
                      />
                    </div>
                    <p style="color: #4B5563; margin-bottom: 0.75rem;">{{ policy.content.intro }}</p>
                    <q-badge
                      :color="
                        policy.status === '완료' ? 'green' :
                        policy.status === '진행중' ? 'blue' : 'grey'
                      "
                      :label="policy.status"
                    />
                  </div>
                  <q-btn
                    :label="policy.visited ? '다시보기' : '상세보기'"
                    :outline="policy.visited"
                    :color="policy.visited ? 'grey' : 'orange'"
                    no-caps
                    @click.stop="() => viewPolicy(policy.id)"
                  />
                </div>
              </q-card>
            </div>
          </section>

          <!-- Q&A Section -->
          <section>
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1rem;">
              <q-icon name="question_answer" size="24px" style="background-color: #F97316; color: white; padding: 0.5rem; border-radius: 0.5rem;" />
              <h2 style="font-size: 1.5rem; font-weight: 700;">Q&A</h2>
            </div>

            <div style="display: flex; flex-direction: column; gap: 1rem;">
              <q-card
                v-for="qna in qnaList"
                :key="qna.id"
                style="padding: 1.5rem;"
              >
                <div style="display: flex; align-items: flex-start; gap: 1rem;">
                  <q-icon name="help_outline" size="24px" color="orange" style="flex-shrink: 0; margin-top: 0.25rem;" />
                  <div style="flex: 1;">
                    <h3 style="font-size: 1.125rem; font-weight: 700; margin-bottom: 0.75rem;">{{ qna.question }}</h3>
                    <p style="color: #4B5563; line-height: 1.6;">{{ qna.answer }}</p>
                  </div>
                </div>
              </q-card>

              <div v-if="qnaList.length === 0" style="text-align: center; padding: 2rem; color: #6B7280;">
                아직 등록된 Q&A가 없습니다.
              </div>
            </div>
          </section>

          <!-- Video Learning Section -->
          <section>
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1rem;">
              <q-icon name="videocam" size="24px" style="background-color: #F97316; color: white; padding: 0.5rem; border-radius: 0.5rem;" />
              <h2 style="font-size: 1.5rem; font-weight: 700;">영상 학습</h2>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1rem;">
              <q-card
                v-for="video in videos"
                :key="video.id"
                style="cursor: pointer;"
                @click="() => watchVideo(video.id)"
              >
                <div style="position: relative;">
                  <img
                    :src="video.thumbnail"
                    :alt="video.title"
                    style="width: 100%; height: 12rem; object-fit: cover;"
                  />
                  <div style="position: absolute; inset: 0; background-color: rgba(0, 0, 0, 0.3); display: flex; align-items: center; justify-content: center;">
                    <q-icon name="play_circle" size="48px" color="white" />
                  </div>
                  <div style="position: absolute; bottom: 0.5rem; right: 0.5rem; background-color: rgba(0, 0, 0, 0.75); color: white; font-size: 0.75rem; padding: 0.25rem 0.5rem; border-radius: 0.25rem;">
                    {{ video.duration }}
                  </div>
                  <q-badge
                    v-if="video.completed"
                    color="green"
                    label="완료"
                    style="position: absolute; top: 0.5rem; left: 0.5rem;"
                  />
                </div>
                <q-card-section>
                  <h3 style="font-weight: 700; margin-bottom: 0.5rem;">{{ video.title }}</h3>
                  <q-btn
                    :label="video.completed ? '다시보기' : '시청하기'"
                    color="orange"
                    unelevated
                    no-caps
                    style="width: 100%;"
                    @click.stop="() => watchVideo(video.id)"
                  />
                </q-card-section>
              </q-card>
            </div>
          </section>

          <!-- Quiz Section -->
          <section>
            <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1rem;">
              <q-icon name="emoji_events" size="24px" style="background-color: #F97316; color: white; padding: 0.5rem; border-radius: 0.5rem;" />
              <h2 style="font-size: 1.5rem; font-weight: 700;">Quiz</h2>
            </div>

            <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1rem;">
              <q-card
                v-for="quiz in quizzes"
                :key="quiz.id"
                style="padding: 1.5rem;"
              >
                <div style="display: flex; align-items: flex-start; justify-content: space-between; margin-bottom: 1rem;">
                  <h3 style="font-size: 1.125rem; font-weight: 700; flex: 1;">{{ quiz.title }}</h3>
                  <q-icon
                    v-if="quiz.completed"
                    name="check_circle"
                    size="20px"
                    color="green"
                  />
                </div>

                <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                  <div style="display: flex; align-items: center; justify-content: space-between; font-size: 0.875rem; color: #4B5563;">
                    <span>문항 수</span>
                    <span style="font-weight: 600;">{{ quiz.questions }}문제</span>
                  </div>

                  <q-card
                    v-if="quiz.completed && quiz.score !== null"
                    flat
                    style="background-color: rgba(167, 232, 189, 0.2); padding: 0.75rem;"
                  >
                    <div style="display: flex; align-items: center; justify-content: space-between;">
                      <span style="font-size: 0.875rem; color: #374151;">점수</span>
                      <span style="font-size: 1.5rem; font-weight: 700; color: #15803d;">{{ quiz.score }}점</span>
                    </div>
                  </q-card>

                  <q-btn
                    :label="quiz.completed ? '재도전하기' : '시작하기'"
                    :color="quiz.completed ? 'grey' : 'orange'"
                    unelevated
                    no-caps
                    style="width: 100%;"
                    @click="() => startQuiz(quiz.id)"
                  />
                </div>
              </q-card>
            </div>
          </section>
        </div>
      </div>
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
import { useAuth } from '../composables/useAuth'
import { useCategories } from '../composables/useCategories'
import { usePolicies } from '../composables/usePolicies'
import { useLearning } from '../composables/useLearning'

const route = useRoute()
const router = useRouter()
const $q = useQuasar()

const { user } = useAuth()
const { getCategoryBySlug } = useCategories()
const { policies, fetchPoliciesByCategory } = usePolicies()
const {
  videos,
  quizzes,
  qnaList,
  fetchVideosByCategory,
  fetchQuizzesByCategory,
  fetchQnAByCategory,
  fetchLearningProgress
} = useLearning()

const category = computed(() => route.params.category as string)
const categoryData = ref<any>(null)
const completionRate = ref(0)
const loading = ref(true)

// 카테고리 데이터 가져오기
const loadCategoryData = async () => {
  loading.value = true

  try {
    // 카테고리 정보 가져오기
    const categoryInfo = await getCategoryBySlug(category.value)

    if (!categoryInfo) {
      $q.notify({
        type: 'negative',
        message: '카테고리를 찾을 수 없습니다.',
        position: 'top'
      })
      router.push('/')
      return
    }

    categoryData.value = categoryInfo

    // 정책 가져오기
    await fetchPoliciesByCategory(category.value)

    // Q&A 가져오기
    await fetchQnAByCategory(categoryInfo.id)

    // 영상 가져오기
    await fetchVideosByCategory(categoryInfo.id, user.value?.id)

    // 퀴즈 가져오기
    await fetchQuizzesByCategory(categoryInfo.id, user.value?.id)

    // 이수율 가져오기 (로그인 시)
    if (user.value) {
      const progress = await fetchLearningProgress(user.value.id, categoryInfo.id)
      completionRate.value = progress?.completion_percentage || 0
    }
  } catch (error: any) {
    console.error('카테고리 데이터 로딩 에러:', error)
    $q.notify({
      type: 'negative',
      message: '데이터를 불러오는 중 오류가 발생했습니다.',
      position: 'top'
    })
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadCategoryData()
})

const handleBack = () => {
  router.push('/')
}

const viewPolicy = (policyId: number) => {
  console.log('View policy:', policyId)
  // TODO: 정책 상세 페이지로 이동
}

const watchVideo = (videoId: number) => {
  console.log('Watch video:', videoId)
  // TODO: 영상 재생 페이지로 이동
}

const startQuiz = (quizId: number) => {
  console.log('Start quiz:', quizId)
  // TODO: 퀴즈 페이지로 이동
}
</script>
