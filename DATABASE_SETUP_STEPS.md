# 데이터베이스 설정 단계

영상과 퀴즈 기능이 제대로 작동하려면 Supabase에서 아래 SQL 스크립트를 순서대로 실행해야 합니다.

## 실행 순서

### 1. 불필요한 영상 삭제
**파일:** `remove-extra-videos.sql`
**목적:** 각 카테고리당 1개의 영상만 남기고 나머지 삭제

```bash
Supabase Dashboard → SQL Editor → 파일 내용 복사 후 실행
```

### 2. YouTube 영상 URL 업데이트
**파일:** `update-video-urls.sql`
**목적:** 각 카테고리의 영상에 실제 YouTube URL 설정

**주요 내용:**
- 일자리: https://www.youtube.com/watch?v=EkxH_hmnw1w
- 주거: https://www.youtube.com/watch?v=3EnF0AF_-XE
- 교육: https://www.youtube.com/watch?v=sVeKq4nvTsU
- 금융복지문화: https://www.youtube.com/watch?v=u0rvn9tsX2A
- 참여: https://www.youtube.com/watch?v=bztcdEUfgeA

```bash
Supabase Dashboard → SQL Editor → 파일 내용 복사 후 실행
```

### 3. 퀴즈 문제 추가
**파일:** `add-quiz-questions.sql`
**목적:** 각 퀴즈에 5개씩 총 30개의 문제 추가

```bash
Supabase Dashboard → SQL Editor → 파일 내용 복사 후 실행
```

## 확인 방법

### 영상 확인
```sql
SELECT
  v.id,
  c.name as category,
  v.title,
  v.video_url,
  v.display_order
FROM public.videos v
JOIN public.categories c ON v.category_id = c.id
ORDER BY v.category_id;
```

결과: 5개 카테고리당 1개씩, 총 5개의 영상이 있어야 함

### 퀴즈 문제 확인
```sql
SELECT
  q.id as quiz_id,
  q.title as quiz_title,
  COUNT(qq.id) as question_count
FROM public.quizzes q
LEFT JOIN public.quiz_questions qq ON q.id = qq.quiz_id
GROUP BY q.id, q.title
ORDER BY q.id;
```

결과: 6개 퀴즈 각각 5개씩, 총 30개의 문제가 있어야 함

## 실행 후 테스트

1. **영상 재생 테스트**
   - 각 카테고리 상세 페이지 접속
   - 영상 학습 섹션에서 "시청하기" 클릭
   - YouTube 플레이어가 정상적으로 로드되는지 확인
   - 재생 시 진행률이 실시간으로 업데이트되는지 확인
   - 80% 이상 시청 시 완료로 표시되는지 확인

2. **퀴즈 테스트**
   - 각 카테고리 상세 페이지의 Quiz 섹션에서 "시작하기" 클릭
   - 5개 문제가 순서대로 나오는지 확인
   - 답안 선택 및 제출 후 점수가 정상적으로 계산되는지 확인
   - 60점 이상 시 "합격", 미만 시 "불합격" 메시지 확인

## 문제 해결

### 영상이 재생되지 않는 경우
1. 브라우저 콘솔에서 에러 메시지 확인
2. YouTube URL이 정확한지 확인 (update-video-urls.sql 실행 여부)
3. YouTube 영상이 "삽입 허용" 설정되어 있는지 확인
4. 네트워크 연결 상태 확인

### 퀴즈 문제가 없는 경우
1. add-quiz-questions.sql이 정상적으로 실행되었는지 확인
2. 위의 "퀴즈 문제 확인" SQL로 데이터 존재 여부 확인
