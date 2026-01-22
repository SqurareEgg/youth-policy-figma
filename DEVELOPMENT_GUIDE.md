# 개발 가이드 (Development Guide)

> 세션 재개 시 빠른 작업 복귀를 위한 상세 개발 가이드

**작성일**: 2026-01-22
**버전**: 1.0.0

---

## 목차

1. [빠른 시작 (Quick Start)](#빠른-시작)
2. [프로젝트 현황](#프로젝트-현황)
3. [데이터 구조 API](#데이터-구조-api)
4. [개발 워크플로우](#개발-워크플로우)
5. [일반적인 작업 가이드](#일반적인-작업-가이드)
6. [트러블슈팅](#트러블슈팅)
7. [다음 작업 TODO](#다음-작업-todo)

---

## 빠른 시작

### 프로젝트 위치

```bash
프로젝트 경로: C:\WebWork\YouthV2-Figma
원본 프로젝트: C:\WebWork\YouthV2 (별도 존재)
```

### 세션 재개 시 체크리스트

1. **프로젝트 디렉토리로 이동**
   ```bash
   cd C:\WebWork\YouthV2-Figma
   ```

2. **최신 코드 확인**
   ```bash
   git status
   git log --oneline -5
   ```

3. **의존성 확인 (필요시 재설치)**
   ```bash
   npm install
   ```

4. **개발 서버 실행**
   ```bash
   npm run dev
   ```
   - 기본 포트: 9003
   - 자동 브라우저 열림: http://localhost:9003

5. **주요 문서 확인**
   - `README.md` - 프로젝트 개요
   - `SCREEN_DESIGN.md` - 화면 설계서
   - `PROJECT_STRUCTURE.md` - 구조 문서
   - `DEVELOPMENT_GUIDE.md` - 이 파일

---

## 프로젝트 현황

### 완료된 작업 ✅

- [x] Git 롤백 (병합 전 상태로 복귀)
- [x] 새 프로젝트로 분리 (`YouthV2-Figma`)
- [x] Figma 디자인 → Vue 컴포넌트 변환
- [x] 5개 페이지 구현
  - 랜딩 페이지
  - 카테고리 상세 페이지
  - 로그인 페이지
  - 회원가입 페이지
  - 준비중 페이지
- [x] 5개 공통 컴포넌트 구현
  - Header
  - Footer
  - HeroSection (자동 슬라이드)
  - ServiceCards (5가지 정책 카드)
  - Sidebar (데스크톱 전용)
- [x] 더미 데이터 구조 생성
  - 정책 데이터 (5개 카테고리 × 3개 = 15개)
  - 학습 콘텐츠 (영상, Q&A, 퀴즈)
- [x] 반응형 디자인 (모바일/태블릿/데스크톱)
- [x] 라우팅 설정
- [x] 문서 작성 (README, 화면설계서, 구조문서, 개발가이드)
- [x] Git 초기화 및 첫 커밋

### 미완료/미구현 기능 ❌

- [ ] 실제 인증 시스템 (현재 더미)
- [ ] 데이터베이스 연동 (현재 더미 데이터)
- [ ] 영상 재생 기능 (현재 플레이스홀더)
- [ ] 퀴즈 제출 및 채점 (현재 UI만)
- [ ] 학습 진도 저장 (현재 랜덤 값)
- [ ] 청년정책카페 (커뮤니티) 기능
- [ ] 관리자 페이지
- [ ] GitHub 레포지토리 생성 및 push
- [ ] 프로덕션 배포 (Vercel/Netlify)

---

## 데이터 구조 API

### policyData.ts

**위치**: `src/data/policyData.ts`

#### 타입 정의

```typescript
export interface PolicyDetail {
  title: string          // 상세 제목
  content: string        // 상세 내용
}

export interface Policy {
  id: number            // 정책 ID
  title: string         // 정책 제목
  icon: string          // Material Icon 이름
  image: string         // 썸네일 경로
  content: {
    intro: string                 // 정책 소개
    details: PolicyDetail[]       // 상세 정보 배열
  }
  description: string[]           // 설명 (여러 줄)
}
```

#### Export

```typescript
export const categoryPolicies: Record<string, Policy[]> = {
  '일자리': jobPolicies,
  '주거': housingPolicies,
  '교육': educationPolicies,
  '금융･복지･문화': financeWelfareCulturePolicies,
  '참여': participationPolicies
}
```

#### 사용 예시

```vue
<script setup>
import { categoryPolicies } from '../data/policyData'

// 특정 카테고리 정책 가져오기
const jobPolicies = categoryPolicies['일자리']  // Policy[] (3개)

// 순회
jobPolicies.forEach(policy => {
  console.log(policy.title)    // "청년 일자리 도약 장려금"
  console.log(policy.icon)     // "work"
  console.log(policy.image)    // "/src/assets/images/..."
})
</script>
```

---

### learningData.ts

**위치**: `src/data/learningData.ts`

#### 타입 정의

```typescript
export interface Video {
  id: number            // 영상 ID
  title: string         // 영상 제목
  thumbnail: string     // 썸네일 경로
  duration: string      // 재생 시간 (예: "12:34")
  views: number         // 조회수
  url: string           // YouTube URL (더미)
}

export interface QnA {
  id: number            // Q&A ID
  question: string      // 질문
  answer: string        // 답변
  author: string        // 작성자
  date: string          // 작성일
}

export interface Quiz {
  id: number            // 퀴즈 ID
  question: string      // 문제
  answer: boolean       // 정답 (true=O, false=X)
  score: number         // 획득 점수
}
```

#### Export 함수

##### getCategoryVideos()

```typescript
export function getCategoryVideos(category: string): Video[]
```

**설명**: 카테고리별 추천 영상 3개 반환

**매개변수**:
- `category` (string): 카테고리명 ('일자리', '주거', '교육', '금융･복지･문화', '참여')

**반환값**: `Video[]` (3개)

**사용 예시**:
```vue
<script setup>
import { getCategoryVideos } from '../data/learningData'

const videos = getCategoryVideos('일자리')
// [
//   { id: 1, title: '청년 취업 성공 전략', ... },
//   { id: 2, title: '이력서 작성 팁', ... },
//   { id: 3, title: '면접 준비하기', ... }
// ]
</script>
```

##### getCategoryQnA()

```typescript
export function getCategoryQnA(category: string): QnA[]
```

**설명**: 카테고리별 자주 묻는 질문 5개 반환

**매개변수**:
- `category` (string): 카테고리명

**반환값**: `QnA[]` (5개)

##### getCategoryQuizzes()

```typescript
export function getCategoryQuizzes(category: string): Quiz[]
```

**설명**: 카테고리별 OX 퀴즈 5개 반환

**매개변수**:
- `category` (string): 카테고리명

**반환값**: `Quiz[]` (5개)

**사용 예시**:
```vue
<script setup>
import { getCategoryQuizzes } from '../data/learningData'

const quizzes = getCategoryQuizzes('주거')
// [
//   { id: 1, question: '청년 주거지원은 만 19~34세만 신청 가능하다', answer: true, score: 10 },
//   ...
// ]
</script>
```

##### calculateCompletionRate()

```typescript
export function calculateCompletionRate(category: string): number
```

**설명**: 카테고리별 학습 진도율 반환 (현재 랜덤 30~80%)

**매개변수**:
- `category` (string): 카테고리명

**반환값**: `number` (30~80 사이의 정수)

**사용 예시**:
```vue
<script setup>
import { calculateCompletionRate } from '../data/learningData'

const rate = calculateCompletionRate('교육')  // 예: 65
</script>

<template>
  <div>학습 진도율: {{ rate }}%</div>
</template>
```

---

## 개발 워크플로우

### 1. 새 기능 개발

```bash
# 1. 새 브랜치 생성 (선택사항)
git checkout -b feature/새기능명

# 2. 코드 작성

# 3. 로컬 테스트
npm run dev

# 4. 빌드 테스트
npm run build

# 5. 커밋
git add .
git commit -m "Feat: 새 기능 설명"

# 6. 푸시 (원격 저장소 설정 후)
git push origin feature/새기능명
```

### 2. 버그 수정

```bash
# 1. 버그 확인 및 재현

# 2. 코드 수정

# 3. 테스트

# 4. 커밋
git commit -m "Fix: 버그 설명"
```

### 3. 스타일 변경

```bash
# 1. 스타일 수정
#    - 전역 스타일: src/css/app.scss
#    - 유틸리티: src/css/figma.css
#    - 컴포넌트: 각 .vue 파일의 <style scoped>

# 2. 핫 리로드로 즉시 확인

# 3. 커밋
git commit -m "Style: 스타일 변경 설명"
```

---

## 일반적인 작업 가이드

### 새 페이지 추가하기

#### 1. 페이지 컴포넌트 생성

**위치**: `src/pages/NewPage.vue`

```vue
<template>
  <div>
    <FigmaHeader />

    <div class="container">
      <h1>새 페이지 제목</h1>
      <!-- 페이지 내용 -->
    </div>

    <FigmaFooter />
  </div>
</template>

<script setup lang="ts">
import FigmaHeader from '../components/figma/FigmaHeader.vue'
import FigmaFooter from '../components/figma/FigmaFooter.vue'
// 필요한 imports
</script>

<style scoped>
/* 페이지 전용 스타일 */
</style>
```

#### 2. 라우트 추가

**위치**: `src/router/routes.js`

```javascript
const routes = [
  // 기존 라우트...

  {
    path: '/new-page',
    name: 'new-page',
    component: () => import('../pages/NewPage.vue'),
    meta: {
      title: '새 페이지 제목'
    }
  },

  // ...
]
```

#### 3. 네비게이션 추가 (필요시)

**Header에 버튼 추가**:

`src/components/figma/FigmaHeader.vue`:

```vue
<q-btn
  flat
  no-caps
  label="새 페이지"
  @click="router.push('/new-page')"
/>
```

---

### 새 카테고리 추가하기

#### 1. 정책 데이터 추가

**위치**: `src/data/policyData.ts`

```typescript
const newCategoryPolicies: Policy[] = [
  {
    id: 1,
    title: '새 카테고리 정책 1',
    icon: 'icon_name',
    image: '/src/assets/images/image.png',
    content: {
      intro: '정책 소개',
      details: [
        { title: '상세 1', content: '내용' }
      ]
    },
    description: ['설명 1', '설명 2']
  },
  // 2개 더...
]

export const categoryPolicies: Record<string, Policy[]> = {
  // 기존 카테고리...
  '새카테고리': newCategoryPolicies
}
```

#### 2. 학습 콘텐츠 추가

**위치**: `src/data/learningData.ts`

```typescript
// getCategoryVideos 함수에 추가
export function getCategoryVideos(category: string): Video[] {
  const videosByCategory: Record<string, Video[]> = {
    // 기존...
    '새카테고리': [
      { id: 1, title: '영상 1', ... },
      // ...
    ]
  }
  // ...
}
```

#### 3. 서비스 카드 추가

**위치**: `src/components/figma/FigmaServiceCards.vue`

```vue
<script setup>
const cards = [
  // 기존 카드...
  {
    id: 6,
    title: '새카테고리',
    icon: 'icon_name',
    description: '새 카테고리 설명',
    gradient: 'linear-gradient(135deg, #COLOR1 0%, #COLOR2 100%)',
    category: '새카테고리',
    popular: false
  }
]
</script>
```

#### 4. 사이드바 추가

**위치**: `src/components/figma/FigmaSidebar.vue`

```vue
<script setup>
const categories = [
  // 기존...
  { name: '새카테고리', icon: 'icon_name' }
]
</script>
```

---

### 새 컴포넌트 생성하기

#### 1. 컴포넌트 파일 생성

**위치**: `src/components/figma/NewComponent.vue`

```vue
<template>
  <div class="new-component">
    <!-- 컴포넌트 내용 -->
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

// Props 정의
interface Props {
  title: string
  count?: number
}

const props = withDefaults(defineProps<Props>(), {
  count: 0
})

// Emits 정의
const emit = defineEmits<{
  (e: 'click', value: string): void
}>()

// 반응형 상태
const isActive = ref(false)

// 계산된 속성
const displayCount = computed(() => {
  return props.count > 99 ? '99+' : props.count
})

// 메서드
const handleClick = () => {
  isActive.value = !isActive.value
  emit('click', 'clicked')
}
</script>

<style scoped>
.new-component {
  /* 스타일 */
}
</style>
```

#### 2. 컴포넌트 사용

```vue
<template>
  <NewComponent
    title="제목"
    :count="10"
    @click="handleComponentClick"
  />
</template>

<script setup>
import NewComponent from '../components/figma/NewComponent.vue'

const handleComponentClick = (value) => {
  console.log('Clicked:', value)
}
</script>
```

---

### 스타일 수정하기

#### 1. 글로벌 스타일 (전체 적용)

**위치**: `src/css/app.scss`

```scss
// 글로벌 클래스 추가
.my-global-class {
  color: #F97316;
}
```

#### 2. 유틸리티 클래스 (재사용)

**위치**: `src/css/figma.css`

```css
/* 새 유틸리티 추가 */
.text-custom-color {
  color: #123456;
}

.bg-custom-gradient {
  background: linear-gradient(135deg, #START 0%, #END 100%);
}
```

#### 3. 컴포넌트 전용 스타일

```vue
<style scoped>
/* 이 컴포넌트에만 적용 */
.component-class {
  padding: 1rem;
}
</style>
```

---

## 트러블슈팅

### Q-Page 에러

**증상**: `QPage needs to be a deep child of QLayout`

**원인**: QLayout 없이 `<q-page>` 사용

**해결**:
```vue
<!-- ❌ 잘못된 사용 -->
<q-page>
  <div>Content</div>
</q-page>

<!-- ✅ 올바른 사용 -->
<div>
  <div>Content</div>
</div>
```

---

### 이미지가 안 보임

**증상**: 이미지 경로 오류

**해결**:
```vue
<!-- ✅ 절대 경로 사용 -->
<img src="/src/assets/images/image.png" />

<!-- 또는 import 사용 -->
<script setup>
import imageSrc from '../assets/images/image.png'
</script>
<template>
  <img :src="imageSrc" />
</template>
```

---

### 스타일이 안 먹힘

**증상**: Tailwind 클래스가 작동하지 않음

**원인**: Tailwind CSS 미설치

**해결**: `src/css/figma.css`의 커스텀 클래스 사용

```vue
<!-- ❌ Tailwind (작동 안 함) -->
<div class="bg-blue-500 text-white">

<!-- ✅ 커스텀 클래스 사용 -->
<div class="bg-primary text-white" style="background: #3B82F6;">
```

---

### 포트 충돌

**증상**: `Port 9003 is already in use`

**해결**:
```bash
# 1. 다른 포트 사용
quasar dev --port 9004

# 2. 또는 quasar.config.js 수정
devServer: {
  port: 9004
}
```

---

### 핫 리로드 안 됨

**증상**: 코드 변경 시 자동 새로고침 안 됨

**해결**:
```bash
# 1. 개발 서버 재시작
Ctrl+C
npm run dev

# 2. 브라우저 강제 새로고침
Ctrl + Shift + R
```

---

## 다음 작업 TODO

### 우선순위 높음 🔴

1. **GitHub 레포지토리 생성 및 Push**
   - [ ] GitHub에 새 레포지토리 생성
   - [ ] 원격 저장소 설정
   - [ ] 코드 push
   - [ ] README 확인

2. **배포 (Vercel/Netlify)**
   - [ ] Vercel 계정 연동
   - [ ] 프로젝트 import
   - [ ] 빌드 설정 확인
   - [ ] 배포 URL 확인

3. **실제 인증 시스템 구현**
   - [ ] Supabase 프로젝트 생성
   - [ ] 인증 설정
   - [ ] 로그인 페이지 연동
   - [ ] 회원가입 페이지 연동
   - [ ] 보호된 라우트 설정

### 우선순위 중간 🟡

4. **데이터베이스 연동**
   - [ ] Supabase 테이블 설계
   - [ ] 정책 데이터 마이그레이션
   - [ ] 학습 콘텐츠 마이그레이션
   - [ ] API 함수 작성

5. **학습 진도 저장 기능**
   - [ ] 사용자별 진도 테이블
   - [ ] 진도 업데이트 API
   - [ ] 진도율 계산 로직

6. **영상 재생 기능**
   - [ ] YouTube Embed 연동
   - [ ] 재생 시간 추적
   - [ ] 완료 처리

### 우선순위 낮음 🟢

7. **퀴즈 제출 및 채점**
   - [ ] 퀴즈 제출 API
   - [ ] 정답 확인 로직
   - [ ] 점수 저장
   - [ ] 결과 페이지

8. **청년정책카페 (커뮤니티)**
   - [ ] 게시판 테이블 설계
   - [ ] 게시글 CRUD
   - [ ] 댓글 기능
   - [ ] 좋아요/북마크

9. **관리자 페이지**
   - [ ] 관리자 인증
   - [ ] 정책 관리 CRUD
   - [ ] 사용자 관리
   - [ ] 통계 대시보드

---

## Git 커밋 컨벤션

```
Feat: 새로운 기능 추가
Fix: 버그 수정
Update: 기능 개선
Refactor: 코드 리팩토링
Docs: 문서 수정
Style: 스타일 변경 (코드 포맷팅, 세미콜론 등)
Test: 테스트 코드
Chore: 기타 작업 (빌드 스크립트, 패키지 매니저 등)
```

**예시**:
```bash
git commit -m "Feat: 청년정책카페 메뉴 추가"
git commit -m "Fix: 로그인 버튼 클릭 시 에러 수정"
git commit -m "Update: 카테고리 페이지 UI 개선"
git commit -m "Docs: README에 배포 가이드 추가"
```

---

## 유용한 명령어

### 개발

```bash
# 개발 서버 시작
npm run dev

# 프로덕션 빌드
npm run build

# Lint 체크
npm run lint

# 특정 포트로 실행
quasar dev --port 9005
```

### Git

```bash
# 상태 확인
git status

# 최근 커밋 보기
git log --oneline -10

# 변경사항 확인
git diff

# 스테이징
git add .

# 커밋
git commit -m "메시지"

# 푸시
git push origin main

# 브랜치 생성
git checkout -b feature/branch-name

# 브랜치 전환
git checkout main

# 브랜치 병합
git merge feature/branch-name
```

### 기타

```bash
# 의존성 설치
npm install

# 특정 패키지 추가
npm install package-name

# 개발 의존성 추가
npm install -D package-name

# 패키지 제거
npm uninstall package-name

# 캐시 정리
npm cache clean --force
```

---

## 참고 자료

### 공식 문서

- [Vue 3 공식 문서](https://vuejs.org/)
- [Quasar 공식 문서](https://quasar.dev/)
- [Vue Router 공식 문서](https://router.vuejs.org/)
- [TypeScript 공식 문서](https://www.typescriptlang.org/)

### 이 프로젝트의 문서

- `README.md` - 프로젝트 개요 및 시작 가이드
- `SCREEN_DESIGN.md` - 화면별 상세 설계서
- `PROJECT_STRUCTURE.md` - 프로젝트 구조 및 아키텍처
- `DEVELOPMENT_GUIDE.md` - 개발 가이드 (이 문서)

---

## 마무리

이 가이드를 참고하여 세션이 끊긴 후에도 빠르게 작업을 재개할 수 있습니다.

**도움이 필요하면**:
1. 먼저 이 문서의 트러블슈팅 섹션 확인
2. README.md의 FAQ 확인
3. Git 로그로 최근 변경사항 확인
4. Quasar/Vue 공식 문서 참조

**행운을 빕니다!** 🚀

**마지막 업데이트**: 2026-01-22
