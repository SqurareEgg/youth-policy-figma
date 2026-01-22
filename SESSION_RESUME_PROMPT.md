# Claude Code 세션 재개 프롬프트

> 다른 컴퓨터에서 이 프로젝트 작업을 재개할 때 사용할 프롬프트

**작성일**: 2026-01-22
**프로젝트**: 청년있슈 - Figma 프로토타입

---

## 🚀 빠른 시작 (다른 컴퓨터)

### 1단계: 프로젝트 클론

```bash
# 원하는 디렉토리로 이동
cd C:\WebWork  # 또는 원하는 경로

# GitHub에서 프로젝트 클론
git clone https://github.com/SqurareEgg/youth-policy-figma.git

# 프로젝트 디렉토리로 이동
cd youth-policy-figma

# 의존성 설치
npm install

# 개발 서버 실행
npm run dev
```

### 2단계: Claude Code에서 세션 시작

아래 프롬프트를 **그대로 복사**해서 Claude Code에 붙여넣으세요:

---

## 📝 Claude Code 세션 재개 프롬프트 (복사용)

```
안녕하세요! 청년있슈 프로젝트 작업을 재개하려고 합니다.

## 프로젝트 정보
- 프로젝트명: 청년있슈 (청년 정책 통합 플랫폼)
- 프로젝트 경로: [실제 클론한 경로를 입력하세요. 예: C:\WebWork\youth-policy-figma]
- GitHub 레포지토리: https://github.com/SqurareEgg/youth-policy-figma
- 배포 URL: [Vercel 배포 URL을 입력하세요]

## 기술 스택
- Vue 3 (Composition API)
- Quasar 2.14.0
- TypeScript
- Vite
- Vue Router

## 프로젝트 개요
청년을 위한 5가지 정책 카테고리(일자리, 주거, 교육, 금융･복지･문화, 참여)를 제공하는 Figma 디자인 기반 프론트엔드 프로토타입입니다.
현재 더미 데이터로 동작하며, 실제 DB 연동 및 인증 기능은 미구현 상태입니다.

## 현재 상태
✅ 완료된 기능:
- 5개 페이지 구현 (랜딩, 카테고리 상세, 로그인, 회원가입, 준비중)
- 5개 공통 컴포넌트 (Header, Footer, HeroSection, ServiceCards, Sidebar)
- 더미 데이터 구조 (정책 15개, 학습 콘텐츠)
- 반응형 디자인
- GitHub 업로드 완료
- Vercel 배포 완료

❌ 미완료/다음 작업:
- 실제 인증 시스템 (Supabase)
- 데이터베이스 연동
- 영상 재생 기능
- 퀴즈 제출 및 채점
- 학습 진도 저장
- 청년정책카페 (커뮤니티)
- 관리자 페이지

## 주요 문서 위치
프로젝트 루트에 다음 문서들이 있습니다:
- README.md - 프로젝트 전체 개요
- SCREEN_DESIGN.md - 화면 설계서 (5개 페이지 상세)
- PROJECT_STRUCTURE.md - 프로젝트 구조 및 아키텍처
- DEVELOPMENT_GUIDE.md - 개발 가이드 및 API 문서
- DEPLOYMENT.md - GitHub 및 Vercel 배포 가이드
- SESSION_RESUME_PROMPT.md - 이 문서

## 프로젝트 구조 요약
```
src/
├── components/figma/      # Header, Footer, HeroSection, ServiceCards, Sidebar
├── pages/                 # 5개 페이지 (Landing, Category, Login, Signup, ComingSoon)
├── data/                  # policyData.ts, learningData.ts (더미 데이터)
├── router/                # routes.js (라우트 정의)
└── css/                   # app.scss, figma.css (스타일)
```

## 데이터 구조
- **정책 데이터**: src/data/policyData.ts
  - 5개 카테고리 × 3개 정책 = 15개
  - 타입: Policy { id, title, icon, image, content, description }

- **학습 콘텐츠**: src/data/learningData.ts
  - getCategoryVideos(category): Video[] - 카테고리별 영상 3개
  - getCategoryQuizzes(category): Quiz[] - 카테고리별 퀴즈 5개
  - calculateCompletionRate(category): number - 진도율 (30~80%)

## 개발 서버
```bash
npm run dev
```
- 기본 포트: 9003 (충돌 시 자동으로 다음 포트)
- 자동 브라우저 열림: http://localhost:9003

## 지금 필요한 작업
[여기에 구체적인 작업 요청을 입력하세요. 예시:]
- 새 기능 추가
- 버그 수정
- UI 개선
- 문서 확인

먼저 DEVELOPMENT_GUIDE.md를 읽고 현재 프로젝트 상태를 파악해주세요.
```

---

## 📋 세션 재개 시 체크리스트

작업을 시작하기 전에 Claude Code에게 다음을 요청하세요:

1. **문서 확인 요청**:
   ```
   DEVELOPMENT_GUIDE.md와 README.md를 읽고 프로젝트 현황을 요약해줘
   ```

2. **최근 커밋 확인**:
   ```
   git log --oneline -10 을 실행해서 최근 작업 내역을 보여줘
   ```

3. **개발 서버 실행**:
   ```
   개발 서버를 실행해줘 (npm run dev)
   ```

4. **현재 상태 확인**:
   ```
   브라우저에서 http://localhost:9003 접속해서 잘 동작하는지 확인하고,
   5개 페이지 (/, /category/일자리, /login, /signup, /coming-soon)가 모두 작동하는지 체크해줘
   ```

---

## 🔧 자주 사용하는 작업 요청 예시

### 새 페이지 추가

```
src/pages/NewPage.vue 페이지를 만들어줘.
- Header, Footer 포함
- /new-page 경로로 라우팅
- [구체적인 요구사항]
```

### 새 카테고리 추가

```
"새카테고리"를 추가해줘:
1. src/data/policyData.ts에 정책 3개 추가
2. src/data/learningData.ts에 영상, 퀴즈 추가
3. FigmaServiceCards.vue에 카드 추가
4. FigmaSidebar.vue에 메뉴 추가
```

### 스타일 수정

```
[컴포넌트명]의 스타일을 수정해줘:
- [구체적인 스타일 요구사항]
- 반응형 (모바일, 태블릿, 데스크톱) 모두 고려
```

### 버그 수정

```
[페이지/컴포넌트]에서 [증상]이 발생해.
재현 방법:
1. [단계 1]
2. [단계 2]
에러 메시지: [에러 메시지]

수정해줘.
```

### 기능 추가

```
[기능명]을 구현해줘:
- 목적: [기능의 목적]
- 동작: [어떻게 동작해야 하는지]
- UI: [어떻게 보여야 하는지]
```

---

## 🎯 다음 우선순위 작업 (참고)

### 우선순위 높음 🔴

1. **Supabase 인증 연동**
   ```
   Supabase 프로젝트를 생성하고 인증 시스템을 연동해줘.
   - 로그인 페이지 실제 동작
   - 회원가입 페이지 실제 동작
   - 보호된 라우트 설정
   ```

2. **데이터베이스 연동**
   ```
   Supabase에 테이블을 만들고 더미 데이터를 마이그레이션해줘.
   - policies 테이블
   - learning_contents 테이블
   - user_progress 테이블
   ```

### 우선순위 중간 🟡

3. **학습 진도 저장**
   ```
   사용자별 학습 진도를 저장하고 표시하는 기능을 추가해줘.
   - 진도율 계산을 실제 데이터 기반으로
   - 완료한 영상/퀴즈 체크 표시
   ```

4. **영상 재생 기능**
   ```
   카테고리 페이지에서 영상을 실제로 재생할 수 있게 YouTube Embed를 연동해줘.
   ```

### 우선순위 낮음 🟢

5. **퀴즈 제출 및 채점**
   ```
   OX 퀴즈를 풀고 점수를 저장하는 기능을 구현해줘.
   ```

6. **청년정책카페 (커뮤니티)**
   ```
   준비중인 청년정책카페 페이지를 실제로 구현해줘.
   - 게시판 (CRUD)
   - 댓글 기능
   ```

---

## ⚠️ 중요 참고사항

### 스타일 작업 시

- Tailwind CSS는 설치되어 있지 않음
- `src/css/figma.css`의 커스텀 유틸리티 클래스 사용
- 또는 인라인 스타일 사용

### 컴포넌트 작업 시

- QLayout 없이 사용하므로 `<q-page>` 대신 `<div>` 사용
- Quasar 컴포넌트: Q-Card, Q-Btn, Q-Icon, Q-Carousel 등 활용

### 라우팅

- 모든 라우트는 `src/router/routes.js`에 정의
- Lazy Loading 사용: `() => import('../pages/...')`

### 이미지

- 절대 경로 사용: `/src/assets/images/파일명.png`
- 30개 PNG 파일이 있음

---

## 📞 도움말

문제가 생기면 Claude Code에게:

```
DEVELOPMENT_GUIDE.md의 트러블슈팅 섹션을 확인하고
[문제 상황]을 해결할 방법을 찾아줘
```

---

**행운을 빕니다!** 🚀

이 프롬프트는 언제든지 수정하고 개선할 수 있습니다.

**프로젝트 GitHub**: https://github.com/SqurareEgg/youth-policy-figma
**Vercel 배포**: [배포 완료 후 URL 추가]

**마지막 업데이트**: 2026-01-22
