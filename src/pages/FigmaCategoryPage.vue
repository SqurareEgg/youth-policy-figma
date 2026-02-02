<template>
  <div style="min-height: 100vh; background-color: white;">
    <FigmaHeader :current-category="categoryData?.name || null" />

    <div style="min-height: 100vh; background-color: #F9FAFB;">
      <!-- Back Button & Header -->
      <div style="background-color: white; border-bottom: 1px solid #E5E7EB; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);">
        <div style="max-width: 1280px; margin: 0 auto; padding: 1.5rem 1rem;">
          <q-btn
            flat
            icon="arrow_back"
            label="홈으로 돌아가기"
            @click="handleBack"
            style="color: #6B7280; margin-bottom: 1rem;"
            no-caps
            class="back-button"
          />

          <div>
            <h1 class="page-title">{{ categoryData?.name || category }} 정책</h1>
            <p class="page-description">청년을 위한 {{ categoryData?.name || category }} 관련 정책을 학습하고 혜택을 받아보세요</p>
          </div>
        </div>
      </div>

      <!-- 로딩 중 -->
      <div v-if="loading" style="text-align: center; padding: 3rem;">
        <q-spinner size="50px" color="orange" />
        <p style="margin-top: 1rem; color: #4B5563;">데이터를 불러오는 중...</p>
      </div>

      <!-- 메인 레이아웃 -->
      <div v-else class="container">
        <div style="display: flex; gap: 4rem;">
          <!-- 사이드바 (데스크탑) -->
          <aside class="gt-md sidebar">
            <div style="background-color: white; border: 1px solid #E5E7EB; border-radius: 1rem; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05); padding: 1rem;">
              <h3 style="font-size: 1.125rem; font-weight: 700; color: #111827; margin-bottom: 1rem; padding: 0 0.75rem; white-space: nowrap;">세부 정책</h3>
              <nav style="display: flex; flex-direction: column; gap: 0.25rem;">
                <button
                  v-for="subPolicy in subPolicies"
                  :key="subPolicy.id"
                  class="sidebar-button"
                >
                  <span style="font-size: 0.875rem; line-height: 1.25; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">{{ subPolicy.title }}</span>
                </button>
              </nav>
            </div>
          </aside>

          <!-- 메인 콘텐츠 -->
          <main style="flex: 1; padding-right: 0;">
            <!-- 모바일 탭 (모바일만) -->
            <div class="lt-lg mobile-tabs">
              <div style="display: flex; gap: 0.5rem; padding: 1rem 0; min-width: max-content;">
                <button
                  v-for="(subPolicy, index) in subPolicies"
                  :key="subPolicy.id"
                  class="mobile-tab-button"
                >
                  <q-icon :name="subPolicy.icon" size="24px" />
                  <span style="font-size: 0.75rem; text-align: center; line-height: 1.25;">정책{{ index + 1 }}</span>
                </button>
              </div>
            </div>

            <!-- 콘텐츠 영역 -->
            <div class="content-area">
              <!-- 카테고리 소개 -->
              <div class="category-intro-section">
                <h2 class="category-intro-title">{{ categoryIntro.title }}</h2>
                <p class="category-intro-description">{{ categoryIntro.description }}</p>
              </div>

              <div class="sections-container">
                <!-- 세부 정책 안내 Section -->
                <section class="policy-section">
                  <h3 class="section-title">세부 정책 안내</h3>

                  <div class="policy-cards-container">
                    <button
                      v-for="(subPolicy, index) in subPolicies"
                      :key="subPolicy.id"
                      class="policy-card"
                    >
                      <div class="policy-card-content">
                        <span class="policy-number">{{ String(index + 1).padStart(2, '0') }}</span>
                        <h4 class="policy-card-title">{{ subPolicy.title }}</h4>
                      </div>
                      <p class="policy-card-description">{{ subPolicy.description }}</p>
                    </button>
                  </div>
                </section>

                <!-- 학습 현황 Section -->
                <section class="learning-progress-section">
                  <div class="learning-progress-header">
                    <div>
                      <h3 class="learning-progress-title">{{ categoryData?.name || category }} 정책 학습 현황</h3>
                    </div>
                    <div class="learning-progress-percentage">
                      <span class="learning-progress-number">{{ Math.round(completionRate) }}</span>
                      <span class="learning-progress-percent">%</span>
                    </div>
                  </div>

                  <div>
                    <q-linear-progress
                      :value="completionRate / 100"
                      color="orange"
                      track-color="rgba(249, 115, 22, 0.2)"
                      size="10px"
                      style="border-radius: 9999px;"
                    />
                    <p class="learning-progress-hint">영상을 시청하면 이수율이 올라갑니다.</p>
                  </div>
                </section>

                <!-- 정책을 쉽게 이해하기 Section (동영상/Q&A/Quiz 그리드) -->
                <section>
                  <h3 class="section-title">정책을 쉽게 이해하기</h3>

                  <div class="learning-grid">
                    <!-- 동영상 학습 카드 (왼쪽 큰 카드) -->
                    <div class="learning-card learning-card-video">
                      <div class="learning-card-header">
                        <h3 class="learning-card-title">동영상 학습</h3>
                        <p class="learning-card-description">5분 영상으로 정책의 핵심 내용을 빠르게 파악할 수 있습니다.</p>
                      </div>

                      <div v-if="videos.length > 0" class="video-preview">
                        <div class="video-thumbnail">
                          <div style="position: absolute; inset: 0; display: flex; align-items: center; justify-content: center;">
                            <div style="background-color: rgba(255, 255, 255, 0.9); border-radius: 9999px; padding: 1rem;">
                              <q-icon name="play_arrow" size="32px" color="orange" />
                            </div>
                          </div>
                          <img
                            :src="videos[0].thumbnail_url"
                            :alt="videos[0].title"
                            style="width: 100%; height: 100%; object-fit: cover; opacity: 0.8;"
                            @error="(e) => e.target.src = 'https://images.unsplash.com/photo-1588196749597-9ff075ee6b5b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800'"
                          />
                        </div>
                        <q-btn
                          label="시청하기"
                          color="orange"
                          unelevated
                          no-caps
                          style="width: 100%; margin-top: 1rem;"
                          @click="() => watchVideo(videos[0].id)"
                        />
                      </div>
                      <div v-else style="text-align: center; padding: 2rem; color: #6B7280;">
                        영상이 준비 중입니다.
                      </div>
                    </div>

                    <!-- 오른쪽 작은 카드들 -->
                    <div class="learning-cards-right">
                      <!-- Q&A 카드 -->
                      <div class="learning-card">
                        <h3 class="learning-card-title">자주 묻는 질문</h3>
                        <p class="learning-card-description">다른 청년들이 궁금해하는 내용을 Q&A 형식으로 확인하세요</p>
                        <q-btn
                          label="질문 보기"
                          flat
                          no-caps
                          class="secondary-button"
                        />
                      </div>

                      <!-- Quiz 카드 -->
                      <div class="learning-card">
                        <h3 class="learning-card-title">QUIZ</h3>
                        <p class="learning-card-description">10문제로 구성된 퀴즈로 내가 얼마나 이해했는지 점검해보세요</p>
                        <div style="background-color: #F9FAFB; border-radius: 0.5rem; padding: 0.75rem; margin-top: 0.75rem;">
                          <div style="display: flex; justify-content: space-between; font-size: 0.875rem;">
                            <span style="color: #6B7280;">문항 수</span>
                            <span style="font-weight: 500; color: #111827;">{{ quizzes.length > 0 ? (quizzes[0].questionCount || 10) : 10 }}문제</span>
                          </div>
                        </div>
                        <q-btn
                          label="시작하기"
                          flat
                          no-caps
                          class="secondary-button"
                          style="margin-top: 0.75rem;"
                          @click="quizzes.length > 0 ? startQuiz(quizzes[0].id) : null"
                        />
                      </div>
                    </div>
                  </div>
                </section>
              </div>
            </div>
          </main>
        </div>
      </div>
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onActivated, watch } from 'vue'
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

// 카테고리별 소개 정보
const categoryIntro = computed(() => {
  const introMap: Record<string, { title: string; description: string }> = {
    'job': {
      title: '일자리 정책: 청년의 내일을 여는 맞춤형 고용 지원',
      description: '대한민국 청년들이 첫 일자리에 성공적으로 진입하고, 안정적인 노동 환경 속에서 꿈을 펼칠 수 있도록 6가지 핵심 사업을 추진합니다.'
    },
    'housing': {
      title: '주거 정책: 안정적인 주거환경 조성',
      description: '청년들이 주거 걱정 없이 자립할 수 있도록 전월세 지원부터 공공임대주택까지 다양한 주거 지원 정책을 제공합니다.'
    },
    'education': {
      title: '교육 정책: 평생학습 기회 확대',
      description: '청년들의 역량 개발과 경력 향상을 위해 학자금 지원, 직업훈련, 평생교육 등 다양한 교육 기회를 제공합니다.'
    },
    'finance-welfare-culture': {
      title: '금융·복지·문화 정책: 삶의 질 향상 지원',
      description: '청년들의 경제적 안정과 문화생활 향유를 위해 금융 지원, 생활비 지원, 건강 및 문화 프로그램을 운영합니다.'
    },
    'participation': {
      title: '참여 정책: 청년의 목소리를 정책에 반영',
      description: '청년들이 직접 정책 결정 과정에 참여하고, 권익을 보호받을 수 있도록 다양한 참여 채널과 지원 프로그램을 운영합니다.'
    }
  }

  return introMap[category.value] || { title: '', description: '' }
})

// 카테고리별 세부 정책 리스트
const subPolicies = computed(() => {
  const policyMap: Record<string, Array<{ id: number; title: string; icon: string; description: string }>> = {
    'job': [
      { id: 1, title: '첫 일자리 진입 및 조기 사회진출 지원', icon: 'business_center', description: '청년들이 학교를 졸업한 후 지체 없이 노동시장에 안착할 수 있도록 민간과 공공의 협력을 통한 통합 지원 체계를 가동합니다.' },
      { id: 2, title: '다시 서기 및 안정적 구직 지원', icon: 'refresh', description: '일시적으로 구직을 중단하거나 어려움을 겪는 청년들이 사회로 다시 돌아올 수 있는 튼튼한 안전망을 구축합니다.' },
      { id: 3, title: '실무 역량 강화 및 일경험 확대', icon: 'school', description: '기업 현장에서 바로 활용할 수 있는 실무 능력을 배양하고, 군 복무 기간까지 역량 개발의 기회로 활용합니다.' },
      { id: 4, title: '지역 유입 및 분야별 정착 지원', icon: 'location_on', description: '청년들이 지역에서도 충분한 기회를 찾고 안정적으로 정착할 수 있도록 지역 특화 산업과 연계한 패키지 지원을 강화합니다.' },
      { id: 5, title: '노동환경 개선 및 권익 보호', icon: 'shield', description: '다양한 형태의 노동에 종사하는 청년들의 권리를 보호하고, 쾌적하며 안전한 근무 환경을 조성합니다.' },
      { id: 6, title: '청년 창업 생태계 구축', icon: 'lightbulb', description: '도전적인 아이디어를 보유한 청년이 안심하고 창업에 도전하고, 실패해도 다시 일어설 수 있는 혁신 생태계를 조성합니다.' }
    ],
    'housing': [
      { id: 1, title: '전월세 지원', icon: 'home', description: '청년들의 주거비 부담을 줄이기 위해 전월세 보증금 대출 및 월세 지원 프로그램을 운영합니다.' },
      { id: 2, title: '공공임대주택', icon: 'apartment', description: '저렴한 임대료로 안정적인 주거 환경을 제공하는 행복주택, 매입임대주택 등을 공급합니다.' },
      { id: 3, title: '주거급여', icon: 'payments', description: '소득 수준에 따라 월세 또는 전세자금을 지원하여 주거 안정을 도모합니다.' },
      { id: 4, title: '주택구입 지원', icon: 'real_estate_agent', description: '생애최초 주택구입자를 위한 대출 및 금리 우대 프로그램을 제공합니다.' },
      { id: 5, title: '주거환경 개선', icon: 'home_repair_service', description: '노후 주택 수리 및 안전 점검 지원을 통해 쾌적한 주거 환경을 조성합니다.' }
    ],
    'education': [
      { id: 1, title: '학자금 지원', icon: 'school', description: '대학 등록금 및 생활비 대출을 저금리로 제공하여 교육 기회를 확대합니다.' },
      { id: 2, title: '직업훈련', icon: 'work', description: '취업에 필요한 실무 기술과 자격증 취득을 위한 직업훈련 프로그램을 운영합니다.' },
      { id: 3, title: '평생교육', icon: 'menu_book', description: '온오프라인 교육 바우처를 통해 다양한 분야의 평생학습 기회를 제공합니다.' },
      { id: 4, title: '자격증 취득 지원', icon: 'workspace_premium', description: '국가기술자격증 응시료 및 교육비를 지원하여 전문성 향상을 돕습니다.' },
      { id: 5, title: '해외연수 지원', icon: 'flight', description: '글로벌 역량 강화를 위한 해외 연수 및 인턴십 프로그램을 지원합니다.' }
    ],
    'finance-welfare-culture': [
      { id: 1, title: '금융 지원', icon: 'account_balance', description: '청년내일저축계좌, 청년희망적금 등 자산형성 지원 프로그램을 운영합니다.' },
      { id: 2, title: '생활비 지원', icon: 'payments', description: '구직활동 중인 청년에게 월 최대 50만원의 생활비를 지원합니다.' },
      { id: 3, title: '건강 및 의료 지원', icon: 'health_and_safety', description: '건강검진, 예방접종, 치과 진료 등 의료비 지원 프로그램을 제공합니다.' },
      { id: 4, title: '문화생활 지원', icon: 'theater_comedy', description: '문화누리카드를 통해 공연, 전시, 영화 관람 등 문화생활을 지원합니다.' },
      { id: 5, title: '심리상담 지원', icon: 'psychology', description: '청년 마음건강 지원 사업을 통해 무료 심리상담 서비스를 제공합니다.' }
    ],
    'participation': [
      { id: 1, title: '청년정책 참여', icon: 'how_to_vote', description: '청년정책참여단, 청년위원회 등을 통해 정책 결정 과정에 직접 참여할 수 있습니다.' },
      { id: 2, title: '청년활동 지원', icon: 'groups', description: '청년 동아리, 네트워킹 행사 등 다양한 활동에 대한 공간 및 예산을 지원합니다.' },
      { id: 3, title: '권익보호 및 법률지원', icon: 'gavel', description: '노동, 주거, 금융 등 생활 전반의 법률 문제에 대해 무료 상담과 지원을 제공합니다.' },
      { id: 4, title: '청년네트워크 구축', icon: 'hub', description: '지역별, 분야별 청년 네트워크를 구축하고 교류의 장을 마련합니다.' },
      { id: 5, title: '정책제안 및 모니터링', icon: 'rate_review', description: '청년이 직접 정책을 제안하고 실행 과정을 모니터링할 수 있는 채널을 운영합니다.' }
    ]
  }

  return policyMap[category.value] || []
})

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

// 영상/퀴즈에서 돌아왔을 때 데이터 재로드
onActivated(() => {
  console.log('카테고리 페이지 활성화 - 데이터 재로드')
  loadCategoryData()
})

// 카테고리 변경 감지
watch(category, () => {
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
  router.push({
    name: 'video',
    params: {
      category: category.value,
      videoId: videoId.toString()
    }
  })
}

const startQuiz = (quizId: number) => {
  router.push({
    name: 'quiz',
    params: {
      category: category.value,
      quizId: quizId.toString()
    }
  })
}
</script>

<style scoped>
.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 1rem;
}

@media (min-width: 640px) {
  .container {
    padding: 0 1.5rem;
  }
}

@media (min-width: 1024px) {
  .container {
    padding: 0 2rem;
  }
}

/* 뒤로가기 버튼 */
.back-button {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  transition: color 0.2s;
}

.back-button:hover {
  color: #F97316 !important;
}

/* 페이지 헤더 */
.page-title {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

@media (min-width: 640px) {
  .page-title {
    font-size: 1.875rem;
  }
}

.page-description {
  color: #6B7280;
  margin-top: 0.5rem;
}

/* 카테고리 소개 */
.category-intro-title {
  font-size: 1.5rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  line-height: 1.3;
}

@media (min-width: 640px) {
  .category-intro-title {
    font-size: 1.875rem;
    margin-bottom: 0.75rem;
  }
}

.category-intro-description {
  font-size: 1rem;
  color: #374151;
  line-height: 1.6;
}

@media (min-width: 640px) {
  .category-intro-description {
    font-size: 1.125rem;
  }
}

/* 세부 정책 섹션 */
.policy-section {
  background-color: white;
  border-radius: 1rem;
  border: 1px solid #E5E7EB;
  padding: 1.25rem;
  margin-top: 0;
}

@media (min-width: 640px) {
  .policy-section {
    padding: 1.75rem;
  }
}

/* 섹션 타이틀 */
.section-title {
  font-size: 1.125rem;
  font-weight: 700;
  margin-bottom: 1rem;
}

@media (min-width: 640px) {
  .section-title {
    font-size: 1.25rem;
    margin-bottom: 1.25rem;
  }
}

/* 세부 정책 카드 컨테이너 */
.policy-cards-container {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

@media (min-width: 640px) {
  .policy-cards-container {
    gap: 1rem;
  }
}

/* 세부 정책 카드 */
.policy-card {
  width: 100%;
  text-align: left;
  padding: 1rem;
  border-radius: 0.75rem;
  border: 1px solid #E5E7EB;
  background-color: transparent;
  cursor: pointer;
  transition: all 0.2s;
}

@media (min-width: 640px) {
  .policy-card {
    padding: 1.25rem;
  }
}

.policy-card:hover {
  border-color: #F97316;
  background-color: rgba(249, 115, 22, 0.05);
}

.policy-card-content {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  margin-bottom: 0.25rem;
}

@media (min-width: 640px) {
  .policy-card-content {
    gap: 1rem;
    margin-bottom: 0.375rem;
  }
}

.policy-number {
  color: #F97316;
  font-weight: 600;
  font-size: 1rem;
  flex-shrink: 0;
}

.policy-card-title {
  font-size: 1rem;
  font-weight: 600;
  margin: 0;
  flex: 1;
  transition: color 0.2s;
  line-height: 1.5;
}

@media (min-width: 640px) {
  .policy-card-title {
    font-size: 1.125rem;
  }
}

.policy-card:hover .policy-card-title {
  color: #F97316;
}

.policy-card-description {
  font-size: 0.875rem;
  color: #6B7280;
  line-height: 1.6;
  margin: 0;
  padding-left: calc(1rem + 0.75rem);
}

@media (min-width: 640px) {
  .policy-card-description {
    padding-left: calc(1rem + 1rem);
  }
}

/* 학습 현황 섹션 */
.learning-progress-section {
  background: linear-gradient(135deg, #FFF7ED 0%, #FFFFFF 100%);
  border-radius: 1rem;
  border: 1px solid #FED7AA;
  padding: 1.25rem;
}

@media (min-width: 640px) {
  .learning-progress-section {
    padding: 1.5rem;
  }
}

.learning-progress-header {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

@media (min-width: 640px) {
  .learning-progress-header {
    flex-direction: row;
    align-items: flex-end;
    justify-content: space-between;
    margin-bottom: 1.25rem;
  }
}

.learning-progress-title {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 0;
}

@media (min-width: 640px) {
  .learning-progress-title {
    font-size: 1.5rem;
  }
}

.learning-progress-percentage {
  display: flex;
  align-items: baseline;
  gap: 0.5rem;
}

.learning-progress-number {
  font-size: 2.5rem;
  font-weight: 700;
  color: #F97316;
}

@media (min-width: 640px) {
  .learning-progress-number {
    font-size: 3rem;
  }
}

.learning-progress-percent {
  font-size: 1.125rem;
  color: #6B7280;
}

.learning-progress-hint {
  font-size: 0.75rem;
  color: #6B7280;
  margin-top: 0.5rem;
  margin-bottom: 0;
}

/* 정책을 쉽게 이해하기 그리드 */
.learning-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@media (min-width: 768px) {
  .learning-grid {
    grid-template-columns: 1.3fr 1fr;
    gap: 1.25rem;
    align-items: start;
  }
}

/* 학습 카드 */
.learning-card {
  background-color: white;
  border-radius: 1rem;
  border: 1px solid #E5E7EB;
  padding: 1.25rem;
  transition: all 0.2s;
  cursor: pointer;
}

@media (min-width: 640px) {
  .learning-card {
    padding: 1.5rem;
  }
}

.learning-card:hover {
  border-color: #F97316;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.learning-card-video {
  cursor: default;
  display: flex;
  flex-direction: column;
}

@media (min-width: 768px) {
  .learning-card-video {
    height: 100%;
  }
}

.learning-card-header {
  margin-bottom: 0.75rem;
}

.learning-card-title {
  font-size: 1.125rem;
  font-weight: 700;
  margin: 0 0 0.375rem 0;
}

@media (min-width: 640px) {
  .learning-card-title {
    font-size: 1.25rem;
  }
}

.learning-card:hover .learning-card-title {
  color: #F97316;
}

.learning-card-video:hover .learning-card-title {
  color: inherit;
}

.learning-card-description {
  font-size: 0.875rem;
  color: #6B7280;
  line-height: 1.6;
  margin: 0;
}

/* 오른쪽 작은 카드들 */
.learning-cards-right {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* 동영상 미리보기 */
.video-preview {
  width: 100%;
  display: flex;
  flex-direction: column;
}

@media (min-width: 768px) {
  .video-preview {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
}

.video-thumbnail {
  position: relative;
  border-radius: 0.75rem;
  overflow: hidden;
  background-color: #111827;
  width: 100%;
  aspect-ratio: 16/9;
}

@media (min-width: 768px) {
  .video-thumbnail {
    aspect-ratio: 16/9;
    max-height: 200px;
  }
}

/* 버튼 스타일 */
.secondary-button {
  width: 100%;
  margin-top: 1rem;
  background-color: white;
  border: 0;
  color: #374151;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  font-weight: 500;
}

.secondary-button:hover {
  background-color: #F9FAFB;
}

/* 콘텐츠 영역 */
.content-area {
  padding-top: 1.5rem;
  padding-bottom: 2rem;
}

@media (min-width: 768px) {
  .content-area {
    padding-top: 2rem;
  }
}

/* 카테고리 소개 섹션 */
.category-intro-section {
  margin-bottom: 1.5rem;
}

@media (min-width: 768px) {
  .category-intro-section {
    margin-bottom: 2rem;
  }
}

/* 섹션 컨테이너 */
.sections-container {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

@media (min-width: 768px) {
  .sections-container {
    gap: 1rem;
  }
}

/* 사이드바 */
.sidebar {
  width: 18rem;
  min-height: 100vh;
  position: sticky;
  top: 0;
  margin-left: -1rem;
  padding-left: 1rem;
  padding-top: 1.5rem;
}

@media (min-width: 640px) {
  .sidebar {
    margin-left: -1.5rem;
    padding-left: 1.5rem;
  }
}

@media (min-width: 1024px) {
  .sidebar {
    margin-left: -2rem;
    padding-left: 2rem;
  }
}

.sidebar-button {
  width: 100%;
  display: flex;
  align-items: center;
  padding: 0.75rem;
  border-radius: 0.5rem;
  transition: all 0.2s;
  text-align: left;
  color: #374151;
  background-color: transparent;
  border: none;
  cursor: pointer;
}

.sidebar-button:hover {
  background-color: #F3F4F6;
}

/* 모바일 탭 */
.mobile-tabs {
  background-color: white;
  border-bottom: 1px solid #E5E7EB;
  overflow-x: auto;
  margin: 0 -1rem;
  padding: 0 1rem;
  margin-bottom: 1.5rem;
}

@media (min-width: 640px) {
  .mobile-tabs {
    margin: 0 -1.5rem;
    padding: 0 1.5rem;
  }
}

.mobile-tab-button {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1rem;
  border-radius: 0.75rem;
  transition: all 0.2s;
  min-width: 100px;
  background-color: #F3F4F6;
  color: #374151;
  border: none;
  cursor: pointer;
}

.mobile-tab-button:hover {
  background-color: #E5E7EB;
}
</style>
