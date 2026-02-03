<template>
  <div style="min-height: 100vh; background-color: white; overflow-x: hidden;">
    <FigmaHeader :current-category="categoryName" />

    <div style="min-height: 100vh; background-color: white; overflow-x: hidden;">
      <!-- Back Button & Header -->
      <div style="background-color: white; border-bottom: 1px solid #E5E7EB; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);">
        <div class="container" style="padding: 1.5rem 1rem;">
          <q-btn
            flat
            icon="arrow_back"
            label="홈으로 돌아가기"
            @click="handleBackToHome"
            style="color: #6B7280; margin-bottom: 1rem;"
            no-caps
            class="back-button"
          />

          <div>
            <h1 class="page-title">{{ categoryName }} 정책</h1>
            <p class="page-description">청년을 위한 {{ categoryName }} 관련 정책을 학습하고 혜택을 받아보세요</p>
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
        <div class="main-layout">
          <!-- 사이드바 (데스크탑) -->
          <aside class="gt-md sidebar">
            <div style="background-color: white; border: 1px solid #E5E7EB; border-radius: 1rem; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05); padding: 1rem;">
              <h3 style="font-size: 1.125rem; font-weight: 700; color: #111827; margin-bottom: 1rem; padding: 0 0.75rem; white-space: nowrap;">세부 정책</h3>
              <nav style="display: flex; flex-direction: column; gap: 0.25rem;">
                <button
                  v-for="subPolicy in subPolicies"
                  :key="subPolicy.id"
                  class="sidebar-button"
                  @click="viewPolicy(subPolicy.id)"
                >
                  <span style="font-size: 0.875rem; line-height: 1.25; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">{{ subPolicy.title }}</span>
                </button>
              </nav>
            </div>
          </aside>

          <!-- 메인 콘텐츠 -->
          <main class="main-content">
            <!-- 모바일 탭 (모바일만) -->
            <div class="lt-lg mobile-tabs">
              <div style="display: flex; gap: 0.5rem; padding: 1rem 0; min-width: max-content;">
                <button
                  v-for="(subPolicy, index) in subPolicies"
                  :key="subPolicy.id"
                  class="mobile-tab-button"
                  @click="viewPolicy(subPolicy.id)"
                >
                  <q-icon :name="subPolicy.icon" size="24px" />
                  <span style="font-size: 0.75rem; text-align: center; line-height: 1.25;">정책{{ index + 1 }}</span>
                </button>
              </div>
            </div>

            <!-- Q&A 콘텐츠 영역 -->
            <div class="content-area">
              <!-- Q&A 헤더 카드 -->
              <div class="qna-header-card">
                <q-btn
                  flat
                  icon="arrow_back"
                  label="목록으로 돌아가기"
                  @click="handleBackToCategory"
                  style="color: #6B7280; margin-bottom: 1rem;"
                  no-caps
                  class="back-button"
                />
                <h2 style="font-size: 1.5rem; font-weight: 700; color: #111827; margin-bottom: 0.5rem;">{{ categoryName }} 정책 Q&A</h2>
                <p style="color: #6B7280;">자주 묻는 질문과 답변을 확인하세요</p>
              </div>

              <!-- Q&A 아코디언 목록 -->
              <div class="qna-list">
                <div
                  v-for="(item, index) in qnaItems"
                  :key="index"
                  class="qna-item"
                >
                  <button
                    class="qna-question-button"
                    @click="toggleQnA(index)"
                  >
                    <div class="qna-question-content">
                      <span class="qna-badge">Q{{ index + 1 }}</span>
                      <h3 class="qna-question-title">{{ item.question }}</h3>
                    </div>
                    <q-icon
                      :name="expandedItems.includes(index) ? 'expand_less' : 'expand_more'"
                      size="20px"
                      style="color: #9CA3AF; flex-shrink: 0; margin-left: 1rem;"
                    />
                  </button>

                  <!-- 답변 영역 (확장 시 표시) -->
                  <transition
                    enter-active-class="qna-answer-enter-active"
                    leave-active-class="qna-answer-leave-active"
                  >
                    <div v-if="expandedItems.includes(index)" class="qna-answer">
                      <div class="qna-answer-badge">A</div>
                      <div class="qna-answer-content">
                        {{ item.answer }}
                      </div>
                    </div>
                  </transition>
                </div>
              </div>
            </div>
          </main>
        </div>
      </div>
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useQuasar } from 'quasar'
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
import { useCategories } from '../composables/useCategories'

const router = useRouter()
const route = useRoute()
const $q = useQuasar()

const { getCategoryBySlug } = useCategories()

const category = ref(route.params.category)
const loading = ref(true)
const categoryData = ref(null)
const expandedItems = ref([])

// 카테고리 slug to name 매핑
const categoryNameMap = {
  'job': '일자리',
  'housing': '주거',
  'education': '교육',
  'finance-welfare-culture': '금융･복지･문화',
  'participation': '참여'
}

const categoryName = computed(() => categoryData.value?.name || categoryNameMap[category.value] || category.value)

// 카테고리별 세부 정책 리스트
const subPolicies = computed(() => {
  const policyMap = {
    'job': [
      { id: 1, title: '첫 일자리 진입 및 조기 사회진출 지원', icon: 'business_center' },
      { id: 2, title: '다시 서기 및 안정적 구직 지원', icon: 'refresh' },
      { id: 3, title: '실무 역량 강화 및 일경험 확대', icon: 'school' },
      { id: 4, title: '지역 유입 및 분야별 정착 지원', icon: 'location_on' },
      { id: 5, title: '노동환경 개선 및 권익 보호', icon: 'shield' },
      { id: 6, title: '청년 창업 생태계 구축', icon: 'lightbulb' }
    ],
    'housing': [
      { id: 1, title: '청년 공공주택 공급 확대 및 제도 내실화', icon: 'apartment' },
      { id: 2, title: '청년 특화·기숙사형 주택', icon: 'apartment_complex' },
      { id: 3, title: '대학 기숙사 확충 및 청년친화 시설 개선', icon: 'school' },
      { id: 4, title: '지역 일자리 연계 청년 주거 모델 확산', icon: 'location_city' },
      { id: 5, title: '청년 주거비 및 금융 지원 확대', icon: 'account_balance_wallet' },
      { id: 6, title: '청년 주거 안정망 및 상담·지원 체계 강화', icon: 'support_agent' }
    ],
    'education': [
      { id: 1, title: 'AI·SW 역량 강화 및 교육 확산', icon: 'computer' },
      { id: 2, title: '온라인 AI 교육 확대 및 청년 주도 AX', icon: 'online_prediction' },
      { id: 3, title: '실무 역량 강화 및 맞춤형 인재 양성', icon: 'psychology' },
      { id: 4, title: '청년 과학기술인 성장 지원', icon: 'science' },
      { id: 5, title: '전략산업 전문 청년 인재 양성', icon: 'precision_manufacturing' },
      { id: 6, title: '교육-일자리 연계 및 교육 격차 해소', icon: 'connect_without_contact' }
    ],
    'finance-welfare-culture': [
      { id: 1, title: '청년 초기 자산 형성 지원 강화', icon: 'savings' },
      { id: 2, title: '금융 안전망 구축 및 경제 역량 강화', icon: 'account_balance' },
      { id: 3, title: '고립·은둔 및 가족돌봄 청년 집중 케어', icon: 'volunteer_activism' },
      { id: 4, title: '자립 기반 강화 및 복지 사각지대 해소', icon: 'support' },
      { id: 5, title: '마음·신체 건강 통합 관리', icon: 'health_and_safety' },
      { id: 6, title: '문화 향유 확대 및 필수 생활비 경감', icon: 'theater_comedy' }
    ],
    'participation': [
      { id: 1, title: '청년의 국정 참여 확대 및 소통 강화', icon: 'forum' },
      { id: 2, title: '정책 결정 권한 강화 및 거버넌스 확립', icon: 'how_to_vote' },
      { id: 3, title: '디지털 기반 참여 플랫폼 고도화', icon: 'devices' },
      { id: 4, title: '지역 중심 청년 생태계 조성', icon: 'location_city' },
      { id: 5, title: '지속가능한 지원 인프라 및 법령 정비', icon: 'policy' },
      { id: 6, title: '글로벌 교류 확대 및 상생 문화 확산', icon: 'public' }
    ]
  }

  return policyMap[category.value] || []
})

// Q&A 데이터 (카테고리별)
const qnaData = {
  'job': [
    {
      question: '청년내일채움공제는 어떤 제도인가요?',
      answer: '청년내일채움공제는 청년이 중소·중견기업에 정규직으로 취업하면 정부, 기업, 청년이 함께 2~5년간 공제금을 적립하여 목돈을 마련할 수 있도록 지원하는 제도입니다. 만기 시 최대 3,000만원 이상의 목돈을 받을 수 있습니다.'
    },
    {
      question: '국민취업지원제도 신청 자격은 어떻게 되나요?',
      answer: '만 15~69세의 구직자로서 가구단위 소득이 중위소득 60% 이하이고, 재산이 4억원 이하인 분들이 신청할 수 있습니다. 1유형은 취업촉진수당을 월 최대 50만원, 최대 6개월간 지급받을 수 있으며, 취업지원서비스도 제공됩니다.'
    },
    {
      question: '청년 일자리 도약 장려금은 어떻게 받나요?',
      answer: '5인 이상 우선지원 대상기업에 정규직으로 취업한 만 15~34세 청년에게 월 최대 80만원씩, 최대 1년간 지원됩니다. 기업은 고용센터에 신청하며, 청년은 별도 신청 없이 자동으로 지급받습니다.'
    },
    {
      question: 'AI 고용 서비스는 어떻게 이용하나요?',
      answer: '워크넷 홈페이지나 앱에서 AI 맞춤형 구직 서비스를 이용할 수 있습니다. 개인의 역량과 선호를 분석하여 적합한 일자리를 추천하고, 이력서 작성 도움, 면접 준비 등 종합적인 취업 지원 서비스를 제공합니다.'
    },
    {
      question: '청년 자격증 응시료 감면 대상은?',
      answer: '만 34세 이하의 청년 구직자로서 기초생활수급자, 차상위계층, 한부모가족 등에 해당하는 경우 국가기술자격 필기시험 응시료의 50~100%를 감면받을 수 있습니다.'
    },
    {
      question: '청년 구직급여는 자발적 이직자도 받을 수 있나요?',
      answer: '원칙적으로는 비자발적 이직자만 구직급여를 받을 수 있습니다. 다만, 건강상의 이유, 출퇴근 곤란, 임금체불 등 정당한 사유가 있는 경우에는 자발적 이직이라도 구직급여를 받을 수 있습니다.'
    },
    {
      question: '군 복무 중에도 역량 개발이 가능한가요?',
      answer: '네, 가능합니다. 군 복무 중 자격증 취득 지원, 온라인 교육 프로그램, 전역 후 취업 연계 프로그램 등을 통해 역량을 개발할 수 있으며, 전역 후 취업에도 도움을 받을 수 있습니다.'
    },
    {
      question: '플랫폼 종사자도 노동권익 보호를 받나요?',
      answer: '네, 플랫폼 종사자도 산업재해보상보험, 고용보험 등에 가입할 수 있으며, 노동권익센터를 통해 권익 보호 상담과 법률 지원을 받을 수 있습니다.'
    },
    {
      question: '청년 창업 자금은 얼마나 지원받을 수 있나요?',
      answer: '창업 단계와 분야에 따라 다르지만, 일반적으로 초기 창업 자금은 5천만원~1억원, 성장 단계에서는 최대 3억원까지 지원받을 수 있습니다. 융자와 보조금 형태로 지원되며, 멘토링과 교육 프로그램도 함께 제공됩니다.'
    },
    {
      question: '지역에서 일자리를 찾으면 어떤 혜택이 있나요?',
      answer: '대전 지역 기업에 취업 시 이전 지원금, 주거 지원금, 정착 장려금 등을 받을 수 있습니다. 또한 지역 특화 산업 분야 취업 시 추가 인센티브와 교육 기회도 제공됩니다.'
    }
  ],
  'housing': [
    {
      question: '청년 전월세 보증금 대출은 어떻게 신청하나요?',
      answer: '만 19~34세 청년으로 무주택 세대주이며 연소득 5천만원 이하인 경우 신청할 수 있습니다. 주택도시기금 홈페이지나 은행 영업점에서 신청하며, 보증금의 최대 80%까지, 최대 1억원까지 대출받을 수 있습니다.'
    },
    {
      question: '행복주택 입주 조건은?',
      answer: '대학생, 사회초년생, 신혼부부 등 청년층이 주 대상이며, 소득과 자산 기준을 충족해야 합니다. 시세의 60~80% 수준으로 임대되며, 최대 6년간 거주할 수 있습니다.'
    },
    {
      question: '주거급여는 어떻게 받나요?',
      answer: '기초생활보장 수급자 중 소득인정액이 기준 중위소득 47% 이하인 가구에 지급됩니다. 주민센터에 신청하면 임차 가구는 실제 임차료를, 자가 가구는 수선유지급여를 받을 수 있습니다.'
    }
  ],
  'education': [
    {
      question: '학자금 대출은 어떻게 신청하나요?',
      answer: '한국장학재단 홈페이지에서 온라인으로 신청할 수 있습니다. 재학생은 학기별로 신청하며, 취업 후 소득이 발생하면 상환하는 취업 후 상환 학자금 대출과 일반 상환 학자금 대출 중 선택할 수 있습니다.'
    },
    {
      question: '평생교육 바우처는 무엇인가요?',
      answer: '성인의 평생교육 참여 기회를 확대하기 위해 연간 35만원의 교육비를 지원하는 제도입니다. 기초생활수급자, 차상위계층, 기준 중위소득 65% 이하 가구원이 대상이며, 다양한 교육 프로그램을 수강할 수 있습니다.'
    },
    {
      question: '직업능력개발훈련은 어떻게 받나요?',
      answer: '고용센터나 HRD-Net에서 신청할 수 있으며, 훈련비 전액 또는 일부를 지원받을 수 있습니다. IT, 제조, 서비스 등 다양한 분야의 훈련 과정이 있으며, 훈련 중 생계비 지원도 받을 수 있습니다.'
    }
  ],
  'finance-welfare-culture': [
    {
      question: '청년내일저축계좌는 어떤 제도인가요?',
      answer: '일하는 청년이 매월 10만원 또는 15만원을 저축하면 정부가 같은 금액을 적립해주는 제도입니다. 3년 만기 시 최대 1,440만원의 목돈을 마련할 수 있으며, 근로소득이 있는 청년이 대상입니다.'
    },
    {
      question: '문화누리카드는 어떻게 발급받나요?',
      answer: '기초생활수급자와 차상위계층이 대상이며, 주민센터나 온라인으로 신청할 수 있습니다. 1인당 연간 13만원이 지원되며, 영화, 공연, 도서, 여행 등에 사용할 수 있습니다.'
    },
    {
      question: '청년 마음건강 지원은 어떻게 받나요?',
      answer: '만 19~34세 청년을 대상으로 정신건강 상담 및 치료비를 지원합니다. 정신건강복지센터나 청년센터에 문의하면 전문 상담과 치료 기관 연계를 받을 수 있으며, 비용의 일부를 지원받을 수 있습니다.'
    }
  ],
  'participation': [
    {
      question: '청년정책참여단은 무엇인가요?',
      answer: '청년 정책 수립 과정에 청년이 직접 참여하여 의견을 제시하고 모니터링하는 활동입니다. 참여 시 활동비가 지급되며, 정책 제안 및 평가, 캠페인 등 다양한 활동을 통해 청년의 목소리를 정책에 반영할 수 있습니다.'
    },
    {
      question: '청년활동지원금은 어떻게 받나요?',
      answer: '청년 단체 활동, 재능기부, 사회공헌 활동 등에 참여하면 활동비를 지원받을 수 있습니다. 지역 청년센터나 청년허브에서 모집하며, 활동 내용과 기간에 따라 지원금이 다릅니다.'
    },
    {
      question: '청년정책네트워크는 어떻게 참여하나요?',
      answer: '청년 정책에 관심 있는 청년이라면 누구나 참여할 수 있으며, 온라인과 오프라인으로 활동합니다. 정책 토론, 정책 제안, 네트워킹 등의 활동을 하며, 청년 정책 발전에 기여할 수 있습니다.'
    }
  ]
}

const qnaItems = computed(() => qnaData[category.value] || [])

// 데이터 로드
onMounted(async () => {
  try {
    loading.value = true

    // 카테고리 데이터 가져오기
    const categoryResult = await getCategoryBySlug(category.value)
    if (categoryResult) {
      categoryData.value = categoryResult
    }
  } catch (error) {
    console.error('데이터 로드 실패:', error)
    $q.notify({
      type: 'negative',
      message: '데이터를 불러오는데 실패했습니다.',
      position: 'top'
    })
  } finally {
    loading.value = false
  }
})

// Q&A 토글
const toggleQnA = (index) => {
  const idx = expandedItems.value.indexOf(index)
  if (idx > -1) {
    expandedItems.value.splice(idx, 1)
  } else {
    expandedItems.value.push(index)
  }
}

// 네비게이션
const handleBackToHome = () => {
  router.push('/')
}

const handleBackToCategory = () => {
  router.push({ name: 'category', params: { category: category.value } })
}

const viewPolicy = (policyId) => {
  router.push({
    name: 'policy-detail',
    params: {
      category: category.value,
      policyId: policyId
    }
  })
}
</script>

<style scoped>
* {
  box-sizing: border-box;
}

.container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 1rem;
  width: 100%;
  overflow-x: hidden;
}

.page-title {
  font-size: 1.5rem;
  font-weight: 700;
  line-height: 1.3;
  word-wrap: break-word;
  overflow-wrap: break-word;
  width: 100%;
}

@media (min-width: 640px) {
  .page-title {
    font-size: 1.875rem;
  }
}

.page-description {
  color: #6B7280;
  margin-top: 0.5rem;
  line-height: 1.5;
}

.main-layout {
  display: flex;
  gap: 0;
}

@media (min-width: 1024px) {
  .main-layout {
    gap: 4rem;
  }
}

.sidebar {
  width: 288px;
  min-height: 100vh;
  position: sticky;
  top: 0;
  margin-left: -1rem;
  padding-left: 1rem;
  padding-top: 2rem;
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
  background: none;
  border: none;
  cursor: pointer;
}

.sidebar-button:hover {
  background-color: #F3F4F6;
}

.main-content {
  flex: 1;
  width: 100%;
  min-width: 0;
}

@media (min-width: 1024px) {
  .main-content {
    padding-right: 0;
  }
}

.mobile-tabs {
  background-color: white;
  border-bottom: 1px solid #E5E7EB;
  overflow-x: auto;
  margin: 0 -1rem;
  padding: 0 1rem;
  margin-bottom: 2rem;
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

.content-area {
  padding: 2rem 0;
}

.qna-header-card {
  background-color: white;
  border-radius: 0.75rem;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  border: 1px solid #F3F4F6;
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.back-button {
  transition: color 0.2s;
}

.back-button:hover {
  color: #F97316 !important;
}

.qna-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.qna-item {
  background-color: white;
  border-radius: 0.75rem;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  border: 1px solid #F3F4F6;
  overflow: hidden;
}

.qna-question-button {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.5rem;
  text-align: left;
  background: none;
  border: none;
  cursor: pointer;
  transition: background-color 0.2s;
}

.qna-question-button:hover {
  background-color: #F9FAFB;
}

.qna-question-content {
  display: flex;
  align-items: flex-start;
  gap: 0.75rem;
  flex: 1;
  min-width: 0;
}

.qna-badge {
  background-color: #F97316;
  color: white;
  font-size: 0.875rem;
  font-weight: 700;
  padding: 0.25rem 0.75rem;
  border-radius: 9999px;
  flex-shrink: 0;
}

.qna-question-title {
  font-weight: 700;
  font-size: 1.125rem;
  color: #111827;
  margin: 0;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.qna-answer {
  padding: 1.5rem;
  padding-top: 0;
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
  background-color: #F9FAFB;
  border-top: 1px solid #E5E7EB;
}

.qna-answer-badge {
  background-color: #10B981;
  color: white;
  font-size: 0.875rem;
  font-weight: 700;
  padding: 0.25rem 0.625rem;
  border-radius: 9999px;
  flex-shrink: 0;
}

.qna-answer-content {
  flex: 1;
  color: #374151;
  line-height: 1.75;
  font-size: 0.9375rem;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

.qna-answer-enter-active {
  transition: all 0.3s ease-out;
}

.qna-answer-leave-active {
  transition: all 0.2s ease-in;
}

.qna-answer-enter-from {
  opacity: 0;
  max-height: 0;
}

.qna-answer-enter-to {
  opacity: 1;
  max-height: 500px;
}

.qna-answer-leave-from {
  opacity: 1;
  max-height: 500px;
}

.qna-answer-leave-to {
  opacity: 0;
  max-height: 0;
}
</style>
