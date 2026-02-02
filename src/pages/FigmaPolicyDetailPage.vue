<template>
  <div style="min-height: 100vh; background-color: white;">
    <FigmaHeader :current-category="categoryData?.name || null" />

    <div style="min-height: 100vh; background-color: white;">
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

      <!-- 메인 레이아웃 -->
      <div class="container">
        <div style="display: flex; gap: 4rem;">
          <!-- 사이드바 (데스크탑) -->
          <aside class="gt-md sidebar">
            <div style="background-color: white; border: 1px solid #E5E7EB; border-radius: 1rem; box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05); padding: 1rem;">
              <h3 style="font-size: 1.125rem; font-weight: 700; color: #111827; margin-bottom: 1rem; padding: 0 0.75rem; white-space: nowrap;">세부 정책</h3>
              <nav style="display: flex; flex-direction: column; gap: 0.25rem;">
                <button
                  v-for="subPolicy in subPolicies"
                  :key="subPolicy.id"
                  :class="['sidebar-button', { 'active': subPolicy.id === parseInt(policyId) }]"
                  @click="navigateToPolicy(subPolicy.id)"
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
                  :class="['mobile-tab-button', { 'active': subPolicy.id === parseInt(policyId) }]"
                  @click="navigateToPolicy(subPolicy.id)"
                >
                  <q-icon :name="subPolicy.icon" size="24px" />
                  <span style="font-size: 0.75rem; text-align: center; line-height: 1.25;">정책{{ index + 1 }}</span>
                </button>
              </div>
            </div>

            <!-- 콘텐츠 영역 -->
            <div class="content-area">
              <div class="policy-detail-sections">
                <!-- 정책 헤더 카드 -->
                <div class="policy-header-card">
                  <div class="policy-header-grid">
                    <div class="policy-header-content">
                      <div style="display: flex; align-items: center; gap: 0.75rem; margin-bottom: 0.5rem;">
                        <div class="policy-icon-wrapper">
                          <q-icon :name="currentPolicy.icon" size="20px" style="color: #374151;" />
                        </div>
                        <div>
                          <p style="font-size: 0.75rem; color: #6B7280; margin-bottom: 0.25rem;">정책 {{ currentPolicy.id }}</p>
                          <h2 class="policy-header-title">{{ currentPolicy.title }}</h2>
                        </div>
                      </div>
                      <p class="policy-header-description">{{ currentPolicy.description }}</p>
                    </div>
                    <div class="policy-header-image">
                      <img
                        :src="currentPolicy.image || 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800'"
                        :alt="currentPolicy.title"
                        style="width: 100%; height: 100%; object-fit: cover; border-radius: 0.5rem;"
                      />
                    </div>
                  </div>
                </div>

                <!-- 알림 서비스 안내 -->
                <div class="notification-banner">
                  <div class="notification-icon-wrapper">
                    <q-icon name="notifications" size="20px" style="color: #F97316;" />
                  </div>
                  <div style="flex: 1;">
                    <h4 style="font-weight: 600; color: #111827; margin-bottom: 0.375rem;">관심 정책 알림 서비스</h4>
                    <p style="font-size: 0.875rem; color: #374151; line-height: 1.5;">저장 버튼을 클릭하여 관심 있는 세부 정책을 등록하면, 해당 정책의 접수 시작일과 중요한 변경사항을 알림으로 받아보실 수 있습니다.</p>
                  </div>
                </div>

                <!-- 세부 내용 카드들 -->
                <div class="detail-cards-container">
                  <div
                    v-for="detail in currentPolicy.details"
                    :key="detail.id"
                    class="detail-card"
                  >
                    <div class="detail-card-content">
                      <h3 class="detail-card-title">{{ detail.title }}</h3>
                      <p class="detail-card-description">{{ detail.description }}</p>
                    </div>
                    <button
                      class="bookmark-button"
                      :class="{ 'saved': detail.saved }"
                      @click="toggleBookmark(detail.id)"
                      :aria-label="detail.saved ? '관심 정책에서 제거' : '관심 정책으로 저장'"
                      :title="detail.saved ? '관심 정책에서 제거' : '관심 정책으로 저장하고 알림 받기'"
                    >
                      <q-icon :name="detail.saved ? 'bookmark' : 'bookmark_border'" size="20px" />
                    </button>
                  </div>
                </div>

                <!-- 목록으로 돌아가기 버튼 -->
                <div class="back-button-wrapper">
                  <q-btn
                    outline
                    label="목록으로 돌아가기"
                    @click="handleBackToList"
                    no-caps
                    class="back-to-list-button"
                  />
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

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useQuasar } from 'quasar'
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
import { useCategories } from '../composables/useCategories'

const route = useRoute()
const router = useRouter()
const $q = useQuasar()

const { getCategoryBySlug } = useCategories()

const category = computed(() => route.params.category as string)
const policyId = computed(() => route.params.policyId as string)
const categoryData = ref<any>(null)

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
      { id: 1, title: '청년 공공주택 공급 확대 및 제도 내실화', icon: 'apartment', description: '청년층을 위한 공적 주택을 2030년까지 40만 호 이상 공급하며, 수도권 도심 요지의 노후 청사와 유휴 국·공유지를 활용하여 청년들의 주거 안정을 실현합니다.' },
      { id: 2, title: '청년 특화·기숙사형 주택', icon: 'apartment_complex', description: '공유 오피스, 피트니스 센터 등 청년들이 선호하는 생활 서비스와 임대주택이 결합된 특화 주택을 공급하여 주거와 생활 편의를 동시에 보장합니다.' },
      { id: 3, title: '대학 기숙사 확충 및 청년친화 시설 개선', icon: 'school', description: '국립대 BTL 기숙사와 연합기숙사를 확충하고, 노후 기숙사의 개축 및 리모델링을 통해 청년친화적 주거 환경을 조성합니다.' },
      { id: 4, title: '지역 일자리 연계 청년 주거 모델 확산', icon: 'location_city', description: '지방 이전 청년들의 정착을 돕기 위해 주거 공간과 생활 인프라, 일자리가 유기적으로 결합된 복합 주거 모델을 확산합니다.' },
      { id: 5, title: '청년 주거비 및 금융 지원 확대', icon: 'account_balance_wallet', description: '무주택·저소득 청년을 대상으로 월세 지원과 주거안정 장학금을 제공하며, 우대 금리 청약통장과 저리 대출로 주거비 부담을 경감합니다.' },
      { id: 6, title: '청년 주거 안정망 및 상담·지원 체계 강화', icon: 'support_agent', description: '전세사기 예방과 불법 주거 감독을 강화하고, 취약 청년의 주거 환경 개선과 함께 찾아가는 주거 상담 서비스를 제공합니다.' }
    ],
    'education': [
      { id: 1, title: 'AI·SW 역량 강화 및 교육 확산', icon: 'computer', description: '학생, 구직자, 재직자의 생애주기별 맞춤형 교육훈련 체계를 AI와 SW 중심으로 전면 개편하여 향후 5년간 200만 명에게 역량 개발을 지원합니다.' },
      { id: 2, title: '온라인 AI 교육 확대 및 청년 주도 AX', icon: 'online_prediction', description: 'STEP 및 국방 AI 교육플랫폼을 연계한 통합 온라인 AI 교육센터를 운영하여 전 국민의 AI 접근성을 제고하고, 청년 주도의 AI 멘토링으로 지역 교육 격차를 해소합니다.' },
      { id: 3, title: '실무 역량 강화 및 맞춤형 인재 양성', icon: 'psychology', description: '프로젝트 기반의 K-디지털 트레이닝과 고급 AI 인재 양성 과정을 통해 연간 5만 명 규모의 AI·빅데이터 실무 인재를 양성하고, 중소기업 재직자의 AI 역량을 강화합니다.' },
      { id: 4, title: '청년 과학기술인 성장 지원', icon: 'science', description: '이공계 장학금 지원을 단계적으로 확대하고, 대학원생 연구생활장려금과 박사후연구원 제도 개선을 통해 청년 과학기술인의 안정적인 연구 환경을 조성합니다.' },
      { id: 5, title: '전략산업 전문 청년 인재 양성', icon: 'precision_manufacturing', description: '에너지, 건축, 의료·의약품, 정보보안 등 국가 전략산업 분야의 맞춤형 전문인재를 2030년까지 14만 명 이상 양성하고, 석·박사급 고급 인재 육성 체계를 구축합니다.' },
      { id: 6, title: '교육-일자리 연계 및 교육 격차 해소', icon: 'connect_without_contact', description: '대학과 기업이 공동으로 운영하는 계약학과를 확대하고, 직업교육 연계 경로를 다양화하며, 국가장학금 지원 대상 확대로 교육 격차를 해소합니다.' }
    ],
    'finance-welfare-culture': [
      { id: 1, title: '청년 초기 자산 형성 지원 강화', icon: 'savings', description: '청년미래적금, 장병내일준비적금 등 다양한 자산형성 지원 제도를 통해 청년들의 초기 자산 형성을 돕고, 5종 세트 연계로 체계적인 자산 관리를 지원합니다.' },
      { id: 2, title: '금융 안전망 구축 및 경제 역량 강화', icon: 'account_balance', description: '햇살론 유스 금리 인하와 채무조정 특례 확대로 금융 부담을 경감하고, 맞춤형 재무 진단과 체험형 교육으로 청년들의 금융 역량을 강화합니다.' },
      { id: 3, title: '고립·은둔 및 가족돌봄 청년 집중 케어', icon: 'volunteer_activism', description: '위기청년 전담 지원 기관인 청년미래센터를 확대하고, 고립·은둔 청년과 가족돌봄 청년을 위한 맞춤형 회복 지원과 자기돌봄비를 제공합니다.' },
      { id: 4, title: '자립 기반 강화 및 복지 사각지대 해소', icon: 'support', description: '자립준비청년 수당과 정착금을 확대하고, 저소득 한부모, 경계선 지능, 장애·이주 청년 등 복지 사각지대에 있는 청년들을 위한 맞춤형 지원을 강화합니다.' },
      { id: 5, title: '마음·신체 건강 통합 관리', icon: 'health_and_safety', description: '정신건강 검진 주기를 단축하고 AI 시스템을 도입하여 마음 건강 문제를 조기에 발견하며, 맞춤형 운동·식단 관리와 식생활 지원으로 신체 건강을 증진합니다.' },
      { id: 6, title: '문화 향유 확대 및 필수 생활비 경감', icon: 'theater_comedy', description: '청년 문화예술 패스를 확대하고 K-패스로 교통비를 절감하며, 문화 콘텐츠 창작 인재를 양성하고 국민연금 첫 보험료 지원 등으로 청년의 필수 생활비를 경감합니다.' }
    ],
    'participation': [
      { id: 1, title: '청년의 국정 참여 확대 및 소통 강화', icon: 'forum', description: '대통령, 국무총리, 대통령비서실장 주재 소통 채널을 통해 청년들이 정기적으로 국정 이슈를 토론하고 정책 방향을 함께 고민하는 실질적인 파트너십을 구축합니다.' },
      { id: 2, title: '정책 결정 권한 강화 및 거버넌스 확립', icon: 'how_to_vote', description: '정부위원회 청년 위원 비율을 20%로 상향하고, 청년정책조정위원회 전문위원회 설치와 청년보좌역 제도 내실화를 통해 청년의 정책 결정 권한을 강화합니다.' },
      { id: 3, title: '디지털 기반 참여 플랫폼 고도화', icon: 'devices', description: 'AI·빅데이터 기반 온통청년 플랫폼을 고도화하고, 온라인 정책 투표 및 피드백 기능을 신설하여 청년들이 상시적으로 정책에 참여할 수 있는 환경을 조성합니다.' },
      { id: 4, title: '지역 중심 청년 생태계 조성', icon: 'location_city', description: '지역 청년지원센터를 허브 기관으로 강화하고, 청년정책실험실과 청년친화도시 지정을 통해 지역 중심의 청년 생태계를 조성합니다.' },
      { id: 5, title: '지속가능한 지원 인프라 및 법령 정비', icon: 'policy', description: '청년 연령 기준을 34세로 상향하고, 청년인재 데이터베이스를 구축하며, 한국청년정책진흥원 신설을 통해 지속 가능한 청년 지원 인프라를 마련합니다.' },
      { id: 6, title: '글로벌 교류 확대 및 상생 문화 확산', icon: 'public', description: '아태 청년교류단 설치와 CAMPUS Asia 공동 학위 운영을 통해 글로벌 교류를 확대하고, 젠더 갈등 해소 공론장 운영으로 상생 문화를 확산합니다.' }
    ]
  }

  return policyMap[category.value] || []
})

// 정책별 상세 내용
const policyDetails = computed(() => {
  const detailsMap: Record<string, Record<number, any>> = {
    'housing': {
      1: {
        details: [
          { id: 1, title: '공공주택 공급 대폭 확대', description: '청년층을 위한 공적 주택을 2030년까지 40만 호 이상 공급하며, 수도 도심 요지의 노후 청사와 유휴 국·공유지 등을 활용한 주택 공급을 추진합니다.', saved: false },
          { id: 2, title: '청년 특별·우선공급 지속 운영', description: '청년들이 내 집 마련의 꿈을 이룰 수 있도록 공공분양 주택에서 청년 대상 특별공급과 우선공급 제도를 지속적으로 운영하여 안정적인 주거 사다리를 제공합니다.', saved: false },
          { id: 3, title: '부담 가능한 수준의 공공분양 주택 확대', description: '청년의 자산 수준에 따라 선택할 수 있는 나눔형, 선택형, 일반형 등 다양한 유형의 공공분양 주택을 공급하여 주거 진입 장벽을 낮춥니다.', saved: false },
          { id: 4, title: '공공임대 시스템 일원화 추진', description: '사업자별로 분산되어 운영되던 공공임대 시스템을 가칭 \'대기자 통합 시스템\'으로 일원화하여 청년들이 임대주택 정보를 한곳에서 확인하고 편리하게 신청할 수 있도록 개선합니다.', saved: false }
        ]
      },
      2: {
        details: [
          { id: 1, title: '청년특화주택 공급 확대', description: '공유 오피스, 피트니스 센터 등 청년들이 선호하는 생활 서비스와 임대주택이 결합된 청년 특화 주택 공급을 늘려 주거와 생활 편의를 동시에 보장합니다.', saved: false },
          { id: 2, title: '기숙사형 청년주택 공급', description: '대학생 수요가 많은 지역의 소형 주택을 정부가 임차하여 청년들에게 시세보다 훨씬 저렴한 보증금과 월세로 재임대하는 기숙사형 주택을 지속적으로 제공합니다.', saved: false }
        ]
      },
      3: {
        details: [
          { id: 1, title: '기숙사 확충(BTL, 연합기숙사)', description: '국립대 BTL 기숙사와 여러 대학의 학생이 공동으로 이용할 수 있는 연합기숙사를 수도권 등 기숙사 수요가 높은 지역을 중심으로 지속적으로 확충합니다.', saved: false },
          { id: 2, title: '청년친화 시설 개선', description: '노후된 기숙사의 개축 및 리모델링을 추진하고, 기존 다인실을 1~2인실로 전환하여 1인당 기준 면적을 확대하는 등 기숙사 내 정주 여건을 대폭 개선합니다.', saved: false }
        ]
      },
      4: {
        details: [
          { id: 1, title: '지역활력타운 조성', description: '지방 이전 청년들의 정착을 돕기 위해 관계부처가 협력하여 주거 공간과 생활 인프라, 생활 서비스가 유기적으로 결합된 복합 주거 단지를 조성합니다.', saved: false },
          { id: 2, title: '주거, 일자리 연계 모델 구축', description: '지방 산업단지 근로자나 지역 전략 산업에 종사하는 청년들을 위해 직장 인근에 주거 시설과 일자리 지원 시설을 복합적으로 제공하는 모델을 확산합니다.', saved: false },
          { id: 3, title: '도심융합특구 조성', description: '지방 광역시에 기업 지원 공간과 청년들이 선호하는 양질의 문화·주거 시설을 도심에 종합적으로 제공하여 지역 발전과 청년 정착을 동시에 도모합니다.', saved: false },
          { id: 4, title: '지역 성장 거점 역할 강화', description: '지방 광역시에 산업, 주거, 문화가 어우러진 도심융합특구를 조성하여 지역의 청년 인들이 정착하고 성장할 수 있는 핵심 거점으로 육성합니다.', saved: false }
        ]
      },
      5: {
        details: [
          { id: 1, title: '청년월세지원', description: '무주택·저소득 청년을 대상으로 한 월세 지원 사업을 계속사업으로 전환하고, 중위소득 60% 이하인 소득 요건을 단계적으로 완화하여 수혜 대상을 확대합니다.', saved: false },
          { id: 2, title: '주거안정 장학금', description: '원거리 대학에 진학한 저소득층 대학생을 대상으로 관리비와 월세 등 주거 비용을 월 최대 20만 원(연간 240만 원)까지 지원하는 장학금을 지급합니다.', saved: false },
          { id: 3, title: '청년주거 금융 지원', description: '우대 금리가 적용되는 청년주택드림 청약통장과 저리 대출을 제공하며, 무주택 청년을 위한 전용 버팀목 전세자금 대출 지원을 통해 자금 마련 부담을 덜어줍니다.', saved: false }
        ]
      },
      6: {
        details: [
          { id: 1, title: '전세사기 예방 및 피해지원', description: '계약 전 권리관계를 분석해주는 안전계약 컨설팅을 제공하고, 전세사기 피해자 구제를 위해 공공임대 지원 대상을 확대하는 등 특별법 개정을 추진합니다.', saved: false },
          { id: 2, title: '불법 주거 감독 강화', description: '부동산 특별사법경찰을 통해 대학 역세권 등의 불법 용도 변경이나 무단 대수선(방 쪼개기) 등에 대한 점검과 관리·감독을 강화합니다.', saved: false },
          { id: 3, title: '취약 청년 주거 환경 개선', description: '반지하, 쪽방 등 열악한 환경에 거주하는 청년에게 공공임대주택 우선 공급과 이주 비용을 지원하며, 최저 주거 기준을 상향 조정하여 정주 여건을 개선합니다.', saved: false },
          { id: 4, title: '주거 상담 및 정보 제공 강화', description: '찾아가는 주거 상담 서비스를 통해 부동산 계약 및 예방 정보를 전달하고, 마이홈 포털을 고도화하여 AI 기반의 맞춤형 주거 정책 정보를 제공합니다.', saved: false }
        ]
      }
    },
    'job': {
      1: {
        details: [
          { id: 1, title: '민·관 협업 채용 확대', description: '청년 일자리 창출을 유도하기 위해 신규 채용 기업에 재정, 세제, 포상 등 전방위적인 인센티브를 제공합니다. 특히 청년의 장기 고용을 유도하기 위해 고용 기간이 길어질수록 세제 혜택이 커지는 \'공제액 점증 구조\'로 제도를 개편합니다.', saved: false },
          { id: 2, title: '국가 R&D 기업 우대', description: '국가 연구개발(R&D) 과제를 수행하는 기업이 청년을 채용할 경우 선정 과정에서 가점을 부여하거나 고용을 우대하는 방안을 검토하여 연구 분야의 청년 일자리 기반을 넓힙니다.', saved: false },
          { id: 3, title: '선제적 패키지 지원', description: '졸업 예정자나 졸업 직후의 미취업 청년이 구직에 어려움을 겪지 않도록 상담부터 교육, 일경험, 최종 취업까지 전 과정을 하나로 묶어 지원하는 통합 패키지를 시행합니다.', saved: false },
          { id: 4, title: 'AI 고용 서비스', description: 'AI가 개인의 역량을 정밀하게 분석하여 성공 확률이 높은 직무를 추천하고, 필요한 훈련 프로그램까지 1:1로 매칭해주는 지능형 취업 지원 서비스를 제공합니다.', saved: false },
          { id: 5, title: '자격증 취득 지원', description: '구직 비용 부담을 덜어주기 위해 국가기술자격 응시료 50% 감면 대상을 기존 488개에서 대한상공회의소 등 10개 기관 소관 540개 종목으로 대폭 확대합니다.', saved: false }
        ]
      },
      2: {
        details: [
          { id: 1, title: '\'쉬는 청년\' 맞춤 케어', description: '\'청년 일자리 첫걸음 플랫폼\'을 구축하여 고용보험 데이터베이스와 연계합니다. 이를 통해 장기 미취업 위험군 약 15만 명을 선제적으로 발굴하고 개인별 위험도에 따른 맞춤형 복귀 프로그램을 제공합니다.', saved: false },
          { id: 2, title: '청년도전지원사업', description: '구직 단념 청년들에게 밀착 상담과 역량 강화 프로그램을 제공하며, 참여 정도에 따라 50만 원에서 최대 250만 원의 참여 수당을 지급하여 사회 진입 의욕을 높입니다.', saved: false },
          { id: 3, title: '구직촉진수당 상향', description: '구직 기간 중의 경제적 부담을 완화하기 위해 국민취업지원제도의 구직촉진수당을 기존 월 50만 원에서 월 60만 원으로 상향하여 최대 6개월간 지원합니다.', saved: false },
          { id: 4, title: '청년 구직급여 추진', description: '자발적으로 이직한 청년이라도 새로운 도전을 준비할 수 있도록 생애 1회에 한해 구직급여를 지급하는 방안을 추진합니다.', saved: false },
          { id: 5, title: '청년 갭이어(Gap-year)', description: '청년들이 학업이나 일을 잠시 멈추고 진로를 진지하게 탐색하거나 회복할 수 있도록 지역 청년센터와 연계한 갭이어 지원 방안을 마련합니다.', saved: false },
          { id: 6, title: '재도전 지원', description: '취업 실패를 경험한 청년들이 다시 일어설 수 있도록 지역청년지원센터에서 상담과 분석을 거쳐 개인 맞춤형 재도전 계획을 수립하고 관련 사업을 연계해 드립니다.', saved: false }
        ]
      },
      3: {
        details: [
          { id: 1, title: '일경험(인턴) 기회 확대', description: '현대차, LG 등 주요 기업 및 스타트업과 협력하여 대규모 민간 인턴십 기회를 제공합니다. 정부 부처와 공공기관에서도 정책 참여형 일경험 제도를 운영하며, 특히 공공기관 블라인드 채용의 전면 도입을 검토하여 공정한 기회를 보장합니다.', saved: false },
          { id: 2, title: '첨단산업 특화 교육', description: 'AI 및 AX(AI 전환) 분야 실무 인재 1만 명을 집중 양성하고, \'이어드림스쿨\'을 통해 혁신 벤처와 스타트업 취업까지 밀착 연계합니다.', saved: false },
          { id: 3, title: '군 복무 중 역량 개발', description: '전체 장병 50만 명을 대상으로 AI 온라인 교육을 시행하며, 복무 중 대학 강좌 수강료 지원과 함께 전자책 구독 지원 서비스를 신설하여 중단 없는 자기계발을 지원합니다.', saved: false }
        ]
      },
      4: {
        details: [
          { id: 1, title: '청년일자리도약장려금 확대', description: '비수도권 중소기업에 취업한 청년들의 장기 근속을 지원하기 위해 2년간 최대 720만 원의 인센티브를 우대 지급합니다.', saved: false },
          { id: 2, title: '지역 맞춤형 지원', description: '지자체와 협업하여 해당 지역의 전략 산업과 연계한 교육, 일자리 제공, 주거 지원을 원스톱 통합 프로그램으로 운영합니다.', saved: false },
          { id: 3, title: '지역 인재 양성(RISE)', description: '지역혁신중심 대학지원체계(RISE)를 가동하여 지역 대학과 지자체, 산업계가 원팀으로 지역 전략 산업에 필요한 전문 인재를 양성하고 취업까지 연계합니다.', saved: false },
          { id: 4, title: '농·어업 도전 지원', description: '청년 농업인에게는 3년간 월 90~110만 원의 영농정착지원금을 지급하고 맞춤형 농지와 농촌 보금자리 주택을 공급합니다. 청년 어업인을 위해서는 \'청년 바다마을\' 조성과 함께 어선 임차료 지원 및 스마트 양식 창업 지원을 대폭 강화합니다.', saved: false }
        ]
      },
      5: {
        details: [
          { id: 1, title: 'AI 노동법 도우미', description: '24시간 언제 어디서나 맞춤형 상담이 가능한 AI 노동법 시스템을 운영하여 임금 체불이나 부당 대우에 대한 권리 구제를 지원합니다. 소규모 사업장도 AI를 통해 노동법 준수 여부를 스스로 점검할 수 있도록 돕습니다.', saved: false },
          { id: 2, title: '플랫폼·프리랜서 보호', description: '플랫폼 종사자와 프리랜서 청년들의 공정 계약과 건강한 작업 환경을 보장하기 위해 「일하는 사람 권리 기본법」 제정을 추진하고, 법적 보호 사각지대를 해소합니다.', saved: false },
          { id: 3, title: '경력 인증 및 복지', description: '단기 근로와 프리랜서 경험도 직무 역량으로 활용할 수 있도록 경력 인증 시스템을 구축합니다. 또한 중소기업 재직 청년을 위한 복지카드 시범 사업과 노후 산단지 내 청년친화 편의시설 확충을 위한 바우처 지원을 실시합니다.', saved: false }
        ]
      },
      6: {
        details: [
          { id: 1, title: '혁신 창업가 육성', description: '청년창업사관학교와 딥테크 창업중심대학을 통해 AI, 바이오헬스 등 신기술 분야의 창업가를 집중 양성합니다. \'모두의 창업 프로젝트\'를 통해 배경 지식이 없어도 혁신적인 아이디어만 있다면 누구나 창업에 도전할 수 있는 환경을 만듭니다.', saved: false },
          { id: 2, title: '분야별 특화 창업', description: '전통문화, 게임, 미디어, 기후·환경, 스마트건설 등 부처별 전문 분야에 특화된 창업 지원 프로그램을 운영하여 산업 전반의 창업 저변을 확대합니다.', saved: false },
          { id: 3, title: '자금 및 투자 지원', description: '7,000억 원 규모의 혁신창업펀드를 추가 조성하고, 기업당 최대 1억 원의 청년전용창업자금을 융자 지원합니다. 또한 청년 창업 제품의 공공기관 우선구매 제도를 신설하여 초기 판로 확보를 돕습니다.', saved: false },
          { id: 4, title: '창업 안전망 및 재도전', description: '실패 경험을 자산으로 삼을 수 있도록 \'청년 재도전 지원 전용 트랙\'을 신설하고 사업화 자금을 패키지로 지원합니다. 폐업 후 재창업을 준비하는 예비 창업자에게는 지원 사업 기회를 추가로 허용하며, 중장년과의 공동 창업 지원도 확대합니다.', saved: false }
        ]
      }
    }
  }

  return detailsMap[category.value]?.[parseInt(policyId.value)] || { details: [] }
})

// 현재 선택된 정책
const currentPolicy = computed(() => {
  const policy = subPolicies.value.find(p => p.id === parseInt(policyId.value))

  // 카테고리별 이미지 경로 매핑
  const imageMap: Record<string, Record<number, string>> = {
    'job': {
      1: '/images/policies/job/policy-1.png',
      2: '/images/policies/job/policy-2.png',
      3: '/images/policies/job/policy-3.png',
      4: '/images/policies/job/policy-4.png',
      5: '/images/policies/job/policy-5.png',
      6: '/images/policies/job/policy-6.png'
    },
    'housing': {
      1: '/images/policies/housing/policy-1.png',
      2: '/images/policies/housing/policy-2.png',
      3: '/images/policies/housing/policy-3.png',
      4: '/images/policies/housing/policy-4.png',
      5: '/images/policies/housing/policy-5.png',
      6: '/images/policies/housing/policy-6.png'
    }
  }

  const image = imageMap[category.value]?.[parseInt(policyId.value)] || 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800'

  return {
    ...policy,
    ...policyDetails.value,
    image
  }
})

// 카테고리 데이터 가져오기
const loadCategoryData = async () => {
  try {
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
  } catch (error: any) {
    console.error('카테고리 데이터 로딩 에러:', error)
    $q.notify({
      type: 'negative',
      message: '데이터를 불러오는 중 오류가 발생했습니다.',
      position: 'top'
    })
  }
}

onMounted(() => {
  loadCategoryData()
})

const handleBack = () => {
  router.push('/')
}

const handleBackToList = () => {
  router.push({
    name: 'category',
    params: {
      category: category.value
    }
  })
}

const navigateToPolicy = (id: number) => {
  router.push({
    name: 'policy-detail',
    params: {
      category: category.value,
      policyId: id.toString()
    }
  })
}

const toggleBookmark = (detailId: number) => {
  const detail = currentPolicy.value.details?.find((d: any) => d.id === detailId)
  if (detail) {
    detail.saved = !detail.saved
    $q.notify({
      type: detail.saved ? 'positive' : 'info',
      message: detail.saved ? '관심 정책으로 저장되었습니다.' : '관심 정책에서 제거되었습니다.',
      position: 'top'
    })
  }
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

/* 콘텐츠 영역 */
.content-area {
  padding-top: 2rem;
  padding-bottom: 2rem;
}

/* 사이드바 */
.sidebar {
  width: 18rem;
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
  background-color: transparent;
  border: none;
  cursor: pointer;
}

.sidebar-button:hover {
  background-color: #F3F4F6;
}

.sidebar-button.active {
  background-color: #F97316;
  color: white;
}

/* 모바일 탭 */
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

.mobile-tab-button.active {
  background-color: #F97316;
  color: white;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

/* 정책 상세 섹션 */
.policy-detail-sections {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

/* 정책 헤더 카드 */
.policy-header-card {
  background-color: white;
  border-radius: 1.5rem;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  border: 1px solid #F3F4F6;
  overflow: hidden;
}

.policy-header-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
}

@media (min-width: 768px) {
  .policy-header-grid {
    grid-template-columns: 1fr 1fr;
    gap: 2rem;
  }
}

.policy-header-content {
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

@media (min-width: 768px) {
  .policy-header-content {
    padding: 2rem;
  }
}

.policy-icon-wrapper {
  background-color: white;
  border: 1px solid #E5E7EB;
  padding: 0.5rem;
  border-radius: 0.5rem;
  flex-shrink: 0;
}

.policy-header-title {
  font-size: 1.125rem;
  font-weight: 700;
  line-height: 1.3;
}

@media (min-width: 768px) {
  .policy-header-title {
    font-size: 1.25rem;
  }
}

@media (min-width: 1024px) {
  .policy-header-title {
    font-size: 1.5rem;
  }
}

.policy-header-description {
  font-size: 1.125rem;
  line-height: 1.6;
  color: #374151;
}

.policy-header-image {
  position: relative;
  height: 16rem;
}

@media (min-width: 768px) {
  .policy-header-image {
    height: 20rem;
  }
}

/* 알림 배너 */
.notification-banner {
  background: linear-gradient(to right, #FFF7ED, rgba(167, 232, 189, 0.2));
  border: 1px solid #FED7AA;
  border-radius: 1.5rem;
  padding: 1.25rem;
  display: flex;
  align-items: flex-start;
  gap: 1rem;
}

.notification-icon-wrapper {
  background-color: white;
  border-radius: 9999px;
  padding: 0.5rem;
  margin-top: 0.125rem;
  flex-shrink: 0;
}

/* 상세 내용 카드 */
.detail-cards-container {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.detail-card {
  background-color: white;
  border: 1px solid #E5E7EB;
  border-radius: 0.5rem;
  padding: 1.25rem;
  transition: box-shadow 0.2s;
  position: relative;
  display: block;
}

.detail-card:hover {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.detail-card-content {
  padding-right: 3rem;
}

.detail-card-title {
  font-weight: 700;
  font-size: 1.125rem;
  color: #111827;
  margin-bottom: 0.75rem;
}

.detail-card-description {
  color: #374151;
  line-height: 1.6;
  margin: 0;
}

.bookmark-button {
  position: absolute;
  top: 1.25rem;
  right: 1.25rem;
  padding: 0.625rem;
  border-radius: 0.5rem;
  transition: all 0.2s;
  background-color: transparent;
  border: none;
  cursor: pointer;
  color: #9CA3AF;
  display: flex;
  align-items: center;
  justify-content: center;
}

.bookmark-button:hover {
  background-color: #F3F4F6;
}

.bookmark-button.saved {
  color: #F97316;
}

/* 목록으로 돌아가기 버튼 */
.back-button-wrapper {
  background-color: white;
  border-radius: 1.5rem;
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  border: 1px solid #F3F4F6;
  padding: 1.5rem;
}

.back-to-list-button {
  width: 100%;
  border: 1px solid #E5E7EB;
  color: #374151;
  font-weight: 500;
  background-color: white;
}

.back-to-list-button:hover {
  background-color: #F9FAFB;
}
</style>
