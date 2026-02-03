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
      question: '2026년부터 청년에게 가장 크게 달라지는 일자리 정책은 무엇인가요?',
      answer: '\'청년 일자리 첫걸음 보장제\'가 새롭게 도입됩니다. 미취업 대학·고교 졸업자와 군 장병을 대상으로 고용보험 DB와 연계한 플랫폼을 통해 장기 미취업 위험군 약 15만 명을 선제적으로 발굴하고, 맞춤형 취업 지원을 제공합니다.'
    },
    {
      question: '취업 준비 중이면 정부에서 매달 받을 수 있는 돈이 있나요?',
      answer: '국민취업지원제도를 통해 구직촉진수당을 받을 수 있습니다. 2026년부터는 월 50만 원에서 월 60만 원으로 상향되며, 최대 6개월간 지급됩니다.'
    },
    {
      question: '비수도권 중소기업에 취업하면 실제로 얼마나 지원받나요?',
      answer: '비수도권 중소기업에 취업한 청년에게는 2년간 최대 720만 원의 근속 인센티브가 지급됩니다. 인구 감소 지역에 취업할 경우 우대 지원이 적용됩니다.'
    },
    {
      question: '취업을 안 하고 쉬고 있는 청년도 지원 대상이 되나요?',
      answer: '네. \'쉬는 청년\'도 주요 정책 대상입니다. 구직활동을 하지 않는 청년을 조기에 발굴해 상담, 일경험, 회복 프로그램 등을 단계적으로 지원합니다.'
    },
    {
      question: '자발적으로 퇴사한 경우에도 실업급여를 받을 수 있나요?',
      answer: '청년에 한해 생애 1회 자발적 이직자 구직급여 지급을 추진합니다. 다만 이는 확정 제도가 아닌 추진 과제로, 향후 제도화가 필요합니다.'
    },
    {
      question: 'AI 취업 지원 서비스는 실제로 무엇을 해주나요?',
      answer: 'AI가 개인의 역량, 이력, 취업 유형을 분석해 적합한 직무와 필요한 훈련 과정을 추천하는 맞춤형 고용서비스를 제공합니다.'
    },
    {
      question: '자격증 시험 비용도 정부 지원을 받을 수 있나요?',
      answer: '네. 국가기술자격 응시료의 50% 감면이 적용됩니다. 대상 종목은 기존 488개에서 540개 종목으로 확대됩니다.'
    },
    {
      question: '군 복무 중에도 취업 준비나 역량 개발이 가능한가요?',
      answer: '가능합니다. 군 복무 중에도 AI 온라인 교육을 받을 수 있으며, 대학 원격강좌 수강료 지원과 전자책(e-book) 구독 지원 제도가 운영됩니다.'
    },
    {
      question: '프리랜서나 플랫폼 노동자도 일자리 정책 보호를 받을 수 있나요?',
      answer: '네. 플랫폼 종사자와 프리랜서를 보호하기 위해 「일하는 사람 권리 기본법」 제정을 추진하고, AI 노동법 상담 서비스를 통해 권리 구제를 지원합니다.'
    },
    {
      question: '창업에 실패해도 다시 지원받을 수 있나요?',
      answer: '가능합니다. 폐업 경험이 있는 청년을 대상으로 청년 재도전 전용 트랙을 신설하여 실패 원인 분석, 사업모델 개선, 사업화 자금 패키지를 지원합니다.'
    }
  ],
  'housing': [
    {
      question: '2026년 주거 정책에서 가장 크게 달라진 점은 무엇인가요?',
      answer: '청년 주거 정책의 중심이 \'일시적 지원\'에서 상시적인 주거 안전망 구축으로 전환됩니다. 공공주택 공급 확대, 월세 지원의 계속사업화, 전세사기 예방 체계 강화가 동시에 추진됩니다.'
    },
    {
      question: '청년 공공주택 공급 규모가 이전보다 얼마나 늘어나나요?',
      answer: '2030년까지 청년을 위한 공공주택 40만 호 이상 공급이 추진됩니다. 이는 1차 기본계획보다 공급 규모와 정책 우선순위가 모두 확대된 것입니다.'
    },
    {
      question: '공공임대주택 신청 방식도 달라지나요?',
      answer: '네. 그동안 기관별로 나뉘어 있던 임대주택 정보를 \'대기자 통합 시스템(가칭)\'으로 일원화하여 청년이 여러 곳을 따로 신청하지 않아도 되도록 개선됩니다.'
    },
    {
      question: '청년도 실제로 공공분양 주택을 받을 수 있는 기회가 늘어나나요?',
      answer: '그렇습니다. 청년 대상 특별공급·우선공급 제도를 지속 운영하며, 단순 경쟁이 아닌 청년 전용 주거 사다리 구조를 강화합니다.'
    },
    {
      question: '공공분양 주택 유형이 왜 나눔형·선택형으로 나뉘나요?',
      answer: '청년의 자산 수준이 서로 다르기 때문입니다. 2026년부터는 소득·자산 상황에 맞춰 나눔형·선택형·일반형 공공분양 중 선택할 수 있도록 제도가 구조화됩니다.'
    },
    {
      question: '월세 지원은 앞으로도 계속 받을 수 있나요?',
      answer: '네. 청년월세지원은 한시 사업이 아니라 계속사업으로 전환되며, 중위소득 60% 이하였던 소득 요건도 단계적으로 완화될 예정입니다.'
    },
    {
      question: '대학생에게 새롭게 강화된 주거 지원은 무엇인가요?',
      answer: '원거리 대학에 진학한 저소득층 대학생에게 주거안정 장학금(월 최대 20만 원, 연 240만 원)이 지원됩니다. 월세·관리비 등 실제 주거비에 사용할 수 있습니다.'
    },
    {
      question: '전세사기 예방을 위해 새롭게 생기는 제도는 무엇인가요?',
      answer: '계약 전에 등기·권리관계를 분석해주는 안전계약 컨설팅 제도가 확대되며, 전세사기 피해 청년은 공공임대 우선 지원 등 보호 장치가 강화됩니다.'
    },
    {
      question: '반지하·쪽방 등에 거주하는 청년도 지원 대상인가요?',
      answer: '네. 최저 주거 기준을 상향하고, 열악한 환경에 거주하는 청년에게는 공공임대 우선 공급과 이주 비용 지원이 함께 추진됩니다.'
    },
    {
      question: '지방으로 취업하거나 이주하면 주거 지원이 달라지나요?',
      answer: '달라집니다. 지역활력타운·도심융합특구 등을 통해 주거·일자리·생활 인프라가 결합된 청년 정착형 주거 모델이 확대됩니다.'
    }
  ],
  'education': [
    {
      question: '2026년부터 교육 정책에서 가장 크게 달라지는 점은 무엇인가요?',
      answer: '앞으로 5년간 200만 명 이상의 청년에게 AI·디지털 실무 교육이 지원됩니다. 교육이 일부 전공자만의 기회가 아니라, 모든 청년에게 열려 있는 기본 성장 기회로 확대됩니다.'
    },
    {
      question: 'AI 교육은 전공자만 받을 수 있나요?',
      answer: '아닙니다. 학생·구직자·재직자 등 생애주기별로 맞춤형 AI 교육이 제공되어, 전공과 관계없이 참여할 수 있습니다.'
    },
    {
      question: '취업 준비 중인 청년도 AI 교육을 무료로 받을 수 있나요?',
      answer: '네. 구직 청년을 대상으로 온라인 AI 직무 교육과 실무 훈련 과정이 연계 제공됩니다. 온라인 학습 후 오프라인 직업훈련까지 이어질 수 있습니다.'
    },
    {
      question: '지역에 살아도 AI 교육을 받을 수 있나요?',
      answer: '가능합니다. 지역·소득·신분에 관계없이 누구나 참여할 수 있도록 온라인 중심 AI 교육 환경이 구축됩니다.'
    },
    {
      question: '군 복무 중에도 교육을 받을 수 있나요?',
      answer: '네. 군 장병 50만 명을 대상으로 AI·SW 온라인 교육이 확대되며, 일부 대학 원격강좌는 학점 인정도 가능합니다.'
    },
    {
      question: '실무 경험 중심 교육도 받을 수 있나요?',
      answer: '가능합니다. 기업과 함께 프로젝트를 수행하는 K-디지털 트레이닝 과정을 통해 AI·데이터 실무 역량을 키울 수 있습니다.'
    },
    {
      question: '재직 중인 청년도 교육 지원을 받을 수 있나요?',
      answer: '받을 수 있습니다. 중소기업 재직자를 대상으로 AI 특화 교육과 공동훈련센터가 운영되며, 5년간 10만 명 규모로 지원됩니다.'
    },
    {
      question: '이공계 대학원생에게는 어떤 지원이 강화되나요?',
      answer: '연구에 집중할 수 있도록 석사 월 80만 원, 박사 월 110만 원 수준의 연구생활장려금이 지원됩니다. 또한 장학금 대상 인원도 대폭 확대됩니다.'
    },
    {
      question: '전략산업(반도체·에너지·보안 등) 분야 교육도 지원되나요?',
      answer: '네. 에너지, 의료, 정보보안, AI 반도체 등 국가 전략산업 분야 인재를 14만 명 이상 양성할 계획입니다.'
    },
    {
      question: '학비나 생활비 부담을 줄일 수 있는 제도도 있나요?',
      answer: '있습니다. 국가장학금 지원 대상이 9구간까지 확대되며, 학자금 대출은 모든 재학생 신청 가능합니다. 평생교육이용권·K-MOOC 강좌도 확대됩니다.'
    }
  ],
  'finance-welfare-culture': [
    {
      question: '2026년 이후 청년 자산 형성 정책의 가장 큰 변화는 무엇인가요?',
      answer: '기존 청년도약계좌보다 혜택을 강화한 \'청년미래적금\'이 새로 도입됩니다. 납입 기간은 3년으로 단축되고, 정부 기여금은 최대 12%까지 확대됩니다.'
    },
    {
      question: '군 복무 중인 병사는 어떤 자산 지원을 받을 수 있나요?',
      answer: '병사가 월 최대 55만 원을 납입하면 정부가 100% 매칭해주며, 비과세 혜택까지 적용되는 장병 내일준비적금이 운영됩니다.'
    },
    {
      question: '군 간부도 자산 형성 지원을 받을 수 있나요?',
      answer: '네. 초급 간부가 장기 복무할 경우 월 최대 30만 원 납입액에 대해 정부가 100% 매칭하는 \'장기간부 도약적금\'이 지원됩니다.'
    },
    {
      question: '여러 자산 형성 상품을 동시에 활용할 수 있나요?',
      answer: '가능합니다. 청년미래적금, 내일저축계좌, 주택드림청약통장 등 자산형성 5종 세트를 연계하여 체계적인 자산 관리가 가능하도록 개선됩니다.'
    },
    {
      question: '취업하지 못한 청년도 금융 지원을 받을 수 있나요?',
      answer: '네. 미취업 청년과 고졸 취업준비생을 대상으로 햇살론 유스 금리 인하가 추진되어 학자금 대출 수준으로 이자 부담이 완화됩니다.'
    },
    {
      question: '빚 때문에 어려움을 겪는 청년을 위한 제도가 있나요?',
      answer: '있습니다. 청년 채무조정 특례를 통해 이자율 최대 70% 인하, 원금 감면 비율도 확대하여 금융 회복을 지원합니다.'
    },
    {
      question: '혼자 힘들어하는 고립·은둔 청년도 지원받을 수 있나요?',
      answer: '가능합니다. 전국에 청년미래센터를 단계적으로 확대하고, 학교·병원 종사자가 위기 청년을 발견하면 직권 신청도 가능해집니다.'
    },
    {
      question: '가족을 돌보는 청년에게는 어떤 지원이 있나요?',
      answer: '가족돌봄청년에게는 연 200만 원의 자기돌봄비가 지급되며, 의료·돌봄 서비스 비용 부담도 완화됩니다.'
    },
    {
      question: '청년 정신건강 지원은 어떻게 강화되나요?',
      answer: '정신건강 검진 주기가 2년으로 단축되고, AI 기반 상담 시스템을 통해 위험군은 전문 심리상담 바우처로 즉시 연계됩니다.'
    },
    {
      question: '문화·교통·생활비 부담을 줄일 수 있는 정책도 있나요?',
      answer: '있습니다. 청년 문화예술패스 확대, 월 5.5만 원 교통 무제한 K-패스 \'모두의 카드\' 도입, 국민연금 첫 보험료 지원 추진 등 청년의 필수 생활비 부담을 줄이는 정책이 함께 추진됩니다.'
    }
  ],
  'participation': [
    {
      question: '참여 정책에서 가장 크게 달라지는 점은 무엇인가요?',
      answer: '청년이 단순히 의견을 내는 수준을 넘어, 정책을 직접 제안하고 결정 과정에 참여하는 구조로 전환됩니다.'
    },
    {
      question: '청년도 실제로 정부 정책 결정 과정에 참여할 수 있나요?',
      answer: '가능합니다. 정부위원회 내 청년 위원 비율이 기존 10%에서 20% 이상으로 확대됩니다.'
    },
    {
      question: '청년이 정책을 직접 제안할 수 있는 공식 창구가 있나요?',
      answer: '있습니다. 청년정책조정위원회 내 6개 분과 전문위원회에 청년 60명이 참여하여 직접 사업을 제안하고 정책 수립 과정에 참여합니다.'
    },
    {
      question: '청년의 제안이 실제 정책으로 반영될 수 있는 구조가 마련되나요?',
      answer: '네. 국무총리 주재 청년정책 관계장관회의를 통해 부처 간 이견을 조정하고 청년 제안을 정책으로 신속히 반영하는 체계가 구축됩니다.'
    },
    {
      question: '온라인으로도 정책 참여가 가능한가요?',
      answer: '가능합니다. \'온통청년\' 플랫폼이 고도화되어 온라인 정책 투표와 실시간 피드백 기능이 신설됩니다.'
    },
    {
      question: '정책 참여 이력이 실제 혜택으로 이어질 수 있나요?',
      answer: '참여 활동을 마일리지로 적립하는 청년 참여 포인트제 도입이 검토되고 있습니다.'
    },
    {
      question: '지역에 사는 청년도 정책 참여가 가능한가요?',
      answer: '가능합니다. 지역 청년지원센터가 정책 허브 역할을 수행하고, 기초→광역→중앙으로 이어지는 상향식 제안 체계가 구축됩니다.'
    },
    {
      question: '청년친화도시는 어떤 제도인가요?',
      answer: '매년 3개 도시를 청년친화도시로 지정하여 청년 주거·일자리·문화 정책을 집중 지원하는 제도입니다.'
    },
    {
      question: '청년의 정책 참여를 장기적으로 지원할 조직도 생기나요?',
      answer: '네. 청년 참여 활동을 전담하는 한국청년정책진흥원 신설이 추진됩니다.'
    },
    {
      question: '해외 경험이나 글로벌 교류 기회도 확대되나요?',
      answer: '확대됩니다. 아태 청년교류단, CAMPUS Asia 공동 학위 등 글로벌 교류 프로그램이 체계적으로 확대됩니다.'
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
  align-items: center;
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
  display: flex;
  gap: 0.75rem;
  align-items: flex-start;
  background-color: #F9FAFB;
  border-top: 1px solid #E5E7EB;
  padding: 2rem 1.5rem 1.5rem 1.5rem;
  overflow: hidden;
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
  padding-top: 0;
  padding-bottom: 0;
}

.qna-answer-enter-to {
  opacity: 1;
  max-height: 500px;
  padding-top: 2rem;
  padding-bottom: 1.5rem;
}

.qna-answer-leave-from {
  opacity: 1;
  max-height: 500px;
  padding-top: 2rem;
  padding-bottom: 1.5rem;
}

.qna-answer-leave-to {
  opacity: 0;
  max-height: 0;
  padding-top: 0;
  padding-bottom: 0;
}
</style>
