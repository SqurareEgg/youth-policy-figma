# 청년있슈 - 청년 정책 통합 플랫폼

> 청년을 위한 5가지 정책 카테고리를 제공하는 정보 플랫폼 프로토타입

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Vue](https://img.shields.io/badge/Vue-3.4.0-green.svg)
![Quasar](https://img.shields.io/badge/Quasar-2.14.0-1976D2.svg)

## 📋 프로젝트 개요

청년있슈는 청년들이 필요한 정책 정보를 쉽게 찾고 학습할 수 있도록 돕는 통합 플랫폼입니다.
Figma 디자인을 기반으로 한 프론트엔드 프로토타입으로, 실제 데이터베이스 연동 없이 더미 데이터로 동작합니다.

### 주요 특징

- 🎯 **5가지 청년 정책 카테고리**: 일자리, 주거, 교육, 금융·복지·문화, 참여
- 📚 **다양한 학습 콘텐츠**: 영상, Q&A, OX 퀴즈
- 🎨 **Figma 디자인 기반**: 실제 디자인을 Vue/Quasar로 구현
- 📱 **반응형 디자인**: 모바일, 태블릿, 데스크톱 지원
- 🚀 **프론트엔드 전용**: DB 연동 없는 순수 프론트엔드 프로토타입

## 🛠️ 기술 스택

- **Frontend Framework**: Vue 3 (Composition API)
- **UI Framework**: Quasar 2.14.0
- **Language**: TypeScript
- **Build Tool**: Vite
- **Router**: Vue Router 4
- **CSS**: Custom CSS (Tailwind 스타일 유틸리티)

## 📁 프로젝트 구조

```
YouthV2-Figma/
├── src/
│   ├── assets/              # 정적 파일
│   │   └── images/          # 이미지 파일 (30개 PNG)
│   ├── components/          # Vue 컴포넌트
│   │   └── figma/           # Figma 디자인 컴포넌트
│   │       ├── FigmaHeader.vue           # 헤더 (네비게이션)
│   │       ├── FigmaFooter.vue           # 푸터
│   │       ├── FigmaHeroSection.vue      # 히어로 섹션 (슬라이드)
│   │       ├── FigmaServiceCards.vue     # 정책 카드 그리드
│   │       └── FigmaSidebar.vue          # 사이드바 (데스크톱 전용)
│   ├── css/                 # 스타일 시트
│   │   ├── app.scss         # 글로벌 스타일
│   │   └── figma.css        # Figma 전용 유틸리티 CSS
│   ├── data/                # 더미 데이터
│   │   ├── policyData.ts    # 정책 데이터 (5개 카테고리)
│   │   └── learningData.ts  # 학습 콘텐츠 데이터
│   ├── pages/               # 페이지 컴포넌트
│   │   ├── FigmaLandingPage.vue      # 메인 랜딩 페이지
│   │   ├── FigmaCategoryPage.vue     # 카테고리 상세 페이지
│   │   ├── FigmaLoginPage.vue        # 로그인 페이지
│   │   ├── FigmaSignupPage.vue       # 회원가입 페이지
│   │   └── FigmaComingSoonPage.vue   # 준비중 페이지
│   ├── router/              # 라우터 설정
│   │   ├── index.js         # 라우터 인스턴스
│   │   └── routes.js        # 라우트 정의
│   └── App.vue              # 루트 컴포넌트
├── public/                  # 공개 정적 파일
├── index.html               # HTML 템플릿
├── package.json             # 의존성 관리
├── quasar.config.js         # Quasar 설정
└── README.md                # 프로젝트 문서 (이 파일)
```

## 🚀 시작하기

### 필수 요구사항

- Node.js >= 16.0.0
- npm >= 6.13.4

### 설치

```bash
# 프로젝트 클론
git clone <repository-url>
cd YouthV2-Figma

# 의존성 설치
npm install
```

### 개발 서버 실행

```bash
npm run dev
```

개발 서버가 시작되면 브라우저에서 자동으로 열립니다.
기본 주소: `http://localhost:9003` (포트가 사용 중이면 자동으로 다음 포트 사용)

### 프로덕션 빌드

```bash
npm run build
```

빌드된 파일은 `dist/` 디렉토리에 생성됩니다.

## 🗺️ 페이지 구조

### 1. 메인 랜딩 페이지 (`/`)

- **경로**: `/`
- **컴포넌트**: `FigmaLandingPage.vue`
- **주요 기능**:
  - 자동 슬라이드 히어로 섹션 (4초 간격)
  - 5가지 정책 카테고리 카드
  - 사이드바 네비게이션 (데스크톱 전용)
  - 청년정책카페 링크

### 2. 카테고리 상세 페이지 (`/category/:category`)

- **경로**: `/category/:category`
- **컴포넌트**: `FigmaCategoryPage.vue`
- **파라미터**: `category` - 카테고리명 (일자리, 주거, 교육, 금융･복지･문화, 참여)
- **주요 기능**:
  - 카테고리별 정책 목록
  - 학습 진도율 표시
  - 정책 상세 정보 카드
  - 학습 영상 목록
  - OX 퀴즈 목록

### 3. 로그인 페이지 (`/login`)

- **경로**: `/login`
- **컴포넌트**: `FigmaLoginPage.vue`
- **주요 기능**:
  - 이메일/비밀번호 로그인 폼
  - 소셜 로그인 버튼 (Google, Kakao, Naver)
  - 회원가입 페이지 링크
  - ⚠️ 실제 인증 없음 (더미 핸들러)

### 4. 회원가입 페이지 (`/signup`)

- **경로**: `/signup`
- **컴포넌트**: `FigmaSignupPage.vue`
- **주요 기능**:
  - 회원가입 폼 (이메일, 비밀번호, 이름, 생년월일)
  - 학교 선택 (대전보건대, 대전과기대, 한국폴리텍)
  - 학번 입력 (8자리)
  - 약관 동의 체크박스
  - ⚠️ 실제 회원가입 없음 (더미 핸들러)

### 5. 준비중 페이지 (`/coming-soon`)

- **경로**: `/coming-soon`
- **컴포넌트**: `FigmaComingSoonPage.vue`
- **주요 기능**:
  - 준비중 안내 메시지
  - 예정 기능 미리보기 (커뮤니티, 정보 공유, Q&A)
  - 알림 신청 버튼

## 🎨 디자인 시스템

### 색상 팔레트

```css
/* Primary Color */
--primary: #F97316;        /* Orange 500 */
--primary-dark: #EA580C;   /* Orange 600 */

/* Secondary Colors */
--blue: #3B82F6;           /* Blue 500 */
--blue-dark: #2563EB;      /* Blue 600 */

/* Category Colors */
--job: #3B82F6 → #2563EB;              /* 일자리 - Blue gradient */
--housing: #F97316 → #EA580C;          /* 주거 - Orange gradient */
--education: #4ADE80 → #22C55E;        /* 교육 - Green gradient */
--finance: #F472B6 → #EC4899;          /* 금융･복지･문화 - Pink gradient */
--participation: #2DD4BF → #14B8A6;    /* 참여 - Teal gradient */

/* Neutral Colors */
--navy: #1e3a8a;           /* 제목, 강조 텍스트 */
--gray-dark: #374151;      /* 본문 텍스트 */
--gray: #4B5563;           /* 보조 텍스트 */
--gray-light: #6B7280;     /* 힌트 텍스트 */
--gray-bg: #F9FAFB;        /* 배경 */
```

### 타이포그래피

- **폰트 패밀리**: Roboto, sans-serif
- **제목 (H1)**: 48px / 700 (Bold)
- **제목 (H2)**: 32px / 700 (Bold)
- **제목 (H3)**: 24px / 700 (Bold)
- **본문**: 16px / 400 (Regular)
- **작은 텍스트**: 14px / 400 (Regular)

### 컴포넌트 스타일 가이드

- **카드 모서리**: 16px (rounded-2xl)
- **버튼 모서리**: 8px (rounded-lg)
- **그림자**: `0 10px 15px -3px rgba(0, 0, 0, 0.1)`
- **간격**: 8px 단위 (0.5rem, 1rem, 1.5rem, 2rem)

## 📊 데이터 구조

### PolicyData (정책 데이터)

```typescript
interface Policy {
  id: number
  title: string           // 정책 제목
  icon: string            // Material Icon 이름
  image: string           // 썸네일 이미지 경로
  content: {
    intro: string         // 정책 소개
    details: PolicyDetail[]
  }
  description: string[]   // 정책 설명 (여러 줄)
}

interface PolicyDetail {
  title: string           // 상세 제목
  content: string         // 상세 내용
}
```

### LearningData (학습 콘텐츠)

```typescript
interface Video {
  id: number
  title: string           // 영상 제목
  thumbnail: string       // 썸네일 경로
  duration: string        // 영상 길이 (예: "12:34")
  views: number           // 조회수
  url: string             // YouTube URL (더미)
}

interface Quiz {
  id: number
  question: string        // 퀴즈 질문
  answer: boolean         // 정답 (O/X)
  score: number           // 획득 점수
}
```

## 🔗 라우팅

```javascript
// routes.js
[
  { path: '/', name: 'landing', component: FigmaLandingPage },
  { path: '/category/:category', name: 'category', component: FigmaCategoryPage },
  { path: '/login', name: 'login', component: FigmaLoginPage },
  { path: '/signup', name: 'signup', component: FigmaSignupPage },
  { path: '/coming-soon', name: 'coming-soon', component: FigmaComingSoonPage },
  { path: '/:catchAll(.*)*', redirect: '/' }
]
```

## 🧩 주요 컴포넌트 설명

### FigmaHeader.vue

- **역할**: 전역 네비게이션 헤더
- **기능**:
  - 로고 표시
  - 5개 카테고리 버튼
  - 로그인/회원가입 버튼
  - 모바일 메뉴
- **반응형**: 768px 이하에서 햄버거 메뉴

### FigmaHeroSection.vue

- **역할**: 메인 페이지 히어로 섹션
- **기능**:
  - 자동 슬라이드 캐러셀 (4초 간격)
  - 공지사항/뉴스 이미지 표시
  - 좌우 화살표 네비게이션
- **컴포넌트**: Quasar Q-Carousel

### FigmaServiceCards.vue

- **역할**: 5가지 정책 카테고리 카드 그리드
- **기능**:
  - 그라디언트 배경 카드
  - 카테고리별 아이콘
  - 클릭 시 카테고리 페이지 이동
  - "인기" 뱃지 (참여 카테고리)
- **레이아웃**: Grid (1열 → 2열 → 3열)

### FigmaSidebar.vue

- **역할**: 데스크톱 사이드바 네비게이션
- **기능**:
  - 청년정책카페 바로가기 (준비중 페이지)
  - 5개 카테고리 퀵 링크
  - 안내 카드
- **반응형**: 데스크톱 전용 (gt-md)
- **위치**: Sticky (상단 80px)

### FigmaFooter.vue

- **역할**: 전역 푸터
- **기능**:
  - 사이트 링크 (소개, 이용약관, 개인정보처리방침)
  - 언어 선택 (한국어, English)
  - 고객센터 버튼
  - 저작권 표시

## ⚠️ 제한 사항 및 주의 사항

### 현재 미구현 기능

1. **실제 인증 없음**: 로그인/회원가입은 더미 핸들러만 있음
2. **데이터베이스 연동 없음**: 모든 데이터는 더미 데이터
3. **영상 재생 없음**: YouTube URL은 플레이스홀더
4. **퀴즈 제출 없음**: 퀴즈는 UI만 구현
5. **청년정책카페 미구현**: 준비중 페이지로 이동

### 향후 개발 예정

- [ ] Supabase 인증 연동
- [ ] 실제 정책 데이터 API 연동
- [ ] 사용자 학습 진도 저장
- [ ] 퀴즈 결과 저장 및 통계
- [ ] 청년정책카페 (커뮤니티) 구현
- [ ] 관리자 페이지

## 📝 개발 가이드

### 새 페이지 추가하기

1. `src/pages/` 에 새 Vue 파일 생성
2. `src/router/routes.js` 에 라우트 추가
3. 필요시 `src/components/figma/` 에 컴포넌트 생성

### 새 카테고리 추가하기

1. `src/data/policyData.ts` 에 정책 데이터 추가
2. `src/data/learningData.ts` 에 학습 콘텐츠 추가
3. `FigmaServiceCards.vue` 의 `cards` 배열에 카드 추가
4. `FigmaSidebar.vue` 의 `categories` 배열에 추가

### 스타일 수정하기

- **글로벌 스타일**: `src/css/app.scss`
- **유틸리티 클래스**: `src/css/figma.css`
- **컴포넌트 스타일**: 각 `.vue` 파일의 `<style scoped>` 섹션

### Git 커밋 규칙

```
Feat: 새로운 기능 추가
Fix: 버그 수정
Update: 기능 개선
Refactor: 코드 리팩토링
Docs: 문서 수정
Style: 스타일 변경 (코드 포맷팅)
Test: 테스트 코드
Chore: 기타 작업
```

## 🐛 트러블슈팅

### Q-Page 에러

**문제**: `QPage needs to be a deep child of QLayout`

**해결**: QLayout 없이 사용하므로 `<q-page>` 대신 `<div>` 사용

### 스타일이 안 먹힐 때

**문제**: Tailwind CSS 클래스가 작동하지 않음

**해결**: `src/css/figma.css` 의 커스텀 유틸리티 클래스 사용

### 이미지가 안 보일 때

**문제**: 이미지 경로 오류

**해결**: 절대 경로 사용 `/src/assets/images/파일명.png`

## 📞 문의

- **개발자**: Developer
- **이메일**: developer@example.com
- **프로젝트 기간**: 2026년 1월

## 📄 라이선스

이 프로젝트는 비공개 프로젝트입니다.

---

**마지막 업데이트**: 2026-01-22
