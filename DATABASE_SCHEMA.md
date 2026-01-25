# 데이터베이스 스키마 설계 문서

## 목차
1. [개요](#개요)
2. [ERD 다이어그램](#erd-다이어그램)
3. [테이블 상세 설명](#테이블-상세-설명)
4. [보안 정책 (RLS)](#보안-정책-rls)
5. [성능 최적화](#성능-최적화)
6. [사용 예시](#사용-예시)

---

## 개요

### 기술 스택
- **데이터베이스**: PostgreSQL (Supabase)
- **인증**: Supabase Auth
- **보안**: Row Level Security (RLS)
- **확장**: UUID, JSONB

### 설계 원칙
1. **정규화**: 3NF까지 정규화하여 데이터 중복 최소화
2. **확장성**: 향후 기능 추가를 고려한 유연한 구조
3. **보안**: RLS를 통한 행 단위 접근 제어
4. **성능**: 적절한 인덱스와 뷰를 통한 쿼리 최적화
5. **사용자 경험**: 자동 타임스탬프, 트리거를 통한 데이터 일관성 유지

---

## ERD 다이어그램

```
┌─────────────────┐
│  auth.users     │ (Supabase Auth)
│  - id (PK)      │
│  - email        │
└────────┬────────┘
         │ 1:1
         │
┌────────▼────────┐
│  profiles       │ (사용자 프로필)
│  - id (PK, FK)  │
│  - name         │
│  - birth_date   │
│  - phone        │
└────────┬────────┘
         │
         │ 1:N
         ├──────────────┬─────────────┬─────────────┬──────────────┐
         │              │             │             │              │
┌────────▼────────┐ ┌───▼──────┐ ┌──▼──────┐ ┌────▼──────┐ ┌─────▼─────┐
│ user_video_     │ │ user_    │ │ user_   │ │community_ │ │ comments  │
│ progress        │ │ quiz_    │ │ book-   │ │ posts     │ │           │
│                 │ │ results  │ │ marks   │ │           │ │           │
└─────────────────┘ └──────────┘ └─────────┘ └───────────┘ └───────────┘

┌─────────────────┐
│  categories     │ (정책 카테고리)
│  - id (PK)      │
│  - name         │
│  - slug         │
│  - icon         │
└────────┬────────┘
         │ 1:N
         ├──────────────┬─────────────┬─────────────┐
         │              │             │             │
┌────────▼────────┐ ┌───▼──────┐ ┌──▼──────┐ ┌────▼──────┐
│  policies       │ │ videos   │ │ quizzes │ │ qna       │
│  - id (PK)      │ │          │ │         │ │           │
│  - title        │ │          │ │         │ │           │
└────────┬────────┘ └──────────┘ └────┬────┘ └───────────┘
         │ 1:N                         │ 1:N
         │                             │
┌────────▼────────┐            ┌───────▼──────────┐
│ policy_details  │            │ quiz_questions   │
│  - id (PK)      │            │  - id (PK)       │
│  - policy_id    │            │  - quiz_id       │
└─────────────────┘            │  - question      │
                               │  - options       │
                               └──────────────────┘
```

---

## 테이블 상세 설명

### 1. profiles (사용자 프로필)

**목적**: Supabase Auth와 연동하여 사용자의 추가 정보를 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | UUID | PK, FK → auth.users | 사용자 고유 ID |
| email | TEXT | NOT NULL, UNIQUE | 이메일 주소 |
| name | TEXT | - | 사용자 이름 |
| birth_date | DATE | - | 생년월일 |
| phone | TEXT | - | 연락처 |
| terms_agreed | BOOLEAN | DEFAULT false | 이용약관 동의 여부 |
| privacy_agreed | BOOLEAN | DEFAULT false | 개인정보 처리방침 동의 |
| marketing_agreed | BOOLEAN | DEFAULT false | 마케팅 정보 수신 동의 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**특징**:
- `auth.users` 테이블과 1:1 관계
- 회원가입 시 트리거를 통해 자동 생성
- RLS: 사용자는 본인의 프로필만 조회/수정 가능

---

### 2. categories (정책 카테고리)

**목적**: 5개 정책 카테고리 정보 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 카테고리 ID |
| name | TEXT | NOT NULL, UNIQUE | 카테고리명 (일자리, 주거 등) |
| slug | TEXT | NOT NULL, UNIQUE | URL용 slug (job, housing 등) |
| icon | TEXT | NOT NULL | Lucide 아이콘 이름 |
| description | TEXT | - | 카테고리 설명 |
| display_order | INTEGER | DEFAULT 0 | 표시 순서 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |

**특징**:
- 5개 고정 카테고리 (일자리, 주거, 교육, 금융･복지･문화, 참여)
- `display_order`로 UI 표시 순서 제어
- RLS: 모든 사용자가 조회 가능

---

### 3. policies (정책)

**목적**: 각 카테고리별 정책 정보 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 정책 ID |
| category_id | INTEGER | FK → categories | 카테고리 ID |
| title | TEXT | NOT NULL | 정책 제목 |
| icon | TEXT | NOT NULL | Lucide 아이콘 이름 |
| image_url | TEXT | - | 정책 대표 이미지 URL |
| intro | TEXT | - | 정책 소개 텍스트 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**관계**:
- `categories` (N:1)
- `policy_details` (1:N)

**특징**:
- 카테고리 삭제 시 CASCADE로 함께 삭제
- RLS: 모든 사용자가 조회 가능

---

### 4. policy_details (정책 상세)

**목적**: 각 정책의 세부 내용을 여러 개 저장 (1:N)

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 상세 ID |
| policy_id | INTEGER | FK → policies | 정책 ID |
| title | TEXT | NOT NULL | 상세 항목 제목 |
| description | TEXT | NOT NULL | 상세 설명 |
| display_order | INTEGER | DEFAULT 0 | 표시 순서 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |

**관계**:
- `policies` (N:1)

**특징**:
- 하나의 정책에 여러 상세 항목 존재 가능
- 예: "첫 일자리 지원" 정책 → "민관 협업 채용", "국가 R&D 우대" 등

---

### 5. videos (학습 영상)

**목적**: 카테고리별 학습 영상 정보 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 영상 ID |
| category_id | INTEGER | FK → categories | 카테고리 ID |
| title | TEXT | NOT NULL | 영상 제목 |
| duration | TEXT | NOT NULL | 영상 길이 (MM:SS) |
| thumbnail_url | TEXT | - | 썸네일 이미지 URL |
| video_url | TEXT | - | 영상 URL (YouTube 등) |
| description | TEXT | - | 영상 설명 |
| display_order | INTEGER | DEFAULT 0 | 표시 순서 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**관계**:
- `categories` (N:1)
- `user_video_progress` (1:N)

**특징**:
- YouTube 등 외부 플랫폼 URL 저장
- 카테고리별로 여러 영상 존재

---

### 6. user_video_progress (사용자 영상 시청 진도)

**목적**: 사용자별 영상 시청 진도 및 완료 상태 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 진도 ID |
| user_id | UUID | FK → profiles | 사용자 ID |
| video_id | INTEGER | FK → videos | 영상 ID |
| completed | BOOLEAN | DEFAULT false | 완료 여부 |
| last_position | INTEGER | DEFAULT 0 | 마지막 재생 위치 (초) |
| completed_at | TIMESTAMP | - | 완료 일시 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**제약**:
- UNIQUE(user_id, video_id): 사용자당 영상당 하나의 진도만 존재

**특징**:
- 영상 시청 위치 저장으로 이어보기 가능
- RLS: 사용자는 본인의 진도만 조회/수정 가능

---

### 7. quizzes (퀴즈)

**목적**: 카테고리별 퀴즈 정보 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 퀴즈 ID |
| category_id | INTEGER | FK → categories | 카테고리 ID |
| title | TEXT | NOT NULL | 퀴즈 제목 |
| description | TEXT | - | 퀴즈 설명 |
| display_order | INTEGER | DEFAULT 0 | 표시 순서 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**관계**:
- `categories` (N:1)
- `quiz_questions` (1:N)

---

### 8. quiz_questions (퀴즈 문제)

**목적**: 각 퀴즈의 문제 및 선택지 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 문제 ID |
| quiz_id | INTEGER | FK → quizzes | 퀴즈 ID |
| question | TEXT | NOT NULL | 문제 내용 |
| options | JSONB | NOT NULL | 선택지 배열 |
| correct_answer | INTEGER | NOT NULL | 정답 인덱스 (0부터 시작) |
| explanation | TEXT | - | 정답 해설 |
| display_order | INTEGER | DEFAULT 0 | 표시 순서 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |

**JSONB 예시**:
```json
["만 18세~30세", "만 19세~34세", "만 20세~35세", "만 19세~39세"]
```

**특징**:
- JSONB를 사용하여 유연한 선택지 개수 지원
- 정답은 배열 인덱스로 저장 (0, 1, 2, 3...)

---

### 9. user_quiz_results (사용자 퀴즈 결과)

**목적**: 사용자별 퀴즈 응시 결과 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 결과 ID |
| user_id | UUID | FK → profiles | 사용자 ID |
| quiz_id | INTEGER | FK → quizzes | 퀴즈 ID |
| score | INTEGER | NOT NULL | 점수 (0-100) |
| total_questions | INTEGER | NOT NULL | 총 문제 수 |
| correct_answers | INTEGER | NOT NULL | 정답 개수 |
| answers | JSONB | - | 사용자 응답 |
| completed_at | TIMESTAMP | DEFAULT NOW() | 완료 일시 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |

**answers JSONB 예시**:
```json
{
  "1": 0,  // 문제 1번에 0번 선택지 선택
  "2": 2,  // 문제 2번에 2번 선택지 선택
  "3": 1
}
```

**특징**:
- 같은 퀴즈를 여러 번 응시 가능 (재응시)
- RLS: 사용자는 본인의 결과만 조회/생성 가능

---

### 10. qna (자주 묻는 질문)

**목적**: 카테고리별 FAQ 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | Q&A ID |
| category_id | INTEGER | FK → categories | 카테고리 ID |
| question | TEXT | NOT NULL | 질문 |
| answer | TEXT | NOT NULL | 답변 |
| display_order | INTEGER | DEFAULT 0 | 표시 순서 |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**특징**:
- 카테고리별로 여러 Q&A 존재
- 관리자가 직접 작성

---

### 11. user_bookmarks (사용자 북마크)

**목적**: 사용자가 저장한 정책 목록

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 북마크 ID |
| user_id | UUID | FK → profiles | 사용자 ID |
| policy_id | INTEGER | FK → policies | 정책 ID |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |

**제약**:
- UNIQUE(user_id, policy_id): 동일 정책 중복 저장 방지

**특징**:
- RLS: 사용자는 본인의 북마크만 조회/추가/삭제 가능

---

### 12. community_posts (커뮤니티 게시글)

**목적**: 청년정책카페 게시글 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 게시글 ID |
| user_id | UUID | FK → profiles | 작성자 ID |
| category_id | INTEGER | FK → categories | 관련 카테고리 (선택) |
| title | TEXT | NOT NULL | 제목 |
| content | TEXT | NOT NULL | 내용 |
| views | INTEGER | DEFAULT 0 | 조회수 |
| likes | INTEGER | DEFAULT 0 | 좋아요 수 |
| created_at | TIMESTAMP | DEFAULT NOW() | 작성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**관계**:
- `profiles` (N:1)
- `comments` (1:N)
- `post_likes` (1:N)

**특징**:
- `likes`는 트리거로 자동 계산
- RLS: 모든 사용자 조회 가능, 작성자만 수정/삭제 가능

---

### 13. comments (댓글)

**목적**: 게시글에 대한 댓글 저장

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 댓글 ID |
| post_id | INTEGER | FK → community_posts | 게시글 ID |
| user_id | UUID | FK → profiles | 작성자 ID |
| content | TEXT | NOT NULL | 댓글 내용 |
| likes | INTEGER | DEFAULT 0 | 좋아요 수 |
| created_at | TIMESTAMP | DEFAULT NOW() | 작성일시 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 수정일시 |

**관계**:
- `community_posts` (N:1)
- `comment_likes` (1:N)

**특징**:
- 대댓글 기능은 미구현 (향후 확장 가능)

---

### 14. post_likes (게시글 좋아요)

**목적**: 사용자의 게시글 좋아요 기록

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 좋아요 ID |
| post_id | INTEGER | FK → community_posts | 게시글 ID |
| user_id | UUID | FK → profiles | 사용자 ID |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |

**제약**:
- UNIQUE(post_id, user_id): 게시글당 사용자당 1번만 좋아요

**특징**:
- INSERT/DELETE 시 트리거로 `community_posts.likes` 자동 증감

---

### 15. comment_likes (댓글 좋아요)

**목적**: 사용자의 댓글 좋아요 기록

| 컬럼명 | 타입 | 제약 | 설명 |
|--------|------|------|------|
| id | SERIAL | PK | 좋아요 ID |
| comment_id | INTEGER | FK → comments | 댓글 ID |
| user_id | UUID | FK → profiles | 사용자 ID |
| created_at | TIMESTAMP | DEFAULT NOW() | 생성일시 |

**제약**:
- UNIQUE(comment_id, user_id): 댓글당 사용자당 1번만 좋아요

**특징**:
- INSERT/DELETE 시 트리거로 `comments.likes` 자동 증감

---

## 보안 정책 (RLS)

### Row Level Security 개요

Supabase는 PostgreSQL의 RLS 기능을 사용하여 행 단위로 접근을 제어합니다.

### 정책 요약

| 테이블 | SELECT | INSERT | UPDATE | DELETE |
|--------|--------|--------|--------|--------|
| profiles | 본인만 | ❌ (트리거) | 본인만 | ❌ |
| categories | 모두 | ❌ | ❌ | ❌ |
| policies | 모두 | ❌ | ❌ | ❌ |
| policy_details | 모두 | ❌ | ❌ | ❌ |
| videos | 모두 | ❌ | ❌ | ❌ |
| user_video_progress | 본인만 | 본인만 | 본인만 | ❌ |
| quizzes | 모두 | ❌ | ❌ | ❌ |
| quiz_questions | 모두 | ❌ | ❌ | ❌ |
| user_quiz_results | 본인만 | 본인만 | ❌ | ❌ |
| qna | 모두 | ❌ | ❌ | ❌ |
| user_bookmarks | 본인만 | 본인만 | ❌ | 본인만 |
| community_posts | 모두 | 인증된 사용자 | 작성자만 | 작성자만 |
| comments | 모두 | 인증된 사용자 | 작성자만 | 작성자만 |
| post_likes | 모두 | 인증된 사용자 | ❌ | 본인만 |
| comment_likes | 모두 | 인증된 사용자 | ❌ | 본인만 |

### 주요 정책 예시

```sql
-- 사용자는 본인의 프로필만 조회 가능
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

-- 인증된 사용자는 게시글 작성 가능
CREATE POLICY "Authenticated users can create posts"
  ON public.community_posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- 모든 사용자는 정책 조회 가능
CREATE POLICY "Policies are viewable by everyone"
  ON public.policies FOR SELECT
  USING (true);
```

---

## 성능 최적화

### 인덱스 전략

1. **Foreign Key 인덱스**
   - 모든 FK에 인덱스 생성으로 JOIN 성능 향상

2. **자주 조회되는 컬럼**
   - `community_posts.created_at`: 최신순 정렬
   - `user_video_progress.user_id`: 사용자별 진도 조회
   - `user_quiz_results.user_id`: 사용자별 결과 조회

3. **복합 인덱스 후보** (향후 필요시)
   - `(user_id, category_id)`: 카테고리별 사용자 데이터

### 뷰 (Views)

**1. policy_full_view**
```sql
-- 정책과 상세 정보를 한 번에 조회
SELECT * FROM policy_full_view WHERE category_slug = 'job';
```

**2. user_learning_progress**
```sql
-- 사용자의 카테고리별 학습 진도율 조회
SELECT * FROM user_learning_progress WHERE user_id = 'xxx';
```

**3. community_posts_with_user**
```sql
-- 게시글 목록에 작성자 정보 포함
SELECT * FROM community_posts_with_user ORDER BY created_at DESC;
```

---

## 사용 예시

### 1. 사용자 회원가입

```typescript
// Supabase Auth로 회원가입 (profiles 테이블 자동 생성)
const { data, error } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'password123'
})

// 추가 정보 업데이트
await supabase
  .from('profiles')
  .update({
    name: '홍길동',
    birth_date: '2000-01-01',
    phone: '010-1234-5678',
    terms_agreed: true,
    privacy_agreed: true
  })
  .eq('id', data.user.id)
```

### 2. 카테고리별 정책 조회

```typescript
// 일자리 카테고리의 모든 정책 조회
const { data: policies } = await supabase
  .from('policy_full_view')
  .select('*')
  .eq('category_slug', 'job')
```

### 3. 영상 시청 진도 저장

```typescript
// 영상 시청 진도 업데이트 (UPSERT)
await supabase
  .from('user_video_progress')
  .upsert({
    user_id: userId,
    video_id: videoId,
    last_position: 120, // 2분 지점
    completed: false
  })

// 영상 완료 처리
await supabase
  .from('user_video_progress')
  .update({
    completed: true,
    completed_at: new Date().toISOString()
  })
  .eq('user_id', userId)
  .eq('video_id', videoId)
```

### 4. 퀴즈 결과 저장

```typescript
// 퀴즈 응시 결과 저장
await supabase
  .from('user_quiz_results')
  .insert({
    user_id: userId,
    quiz_id: quizId,
    score: 80,
    total_questions: 10,
    correct_answers: 8,
    answers: {
      "1": 1,
      "2": 0,
      "3": 2,
      // ...
    }
  })
```

### 5. 정책 북마크 추가/삭제

```typescript
// 북마크 추가
await supabase
  .from('user_bookmarks')
  .insert({
    user_id: userId,
    policy_id: policyId
  })

// 북마크 삭제
await supabase
  .from('user_bookmarks')
  .delete()
  .eq('user_id', userId)
  .eq('policy_id', policyId)

// 사용자의 북마크 목록 조회
const { data: bookmarks } = await supabase
  .from('user_bookmarks')
  .select(`
    *,
    policies (
      id,
      title,
      icon,
      image_url,
      categories (name)
    )
  `)
  .eq('user_id', userId)
```

### 6. 커뮤니티 게시글 작성

```typescript
// 게시글 작성
await supabase
  .from('community_posts')
  .insert({
    user_id: userId,
    category_id: categoryId,
    title: '청년 일자리 정책 질문있어요',
    content: '첫 일자리 지원 정책 신청 방법 궁금합니다...'
  })

// 게시글 목록 조회 (작성자 정보 포함)
const { data: posts } = await supabase
  .from('community_posts_with_user')
  .select('*')
  .order('created_at', { ascending: false })
  .range(0, 9) // 10개씩 페이징
```

### 7. 댓글 작성 및 좋아요

```typescript
// 댓글 작성
await supabase
  .from('comments')
  .insert({
    post_id: postId,
    user_id: userId,
    content: '저도 궁금했던 내용이에요!'
  })

// 게시글 좋아요
await supabase
  .from('post_likes')
  .insert({
    post_id: postId,
    user_id: userId
  })

// 좋아요 취소
await supabase
  .from('post_likes')
  .delete()
  .eq('post_id', postId)
  .eq('user_id', userId)
```

### 8. 사용자 학습 진도율 조회 (영상 + 퀴즈)

```typescript
// 카테고리별 학습 진도율 조회
// 이수율 = (완료한 영상 + 완료한 퀴즈) / (전체 영상 + 전체 퀴즈) * 100
const { data: progress } = await supabase
  .from('user_learning_progress')
  .select('*')
  .eq('user_id', userId)

// 결과:
// [
//   {
//     category_name: '일자리',
//     total_videos: 3,
//     completed_videos: 2,
//     total_quizzes: 3,
//     completed_quizzes: 1,  // 60점 이상만 완료로 인정
//     total_items: 6,
//     completed_items: 3,
//     completion_percentage: 50.00
//   },
//   ...
// ]
```

---

## 추가 고려사항

### 1. 스토리지 (이미지/영상)

현재 스키마는 URL만 저장합니다. Supabase Storage를 사용하려면:

```typescript
// 이미지 업로드
const { data, error } = await supabase.storage
  .from('policy-images')
  .upload(`public/${filename}`, file)

// Public URL 가져오기
const { data: { publicUrl } } = supabase.storage
  .from('policy-images')
  .getPublicUrl(`public/${filename}`)

// DB에 URL 저장
await supabase
  .from('policies')
  .update({ image_url: publicUrl })
  .eq('id', policyId)
```

### 2. 실시간 구독 (Realtime)

커뮤니티 기능에 실시간 업데이트 추가:

```typescript
// 새 댓글 실시간 구독
const subscription = supabase
  .channel('public:comments')
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'comments',
    filter: `post_id=eq.${postId}`
  }, (payload) => {
    console.log('새 댓글:', payload.new)
  })
  .subscribe()
```

### 3. Full-text Search (전문 검색)

게시글/정책 검색 기능 추가:

```sql
-- Full-text search 인덱스 추가
CREATE INDEX idx_posts_search ON community_posts
  USING gin(to_tsvector('korean', title || ' ' || content));

-- 검색 쿼리
SELECT * FROM community_posts
WHERE to_tsvector('korean', title || ' ' || content)
      @@ to_tsquery('korean', '일자리 & 지원');
```

### 4. 관리자 기능

향후 관리자 페이지를 위한 확장:

```sql
-- profiles 테이블에 role 컬럼 추가
ALTER TABLE public.profiles ADD COLUMN role TEXT DEFAULT 'user';
-- 'user', 'admin', 'moderator'

-- 관리자만 정책 작성 가능하도록 RLS 수정
CREATE POLICY "Admins can insert policies"
  ON public.policies FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );
```

---

## 마이그레이션 가이드

### Supabase 프로젝트 설정

1. **Supabase 프로젝트 생성**
   - https://supabase.com 에서 프로젝트 생성
   - Database Password 설정

2. **SQL Editor에서 실행**
   ```sql
   -- 1. supabase-schema.sql 실행
   -- 2. supabase-seed-data.sql 실행
   ```

3. **환경 변수 설정**
   ```env
   VITE_SUPABASE_URL=your-project-url
   VITE_SUPABASE_ANON_KEY=your-anon-key
   ```

4. **Supabase Client 설정**
   ```typescript
   import { createClient } from '@supabase/supabase-js'

   export const supabase = createClient(
     import.meta.env.VITE_SUPABASE_URL,
     import.meta.env.VITE_SUPABASE_ANON_KEY
   )
   ```

---

## 데이터 모델 장점

### ✅ 정규화 (Normalization)
- 데이터 중복 최소화
- 일관성 유지 용이
- 업데이트 이상 방지

### ✅ 확장성 (Scalability)
- 새로운 카테고리 추가 용이
- 새로운 기능(게시판, 댓글 등) 추가 가능
- JSONB로 유연한 데이터 구조

### ✅ 보안 (Security)
- RLS로 행 단위 접근 제어
- 사용자는 본인 데이터만 접근
- SQL Injection 방지

### ✅ 성능 (Performance)
- 적절한 인덱스로 쿼리 최적화
- 뷰로 복잡한 JOIN 단순화
- 트리거로 자동 계산

### ✅ 유지보수성 (Maintainability)
- 명확한 테이블 관계
- 자동 타임스탬프
- 일관된 네이밍 규칙

---

## 카테고리 상세페이지 구조 및 이수율

### 📄 페이지 섹션 순서

1. **정책 목록** (Policy List)
   - 카테고리별 정책 리스트
   - 정책 상세 내용 조회
   - ⚠️ 이수율 계산에 포함되지 않음

2. **Q&A** (Frequently Asked Questions)
   - 정책에 대해 자주하는 질문
   - 카테고리별 FAQ 제공
   - ⚠️ 이수율 계산에 포함되지 않음

3. **학습영상** (Video Learning)
   - 카테고리별 학습 영상
   - 시청 진도 저장 (이어보기)
   - ✅ 이수율 계산에 포함 (완료 시)

4. **OX퀴즈** (Quiz)
   - 학습 이해도 체크 퀴즈
   - 4지선다 또는 O/X 문제
   - ✅ 이수율 계산에 포함 (60점 이상 시)

---

### 📊 이수율 계산 방식

```
이수율 = (완료한 영상 수 + 완료한 퀴즈 수) / (전체 영상 수 + 전체 퀴즈 수) × 100
```

#### 완료 조건

| 항목 | 완료 조건 | 테이블 |
|------|----------|--------|
| 영상 | `completed = true` | `user_video_progress` |
| 퀴즈 | `score >= 60` (60점 이상) | `user_quiz_results` |
| 정책 | ❌ 이수율과 무관 | - |
| Q&A | ❌ 이수율과 무관 | - |

#### 계산 예시

```
카테고리: 일자리
- 전체 영상: 3개 → 완료: 2개
- 전체 퀴즈: 3개 → 완료: 1개 (60점 이상)
- 전체 정책: 2개 (이수율과 무관)
- 전체 Q&A: 5개 (이수율과 무관)

이수율 = (2 + 1) / (3 + 3) × 100 = 50%
```

#### 뷰 쿼리 결과

```typescript
const { data } = await supabase
  .from('user_learning_progress')
  .select('*')
  .eq('user_id', userId)
  .eq('category_id', 1)  // 일자리 카테고리

// 결과:
{
  user_id: "xxx",
  category_id: 1,
  category_name: "일자리",
  total_videos: 3,
  completed_videos: 2,
  total_quizzes: 3,
  completed_quizzes: 1,  // 60점 이상만 카운트
  total_items: 6,        // 3 + 3
  completed_items: 3,    // 2 + 1
  completion_percentage: 50.00
}
```

---

### 🎯 이수율 체크 로직

#### 1. 영상 완료 처리

```typescript
// 영상 시청 완료
await supabase
  .from('user_video_progress')
  .update({
    completed: true,
    completed_at: new Date().toISOString()
  })
  .eq('user_id', userId)
  .eq('video_id', videoId)

// ✅ 이수율에 즉시 반영됨
```

#### 2. 퀴즈 완료 처리

```typescript
// 퀴즈 결과 저장
const score = 80  // 10문제 중 8문제 정답
await supabase
  .from('user_quiz_results')
  .insert({
    user_id: userId,
    quiz_id: quizId,
    score: score,
    total_questions: 10,
    correct_answers: 8,
    answers: { /* ... */ }
  })

// ✅ 60점 이상이면 이수율에 반영됨
// ❌ 60점 미만이면 이수율에 반영 안됨
```

#### 3. 재도전 시 처리

```typescript
// 사용자가 같은 퀴즈를 여러 번 응시할 수 있음
// user_learning_progress 뷰는 최신 점수만 사용 (DISTINCT ON)

// 1차 시도: 50점 (실패) → 이수율 0%
// 2차 시도: 70점 (성공) → 이수율에 반영
// 3차 시도: 90점 (성공) → 이수율에 반영 (최신 점수 사용)
```

---

### 🔄 실시간 이수율 업데이트

```typescript
// 실시간 이수율 조회 (영상 완료 or 퀴즈 완료 후)
const getCompletionRate = async (userId: string, categoryId: number) => {
  const { data } = await supabase
    .from('user_learning_progress')
    .select('completion_percentage')
    .eq('user_id', userId)
    .eq('category_id', categoryId)
    .single()

  return data?.completion_percentage || 0
}

// 영상 완료 후 이수율 업데이트
await completeVideo(userId, videoId)
const newRate = await getCompletionRate(userId, categoryId)
console.log(`이수율: ${newRate}%`)  // 예: 이수율: 50%
```
