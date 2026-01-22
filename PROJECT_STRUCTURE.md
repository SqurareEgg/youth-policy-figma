# 프로젝트 구조 문서

> 청년있슈 프로토타입 - 상세 구조 및 아키텍처 가이드

**작성일**: 2026-01-22
**버전**: 1.0.0

---

## 목차

1. [전체 디렉토리 구조](#전체-디렉토리-구조)
2. [컴포넌트 의존성 다이어그램](#컴포넌트-의존성-다이어그램)
3. [라우팅 구조](#라우팅-구조)
4. [데이터 흐름](#데이터-흐름)
5. [파일별 상세 설명](#파일별-상세-설명)

---

## 전체 디렉토리 구조

```
YouthV2-Figma/
├── .git/                          # Git 저장소
├── .gitignore                     # Git 제외 파일
├── node_modules/                  # NPM 의존성 (464 packages)
├── dist/                          # 빌드 결과물 (빌드 후 생성)
│
├── index.html                     # HTML 진입점
├── package.json                   # 프로젝트 메타데이터 및 의존성
├── quasar.config.js               # Quasar 프레임워크 설정
│
├── public/                        # 정적 파일 (있으면 dist로 복사)
│
├── src/                           # 소스 코드
│   ├── App.vue                    # 루트 Vue 컴포넌트
│   │
│   ├── assets/                    # 정적 리소스
│   │   └── images/                # 이미지 파일
│   │       ├── 08c6d18d...png     # 뉴스/정책 썸네일 (30개)
│   │       ├── 13ef0fc5...png
│   │       └── ...
│   │
│   ├── components/                # Vue 컴포넌트
│   │   └── figma/                 # Figma 디자인 컴포넌트
│   │       ├── FigmaHeader.vue           # 헤더 네비게이션
│   │       ├── FigmaFooter.vue           # 푸터
│   │       ├── FigmaHeroSection.vue      # 메인 히어로 슬라이드
│   │       ├── FigmaServiceCards.vue     # 정책 카드 그리드
│   │       └── FigmaSidebar.vue          # 사이드바 (데스크톱 전용)
│   │
│   ├── css/                       # 스타일시트
│   │   ├── app.scss               # 글로벌 SCSS
│   │   └── figma.css              # Figma 전용 유틸리티 CSS
│   │
│   ├── data/                      # 더미 데이터
│   │   ├── policyData.ts          # 정책 데이터 (5개 카테고리)
│   │   └── learningData.ts        # 학습 콘텐츠 데이터
│   │
│   ├── pages/                     # 페이지 컴포넌트
│   │   ├── FigmaLandingPage.vue          # 메인 랜딩 페이지
│   │   ├── FigmaCategoryPage.vue         # 카테고리 상세 페이지
│   │   ├── FigmaLoginPage.vue            # 로그인 페이지
│   │   ├── FigmaSignupPage.vue           # 회원가입 페이지
│   │   └── FigmaComingSoonPage.vue       # 준비중 페이지
│   │
│   └── router/                    # Vue Router 설정
│       ├── index.js               # 라우터 인스턴스 생성
│       └── routes.js              # 라우트 정의
│
├── docs/                          # 문서 (선택사항)
│   ├── README.md                  # 프로젝트 소개 및 가이드
│   ├── SCREEN_DESIGN.md           # 화면 설계서
│   └── PROJECT_STRUCTURE.md       # 프로젝트 구조 문서 (이 파일)
│
└── README.md                      # 프로젝트 메인 문서
```

---

## 컴포넌트 의존성 다이어그램

### 전체 구조

```
App.vue (Root)
  │
  ├─ Router View
  │   │
  │   ├─ FigmaLandingPage
  │   │   ├─ FigmaHeader ────────┐
  │   │   ├─ FigmaHeroSection    │
  │   │   ├─ FigmaServiceCards   │  (공통 컴포넌트)
  │   │   ├─ FigmaSidebar        │
  │   │   └─ FigmaFooter ────────┤
  │   │                           │
  │   ├─ FigmaCategoryPage        │
  │   │   ├─ FigmaHeader ─────────┤
  │   │   └─ FigmaFooter ─────────┤
  │   │                           │
  │   ├─ FigmaLoginPage           │
  │   │   ├─ FigmaHeader ─────────┤
  │   │   └─ FigmaFooter ─────────┤
  │   │                           │
  │   ├─ FigmaSignupPage          │
  │   │   ├─ FigmaHeader ─────────┤
  │   │   └─ FigmaFooter ─────────┤
  │   │                           │
  │   └─ FigmaComingSoonPage      │
  │       ├─ FigmaHeader ─────────┤
  │       └─ FigmaFooter ─────────┘
  │
  └─ Quasar Plugins
      ├─ Notify
      ├─ Dialog
      └─ Loading
```

### 컴포넌트 재사용 맵

```
FigmaHeader ──┬─ FigmaLandingPage
              ├─ FigmaCategoryPage
              ├─ FigmaLoginPage
              ├─ FigmaSignupPage
              └─ FigmaComingSoonPage

FigmaFooter ──┬─ FigmaLandingPage
              ├─ FigmaCategoryPage
              ├─ FigmaLoginPage
              ├─ FigmaSignupPage
              └─ FigmaComingSoonPage

FigmaHeroSection ── FigmaLandingPage

FigmaServiceCards ── FigmaLandingPage

FigmaSidebar ── FigmaLandingPage
```

---

## 라우팅 구조

### 라우트 트리

```
/ (Root)
├─ / → FigmaLandingPage (메인)
├─ /category/:category → FigmaCategoryPage
│   ├─ /category/일자리
│   ├─ /category/주거
│   ├─ /category/교육
│   ├─ /category/금융･복지･문화
│   └─ /category/참여
├─ /login → FigmaLoginPage
├─ /signup → FigmaSignupPage
├─ /coming-soon → FigmaComingSoonPage
└─ /:catchAll(.*) → Redirect to /
```

### 라우트 정의 (routes.js)

```javascript
[
  {
    path: '/',
    name: 'landing',
    component: () => import('../pages/FigmaLandingPage.vue'),
    meta: { title: '청년있슈 - 청년 정책 통합 플랫폼' }
  },
  {
    path: '/category/:category',
    name: 'category',
    component: () => import('../pages/FigmaCategoryPage.vue'),
    meta: { title: '정책 상세' }
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('../pages/FigmaLoginPage.vue'),
    meta: { title: '로그인' }
  },
  {
    path: '/signup',
    name: 'signup',
    component: () => import('../pages/FigmaSignupPage.vue'),
    meta: { title: '회원가입' }
  },
  {
    path: '/coming-soon',
    name: 'coming-soon',
    component: () => import('../pages/FigmaComingSoonPage.vue'),
    meta: { title: '준비중' }
  },
  {
    path: '/:catchAll(.*)*',
    redirect: '/'
  }
]
```

### 네비게이션 흐름

```
┌────────────────┐
│  Landing (/)   │
└────────────────┘
    │
    ├──→ [일자리 카드] → /category/일자리
    ├──→ [주거 카드] → /category/주거
    ├──→ [교육 카드] → /category/교육
    ├──→ [금융 카드] → /category/금융･복지･문화
    ├──→ [참여 카드] → /category/참여
    │
    ├──→ [로그인 버튼] → /login
    │         └──→ [회원가입 링크] → /signup
    │                    └──→ [로그인 링크] → /login
    │
    └──→ [청년정책카페] → /coming-soon
              └──→ [홈으로] → /

┌──────────────────────┐
│ Category (/category) │
└──────────────────────┘
    │
    └──→ [← 뒤로] → /
```

---

## 데이터 흐름

### 데이터 소스

#### 1. policyData.ts

**Export**: `categoryPolicies: Record<string, Policy[]>`

```typescript
{
  '일자리': [Policy1, Policy2, Policy3],
  '주거': [Policy1, Policy2, Policy3],
  '교육': [Policy1, Policy2, Policy3],
  '금융･복지･문화': [Policy1, Policy2, Policy3],
  '참여': [Policy1, Policy2, Policy3]
}
```

**사용처**:
- `FigmaCategoryPage.vue` → 정책 목록 표시

#### 2. learningData.ts

**Export**:
- `getCategoryVideos(category: string): Video[]`
- `getCategoryQnA(category: string): QnA[]`
- `getCategoryQuizzes(category: string): Quiz[]`
- `calculateCompletionRate(category: string): number`

**사용처**:
- `FigmaCategoryPage.vue` → 영상, Q&A, 퀴즈 목록 표시

### 데이터 흐름 다이어그램

```
┌─────────────────┐
│  policyData.ts  │
│  (정책 데이터)   │
└─────────────────┘
        │
        ├──→ import
        │
        ▼
┌──────────────────────────┐
│ FigmaCategoryPage.vue    │
│                          │
│ const category = route   │
│   .params.category       │
│                          │
│ const policies = ref(    │
│   categoryPolicies[      │
│     category             │
│   ]                      │
│ )                        │
└──────────────────────────┘
        │
        ├──→ v-for
        ▼
    [정책 카드 렌더링]


┌─────────────────┐
│ learningData.ts │
│  (학습 데이터)   │
└─────────────────┘
        │
        ├──→ getCategoryVideos(category)
        ├──→ getCategoryQuizzes(category)
        ├──→ calculateCompletionRate(category)
        │
        ▼
┌──────────────────────────┐
│ FigmaCategoryPage.vue    │
│                          │
│ const videos = computed( │
│   () => getCategoryVideos│
│     (category.value)     │
│ )                        │
│                          │
│ const quizzes = computed(│
│   () => getCategoryQuizzes│
│     (category.value)     │
│ )                        │
└──────────────────────────┘
        │
        ├──→ v-for
        ▼
    [영상/퀴즈 카드 렌더링]
```

### 상태 관리

**현재**: ❌ Pinia/Vuex 사용 안 함
**이유**: 프로토타입이므로 로컬 상태만 사용

**향후 계획**:
- Pinia 도입 예정
- 사용자 인증 상태
- 학습 진도 상태
- 퀴즈 결과 상태

---

## 파일별 상세 설명

### 설정 파일

#### package.json

```json
{
  "name": "youth-policy-figma",
  "version": "1.0.0",
  "description": "청년있슈 - 청년 정책 통합 플랫폼 (Figma 프로토타입)",
  "scripts": {
    "dev": "quasar dev",
    "build": "quasar build",
    "lint": "eslint --ext .js,.vue ./src"
  },
  "dependencies": {
    "@quasar/extras": "^1.16.4",
    "quasar": "^2.14.0",
    "vue": "^3.4.0",
    "vue-router": "^4.2.5"
  },
  "devDependencies": {
    "@quasar/app-vite": "^2.4.0",
    "@vitejs/plugin-vue": "^5.0.0",
    "autoprefixer": "^10.4.14",
    "eslint": "^8.57.0",
    "eslint-plugin-vue": "^9.0.0",
    "vite": "^5.0.0"
  }
}
```

**주요 의존성**:
- Vue 3.4.0: Composition API
- Quasar 2.14.0: UI 프레임워크
- Vue Router 4.2.5: 라우팅
- Vite 5.0.0: 빌드 툴

**제거된 의존성**:
- ~~@supabase/supabase-js~~ (원래 프로젝트에서 제거)
- ~~pinia~~ (상태 관리 미사용)

#### quasar.config.js

```javascript
export default configure(function () {
  return {
    boot: [],  // 부트 파일 없음 (Supabase 제거됨)

    css: [
      'app.scss',    // 글로벌 스타일
      'figma.css'    // Figma 유틸리티
    ],

    extras: [
      'roboto-font',      // Roboto 폰트
      'material-icons'    // Material Icons
    ],

    framework: {
      plugins: [
        'Notify',   // 토스트 알림
        'Dialog',   // 다이얼로그
        'Loading'   // 로딩 스피너
      ]
    },

    devServer: {
      open: true,     // 브라우저 자동 열기
      port: 9003      // 개발 서버 포트
    }
  }
})
```

---

### 소스 파일

#### src/App.vue

**역할**: 루트 컴포넌트
**구조**:
```vue
<template>
  <router-view />
</template>

<script setup>
// 추가 로직 없음
</script>
```

**설명**:
- Vue Router의 `<router-view>`만 렌더링
- 모든 페이지 전환은 라우터가 처리

---

#### src/router/index.js

**역할**: Vue Router 인스턴스 생성

```javascript
import { createRouter, createWebHistory } from 'vue-router'
import routes from './routes'

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

**설정**:
- **History Mode**: HTML5 History API (URL에 # 없음)
- **Base URL**: `/` (루트)

---

#### src/router/routes.js

**역할**: 라우트 정의

**특징**:
- Lazy Loading: `() => import()` 사용
- Meta 정보: `title` (페이지 제목)
- Catch-all: 404 시 메인으로 리다이렉트

---

#### src/components/figma/FigmaHeader.vue

**역할**: 전역 헤더 네비게이션

**주요 기능**:
- 로고 클릭 → 메인 이동
- 카테고리 버튼 → 카테고리 페이지 이동
- 로그인/회원가입 버튼
- 모바일 햄버거 메뉴

**주요 코드**:
```vue
<script setup>
import { useRouter } from 'vue-router'
const router = useRouter()

const categories = [
  { name: '일자리', path: '/category/일자리' },
  // ...
]

const goToCategory = (path) => {
  router.push(path)
}
</script>
```

**Props**: 없음
**Emits**: 없음
**의존성**: Vue Router

---

#### src/components/figma/FigmaFooter.vue

**역할**: 전역 푸터

**주요 기능**:
- 사이트 링크 (클릭 시 alert)
- 언어 선택 드롭다운
- 고객센터 버튼
- 저작권 표시

**주요 코드**:
```vue
<script setup>
import { ref } from 'vue'
import { useQuasar } from 'quasar'

const $q = useQuasar()
const language = ref('ko')

const handleCustomerService = () => {
  $q.notify({
    message: '고객센터: 준비중입니다',
    color: 'orange'
  })
}
</script>
```

**Props**: 없음
**Emits**: 없음
**의존성**: Quasar Notify

---

#### src/components/figma/FigmaHeroSection.vue

**역할**: 메인 페이지 히어로 슬라이드

**주요 기능**:
- 자동 슬라이드 (4초 간격)
- 좌우 화살표 네비게이션
- 하단 점 네비게이션

**주요 코드**:
```vue
<template>
  <q-carousel
    v-model="slide"
    animated
    arrows
    navigation
    infinite
    autoplay
    :autoplay-interval="4000"
    height="400px"
  >
    <q-carousel-slide
      v-for="(news, index) in newsSlides"
      :key="index"
      :name="index"
    >
      <img :src="news.image" :alt="news.title" />
    </q-carousel-slide>
  </q-carousel>
</template>

<script setup>
import { ref } from 'vue'

const slide = ref(0)
const newsSlides = [
  { title: '공지1', image: '/src/assets/images/...' },
  // ...
]
</script>
```

**Props**: 없음
**Emits**: 없음
**의존성**: Quasar Q-Carousel

---

#### src/components/figma/FigmaServiceCards.vue

**역할**: 5가지 정책 카드 그리드

**주요 기능**:
- 카드 클릭 → 카테고리 페이지 이동
- 그라디언트 배경
- 인기 뱃지 (참여 카테고리)

**주요 코드**:
```vue
<script setup>
import { useRouter } from 'vue-router'

const router = useRouter()

const cards = [
  {
    id: 1,
    title: '일자리',
    icon: 'work',
    description: '청년 취업 지원과 창업 기회를 제공합니다',
    gradient: 'linear-gradient(135deg, #3B82F6 0%, #2563EB 100%)',
    category: '일자리',
    popular: false
  },
  // ...
]

const handleCardClick = (category) => {
  router.push({ name: 'category', params: { category } })
}
</script>
```

**Props**: 없음
**Emits**: 없음
**의존성**: Vue Router

---

#### src/components/figma/FigmaSidebar.vue

**역할**: 데스크톱 사이드바

**주요 기능**:
- 청년정책카페 버튼
- 카테고리 퀵 링크
- 알림 카드

**조건부 렌더링**: `class="gt-md"` (1024px 이상만 표시)

**주요 코드**:
```vue
<template>
  <aside class="gt-md" style="position: sticky; top: 80px;">
    <q-card>
      <q-btn @click="goToCafe">청년정책카페</q-btn>
      <q-btn
        v-for="category in categories"
        @click="goToCategory(category.name)"
      >
        {{ category.name }}
      </q-btn>
    </q-card>
  </aside>
</template>

<script setup>
const goToCafe = () => {
  router.push('/coming-soon')
}
</script>
```

**Props**: 없음
**Emits**: 없음
**의존성**: Vue Router

---

#### src/pages/FigmaLandingPage.vue

**역할**: 메인 랜딩 페이지

**구조**:
```vue
<template>
  <div>
    <FigmaHeader />
    <FigmaHeroSection />

    <div style="display: flex;">
      <div style="flex: 1;">
        <FigmaServiceCards />
      </div>
      <FigmaSidebar />
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup>
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
import FigmaHeroSection from '../components/figma/FigmaHeroSection.vue'
import FigmaServiceCards from '../components/figma/FigmaServiceCards.vue'
import FigmaSidebar from '../components/figma/FigmaSidebar.vue'
</script>
```

**Props**: 없음
**Computed**: 없음
**Methods**: 없음

---

#### src/pages/FigmaCategoryPage.vue

**역할**: 카테고리 상세 페이지

**주요 기능**:
- URL 파라미터에서 카테고리 추출
- 카테고리별 정책/영상/퀴즈 표시
- 학습 진도율 계산

**주요 코드**:
```vue
<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { categoryPolicies } from '../data/policyData'
import { getCategoryVideos, getCategoryQuizzes, calculateCompletionRate } from '../data/learningData'

const route = useRoute()
const router = useRouter()

const category = ref(route.params.category)
const policies = ref(categoryPolicies[category.value] || [])
const videos = computed(() => getCategoryVideos(category.value))
const quizzes = computed(() => getCategoryQuizzes(category.value))
const completionRate = computed(() => calculateCompletionRate(category.value))

const handleBack = () => {
  router.push('/')
}
</script>
```

**Props**: 없음
**Route Params**: `category` (string)
**Computed**: `videos`, `quizzes`, `completionRate`

---

#### src/pages/FigmaLoginPage.vue

**역할**: 로그인 페이지

**주요 기능**:
- 이메일/비밀번호 입력
- 소셜 로그인 버튼 (Google, Kakao, Naver)
- 더미 로그인 (1초 후 메인 이동)

**주요 코드**:
```vue
<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const formData = ref({ email: '', password: '' })
const loading = ref(false)

const handleLogin = async () => {
  loading.value = true
  setTimeout(() => {
    loading.value = false
    router.push('/')
  }, 1000)
}

const goToSignup = () => {
  router.push({ name: 'signup' })
}
</script>
```

**Props**: 없음
**Reactive State**: `formData`, `loading`

---

#### src/pages/FigmaSignupPage.vue

**역할**: 회원가입 페이지

**주요 기능**:
- 회원가입 폼 (이메일, 비밀번호, 이름, 생년월일, 학교, 학번)
- 약관 동의 체크박스
- 더미 회원가입 (1초 후 로그인 페이지 이동)

**주요 코드**:
```vue
<script setup>
const formData = ref({
  email: '',
  password: '',
  passwordConfirm: '',
  name: '',
  birthdate: '',
  school: '',
  studentId: '',
  agreeTerms: false,
  agreePrivacy: false,
  agreeMarketing: false
})

const schoolOptions = [
  { label: '대전보건대학교', value: '보건대' },
  { label: '대전과학기술대학교', value: '과기대' },
  { label: '한국폴리텍대학 대전캠퍼스', value: '폴리텍' }
]

const handleSignup = async () => {
  loading.value = true
  setTimeout(() => {
    loading.value = false
    router.push({ name: 'login' })
  }, 1000)
}
</script>
```

**Props**: 없음
**Reactive State**: `formData`, `loading`
**Validation**: Quasar Q-Input rules

---

#### src/pages/FigmaComingSoonPage.vue

**역할**: 준비중 페이지

**주요 기능**:
- 준비중 안내
- 예정 기능 미리보기
- 알림 신청 버튼

**주요 코드**:
```vue
<script setup>
import { useRouter } from 'vue-router'
import { useQuasar } from 'quasar'

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
```

**Props**: 없음
**의존성**: Quasar Notify

---

#### src/data/policyData.ts

**역할**: 정책 데이터 저장소

**타입 정의**:
```typescript
export interface PolicyDetail {
  title: string
  content: string
}

export interface Policy {
  id: number
  title: string
  icon: string
  image: string
  content: {
    intro: string
    details: PolicyDetail[]
  }
  description: string[]
}
```

**Export**:
```typescript
export const categoryPolicies: Record<string, Policy[]> = {
  '일자리': jobPolicies,        // 3개 정책
  '주거': housingPolicies,      // 3개 정책
  '교육': educationPolicies,    // 3개 정책
  '금융･복지･문화': financeWelfareCulturePolicies,  // 3개 정책
  '참여': participationPolicies  // 3개 정책
}
```

**총 데이터**: 5개 카테고리 × 3개 정책 = 15개 정책

---

#### src/data/learningData.ts

**역할**: 학습 콘텐츠 데이터 저장소

**타입 정의**:
```typescript
export interface Video {
  id: number
  title: string
  thumbnail: string
  duration: string
  views: number
  url: string
}

export interface Quiz {
  id: number
  question: string
  answer: boolean
  score: number
}
```

**Export 함수**:
- `getCategoryVideos(category: string): Video[]` - 카테고리별 영상 3개
- `getCategoryQnA(category: string): QnA[]` - 카테고리별 Q&A
- `getCategoryQuizzes(category: string): Quiz[]` - 카테고리별 퀴즈 5개
- `calculateCompletionRate(category: string): number` - 랜덤 진도율 (30~80%)

---

#### src/css/app.scss

**역할**: 글로벌 SCSS 스타일

**내용**:
```scss
// app global css

* {
  box-sizing: border-box;
}

body {
  font-family: 'Roboto', sans-serif;
}

// 유틸리티 클래스
.cursor-pointer {
  cursor: pointer;
}

.text-underline {
  text-decoration: underline;
}
```

**특징**:
- `quasar.variables.scss` import 제거 (존재하지 않음)
- 최소한의 글로벌 스타일만 정의

---

#### src/css/figma.css

**역할**: Figma 전용 유틸리티 CSS (Tailwind 대체)

**내용**: 약 600줄
- 색상 클래스: `.text-primary`, `.bg-gray-100`, etc.
- 간격 클래스: `.p-4`, `.m-2`, `.gap-4`, etc.
- Flexbox: `.flex`, `.flex-col`, `.justify-center`, etc.
- Grid: `.grid`, `.grid-cols-3`, etc.
- 텍스트: `.text-center`, `.font-bold`, etc.
- 기타: `.rounded-lg`, `.shadow-md`, etc.

**이유**: Tailwind CSS 없이 유사한 유틸리티 제공

---

## 빌드 프로세스

### 개발 모드

```bash
npm run dev
```

**과정**:
1. Quasar CLI 실행
2. Vite 개발 서버 시작 (포트 9003)
3. Hot Module Replacement (HMR) 활성화
4. 브라우저 자동 열림

### 프로덕션 빌드

```bash
npm run build
```

**과정**:
1. Quasar CLI 실행
2. Vite 빌드 (최적화, 번들링, 압축)
3. `dist/spa/` 디렉토리에 결과물 생성

**결과물 구조**:
```
dist/spa/
├── index.html
├── assets/
│   ├── index.[hash].js
│   ├── index.[hash].css
│   └── [images]
└── ...
```

---

## 배포 전략

### 정적 호스팅 옵션

1. **Vercel** (추천)
   - 자동 빌드 및 배포
   - 프리뷰 URL
   - 무료 플랜

2. **Netlify**
   - Drag & Drop 배포
   - 폼 처리
   - 무료 플랜

3. **GitHub Pages**
   - GitHub 레포지토리 연동
   - 무료
   - `gh-pages` 브랜치

4. **Firebase Hosting**
   - 빠른 CDN
   - 무료 플랜

---

## 마무리

이 문서는 청년있슈 프로토타입의 전체 구조를 상세하게 설명합니다.
코드 수정 시 이 구조를 참고하여 일관성을 유지하시기 바랍니다.

**다음 단계**:
- GitHub 레포지토리 생성
- Vercel 배포 설정
- 실제 API 연동 준비

**마지막 업데이트**: 2026-01-22
