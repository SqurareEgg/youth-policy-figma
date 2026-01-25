# Supabase 통합 완료 가이드

## ✅ 완료된 작업

### 1. Supabase 설정
- [x] Supabase 클라이언트 라이브러리 설치 (`@supabase/supabase-js`)
- [x] 환경 변수 설정 (`.env.example` 생성)
- [x] Supabase 클라이언트 초기화 (`src/lib/supabase.ts`)
- [x] TypeScript 타입 정의 (`src/types/supabase.ts`)

### 2. Composables 구현
- [x] `useAuth.ts` - 인증 관련 (로그인, 회원가입, 로그아웃)
- [x] `useCategories.ts` - 카테고리 데이터
- [x] `usePolicies.ts` - 정책 데이터 및 북마크
- [x] `useLearning.ts` - 영상, 퀴즈, Q&A, 학습 진도율

### 3. 페이지 연동
- [x] 로그인 페이지 (`FigmaLoginPage.vue`)
- [x] 회원가입 페이지 (`FigmaSignupPage.vue`)
- [x] 카테고리 상세 페이지 (`FigmaCategoryPage.vue`)
- [x] 메인 페이지 서비스 카드 (`FigmaServiceCards.vue`)

---

## 🚀 시작하기

### 1단계: Supabase 프로젝트 설정

**[SUPABASE_SETUP.md](./SUPABASE_SETUP.md)** 파일을 참고하여 다음을 완료하세요:

1. Supabase 프로젝트 생성
2. SQL Editor에서 스키마 실행:
   - `supabase-schema.sql` 실행
   - `supabase-seed-data.sql` 실행
3. API 키 복사

### 2단계: 환경 변수 설정

프로젝트 루트에 `.env` 파일을 생성하고 다음을 입력하세요:

```env
# Supabase Configuration
VITE_SUPABASE_URL=https://xxxxxxxxxxxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

`.env.example` 파일을 참고하세요.

### 3단계: 개발 서버 실행

```bash
npm install
npm run dev
```

브라우저에서 http://localhost:9003 접속

---

## 📁 프로젝트 구조

```
src/
├── lib/
│   └── supabase.ts              # Supabase 클라이언트
├── types/
│   └── supabase.ts              # 데이터베이스 타입 정의
├── composables/
│   ├── useAuth.ts               # 인증
│   ├── useCategories.ts         # 카테고리
│   ├── usePolicies.ts           # 정책
│   └── useLearning.ts           # 학습 콘텐츠
├── pages/
│   ├── FigmaLoginPage.vue       # 로그인 (Supabase Auth 연동)
│   ├── FigmaSignupPage.vue      # 회원가입 (Supabase Auth 연동)
│   └── FigmaCategoryPage.vue    # 카테고리 상세 (실제 데이터)
└── components/
    └── figma/
        └── FigmaServiceCards.vue # 서비스 카드 (실제 데이터)
```

---

## 🔧 주요 기능 사용법

### 1. 인증 (useAuth)

```vue
<script setup>
import { useAuth } from '@/composables/useAuth'

const { user, signIn, signUp, signOut, isAuthenticated } = useAuth()

// 로그인
const login = async () => {
  const result = await signIn('user@example.com', 'password123')
  if (result.success) {
    console.log('로그인 성공!')
  }
}

// 회원가입
const signup = async () => {
  const result = await signUp(
    'user@example.com',
    'password123',
    '홍길동',
    '2000-01-01',
    '010-1234-5678',
    { terms: true, privacy: true, marketing: false }
  )
}

// 로그아웃
const logout = async () => {
  await signOut()
}
</script>
```

### 2. 카테고리 데이터 (useCategories)

```vue
<script setup>
import { onMounted } from 'vue'
import { useCategories } from '@/composables/useCategories'

const { categories, fetchCategories } = useCategories()

onMounted(async () => {
  await fetchCategories()
  console.log(categories.value) // 5개 카테고리
})
</script>
```

### 3. 정책 데이터 (usePolicies)

```vue
<script setup>
import { usePolicies } from '@/composables/usePolicies'

const { policies, fetchPoliciesByCategory } = usePolicies()

// 일자리 카테고리 정책 가져오기
const loadPolicies = async () => {
  await fetchPoliciesByCategory('job')
  console.log(policies.value)
}
</script>
```

### 4. 학습 콘텐츠 (useLearning)

```vue
<script setup>
import { useLearning } from '@/composables/useLearning'
import { useAuth } from '@/composables/useAuth'

const { user } = useAuth()
const {
  videos,
  quizzes,
  qnaList,
  fetchVideosByCategory,
  fetchQuizzesByCategory,
  fetchQnAByCategory,
  fetchLearningProgress,
  completeVideo
} = useLearning()

// 영상 가져오기
const loadVideos = async (categoryId) => {
  await fetchVideosByCategory(categoryId, user.value?.id)
}

// 영상 완료 처리
const markVideoComplete = async (videoId) => {
  await completeVideo(user.value.id, videoId)
}

// 학습 진도율 조회
const getProgress = async (categoryId) => {
  const progress = await fetchLearningProgress(user.value.id, categoryId)
  console.log(`이수율: ${progress?.completion_percentage}%`)
}
</script>
```

---

## 🎯 페이지별 연동 상태

| 페이지 | 연동 상태 | 기능 |
|--------|----------|------|
| 로그인 | ✅ 완료 | Supabase Auth 로그인 |
| 회원가입 | ✅ 완료 | Supabase Auth 회원가입 + 프로필 생성 |
| 메인 (랜딩) | ✅ 완료 | 실제 카테고리 데이터 표시 |
| 카테고리 상세 | ✅ 완료 | 정책, Q&A, 영상, 퀴즈, 이수율 표시 |
| 준비중 페이지 | - | 더미 페이지 (연동 불필요) |

---

## 📊 데이터 흐름

### 회원가입 플로우

```
1. 사용자가 회원가입 폼 제출
   ↓
2. useAuth.signUp() 호출
   ↓
3. Supabase Auth에 사용자 생성
   ↓
4. 트리거로 profiles 테이블에 자동 생성
   ↓
5. 프로필 정보 업데이트 (이름, 생년월일, 전화번호, 약관 동의)
   ↓
6. 로그인 페이지로 리다이렉트
```

### 카테고리 상세 페이지 로딩

```
1. 페이지 마운트
   ↓
2. 카테고리 정보 가져오기 (getCategoryBySlug)
   ↓
3. 병렬로 데이터 가져오기:
   - 정책 목록 (fetchPoliciesByCategory)
   - Q&A (fetchQnAByCategory)
   - 영상 목록 (fetchVideosByCategory)
   - 퀴즈 목록 (fetchQuizzesByCategory)
   - 학습 진도율 (fetchLearningProgress)
   ↓
4. 화면에 데이터 표시
```

### 영상 완료 처리

```
1. 사용자가 영상 시청 완료
   ↓
2. completeVideo() 호출
   ↓
3. user_video_progress 테이블에 completed=true 저장
   ↓
4. user_learning_progress 뷰가 자동으로 이수율 재계산
   ↓
5. 화면에 업데이트된 이수율 표시
```

---

## 🔐 보안 (Row Level Security)

Supabase에서 RLS(Row Level Security)가 활성화되어 있습니다:

### 공개 데이터 (모두 조회 가능)
- `categories` - 카테고리
- `policies` - 정책
- `policy_details` - 정책 상세
- `videos` - 영상
- `quizzes` - 퀴즈
- `quiz_questions` - 퀴즈 문제
- `qna` - Q&A
- `community_posts` - 커뮤니티 게시글
- `comments` - 댓글

### 사용자 전용 데이터 (본인만 접근)
- `profiles` - 사용자는 본인 프로필만 조회/수정
- `user_video_progress` - 본인 영상 진도만 조회/수정
- `user_quiz_results` - 본인 퀴즈 결과만 조회/생성
- `user_bookmarks` - 본인 북마크만 조회/추가/삭제

### 인증 필요 작업
- 게시글/댓글 작성: 로그인 필요
- 좋아요: 로그인 필요
- 영상 진도 저장: 로그인 필요
- 퀴즈 제출: 로그인 필요

---

## 🧪 테스트 방법

### 1. 회원가입 테스트

1. http://localhost:9003/signup 접속
2. 폼 작성:
   - 이메일: test@example.com
   - 비밀번호: password123 (8자 이상)
   - 이름: 테스터
   - 생년월일: 2000-01-01
   - 전화번호: 010-1234-5678
   - 약관 동의 체크
3. "회원가입" 버튼 클릭
4. ✅ "회원가입 성공!" 알림 확인
5. 로그인 페이지로 자동 이동

### 2. 로그인 테스트

1. http://localhost:9003/login 접속
2. 방금 가입한 계정으로 로그인
3. ✅ "로그인 성공!" 알림 확인
4. 메인 페이지로 이동

### 3. 카테고리 데이터 확인

1. 메인 페이지에서 5개 카테고리 카드 확인
   - ✅ 일자리, 주거, 교육, 금융･복지･문화, 참여
2. "일자리" 카드 클릭
3. 카테고리 상세 페이지에서 확인:
   - ✅ 정책 목록 (2개)
   - ✅ Q&A (5개)
   - ✅ 학습영상 (3개)
   - ✅ OX퀴즈 (2개)
   - ✅ 이수율 (로그인 시)

### 4. Supabase 데이터 확인

1. Supabase Dashboard 접속
2. Table Editor에서 `profiles` 테이블 확인
3. ✅ 방금 가입한 사용자 정보 확인
4. `categories` 테이블에서 5개 카테고리 확인

---

## 🐛 문제 해결

### Q1. "Supabase URL과 Anon Key가 설정되지 않았습니다" 에러

**원인**: `.env` 파일이 없거나 환경 변수가 잘못 설정됨

**해결**:
1. 프로젝트 루트에 `.env` 파일 생성
2. `.env.example` 참고하여 환경 변수 입력
3. 개발 서버 재시작 (`npm run dev`)

### Q2. 로그인/회원가입 시 에러

**원인**: Supabase 프로젝트 설정 미완료

**해결**:
1. `SUPABASE_SETUP.md` 참고하여 Supabase 프로젝트 생성
2. `supabase-schema.sql` 실행 확인
3. API 키가 올바른지 확인

### Q3. 카테고리 데이터가 안 보임

**원인**: `supabase-seed-data.sql` 미실행

**해결**:
1. Supabase Dashboard > SQL Editor
2. `supabase-seed-data.sql` 내용 복사 붙여넣기
3. "Run" 버튼 클릭
4. Table Editor에서 `categories` 테이블 확인

### Q4. "Invalid API key" 에러

**원인**: 잘못된 Anon Key 사용

**해결**:
1. Supabase Dashboard > Settings > API
2. **anon public** 키 복사 (service_role 아님!)
3. `.env` 파일의 `VITE_SUPABASE_ANON_KEY` 업데이트
4. 개발 서버 재시작

---

## 📝 다음 단계

### 구현 예정 기능

1. **영상 재생 페이지**
   - YouTube 영상 임베드
   - 시청 진도 저장 (이어보기)
   - 완료 처리

2. **퀴즈 페이지**
   - 문제 출제
   - 답안 제출
   - 점수 계산 및 저장
   - 결과 표시

3. **정책 상세 페이지**
   - 정책 상세 내용 표시
   - 북마크 기능

4. **커뮤니티 (청년정책카페)**
   - 게시글 목록/작성/수정/삭제
   - 댓글 기능
   - 좋아요 기능

5. **마이페이지**
   - 프로필 수정
   - 북마크한 정책 목록
   - 퀴즈 응시 기록
   - 학습 진도 현황

---

## 📚 참고 문서

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) - 데이터베이스 스키마 상세 설명
- [COMPLETION_RATE_GUIDE.md](./COMPLETION_RATE_GUIDE.md) - 이수율 계산 가이드
- [SUPABASE_SETUP.md](./SUPABASE_SETUP.md) - Supabase 프로젝트 설정 가이드
- [README.md](./README.md) - 프로젝트 전체 개요
- [DEVELOPMENT_GUIDE.md](./DEVELOPMENT_GUIDE.md) - 개발 가이드

---

## ✅ 체크리스트

### Supabase 설정
- [ ] Supabase 프로젝트 생성
- [ ] `supabase-schema.sql` 실행
- [ ] `supabase-seed-data.sql` 실행
- [ ] API 키 복사
- [ ] `.env` 파일 생성

### 개발 환경
- [ ] `npm install` 실행
- [ ] `.env` 환경 변수 설정
- [ ] `npm run dev` 실행
- [ ] 브라우저에서 접속 확인

### 기능 테스트
- [ ] 회원가입 성공
- [ ] 로그인 성공
- [ ] 메인 페이지에서 5개 카테고리 표시
- [ ] 카테고리 클릭 시 상세 페이지 표시
- [ ] 정책, Q&A, 영상, 퀴즈 데이터 표시
- [ ] 로그인 시 이수율 표시

---

## 🎉 완료!

Supabase 통합이 완료되었습니다. 이제 실제 데이터로 동작하는 청년있슈 플랫폼을 사용할 수 있습니다!

추가 기능 구현이나 문제가 있으면 언제든지 문의하세요.
