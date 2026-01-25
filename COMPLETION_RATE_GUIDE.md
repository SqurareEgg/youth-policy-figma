# 이수율 계산 가이드

## 📋 카테고리 상세페이지 구조

### 섹션 순서 및 이수율 포함 여부

| 순서 | 섹션 | 설명 | 이수율 포함 |
|------|------|------|------------|
| 1 | 정책 목록 | 카테고리별 정책 리스트 | ❌ 아니오 |
| 2 | Q&A | 정책에 대해 자주하는 질문 | ❌ 아니오 |
| 3 | 학습영상 | 카테고리별 학습 영상 | ✅ 예 |
| 4 | OX퀴즈 | 학습 이해도 체크 퀴즈 | ✅ 예 |

---

## 🎯 이수율 계산 공식

```
이수율 = (완료한 영상 수 + 완료한 퀴즈 수) / (전체 영상 수 + 전체 퀴즈 수) × 100
```

### 완료 기준

1. **영상 완료 기준**
   - `user_video_progress.completed = true`
   - 영상을 끝까지 시청했을 때

2. **퀴즈 완료 기준**
   - `user_quiz_results.score >= 60`
   - 60점 이상 획득했을 때
   - 재도전 시 최신 점수 기준

---

## 📊 계산 예시

### 예시 1: 일자리 카테고리

```
📌 콘텐츠 현황
- 정책 목록: 2개 (첫 일자리 지원, 다시 서기 지원)
- Q&A: 5개
- 학습영상: 3개
- OX퀴즈: 3개

🎓 사용자 학습 현황
- 완료한 영상: 2개 (1번, 2번 영상 완료)
- 완료한 퀴즈: 1개 (1번 퀴즈 80점)

📈 이수율 계산
전체 항목 = 3(영상) + 3(퀴즈) = 6개
완료 항목 = 2(영상) + 1(퀴즈) = 3개
이수율 = 3 / 6 × 100 = 50%
```

### 예시 2: 주거 카테고리

```
📌 콘텐츠 현황
- 정책 목록: 1개 (청년 주거 지원)
- Q&A: 2개
- 학습영상: 3개
- OX퀴즈: 1개

🎓 사용자 학습 현황
- 완료한 영상: 0개
- 완료한 퀴즈: 0개

📈 이수율 계산
전체 항목 = 3(영상) + 1(퀴즈) = 4개
완료 항목 = 0(영상) + 0(퀴즈) = 0개
이수율 = 0 / 4 × 100 = 0%
```

### 예시 3: 교육 카테고리 (100% 완료)

```
📌 콘텐츠 현황
- 정책 목록: 1개 (청년 교육 지원)
- Q&A: 2개
- 학습영상: 3개
- OX퀴즈: 1개

🎓 사용자 학습 현황
- 완료한 영상: 3개 (모든 영상 완료)
- 완료한 퀴즈: 1개 (90점)

📈 이수율 계산
전체 항목 = 3(영상) + 1(퀴즈) = 4개
완료 항목 = 3(영상) + 1(퀴즈) = 4개
이수율 = 4 / 4 × 100 = 100%
```

---

## 🔄 퀴즈 재도전 시나리오

### 시나리오: 점수가 올라가는 경우

```
1차 시도: 50점 → ❌ 완료 아님 (60점 미만)
   이수율: 0%

2차 시도: 70점 → ✅ 완료 (60점 이상)
   이수율: 50% (퀴즈 1개 완료로 카운트)

3차 시도: 90점 → ✅ 완료 (최신 점수 사용)
   이수율: 50% (여전히 1개 완료)
```

### 시나리오: 점수가 떨어지는 경우

```
1차 시도: 80점 → ✅ 완료
   이수율: 50%

2차 시도: 40점 → ❌ 완료 해제됨 (최신 점수 60점 미만)
   이수율: 0% (퀴즈 완료 0개)
```

**⚠️ 주의**: 재도전 시 최신 점수만 반영되므로, 점수가 떨어지면 완료가 취소될 수 있습니다.

---

## 🗄️ 데이터베이스 쿼리

### 이수율 조회 (user_learning_progress 뷰 사용)

```typescript
// 특정 사용자의 카테고리별 이수율 조회
const { data } = await supabase
  .from('user_learning_progress')
  .select('*')
  .eq('user_id', userId)

// 결과 예시:
[
  {
    user_id: "user-uuid",
    category_id: 1,
    category_name: "일자리",
    total_videos: 3,
    completed_videos: 2,
    total_quizzes: 3,
    completed_quizzes: 1,
    total_items: 6,
    completed_items: 3,
    completion_percentage: 50.00
  },
  {
    user_id: "user-uuid",
    category_id: 2,
    category_name: "주거",
    total_videos: 3,
    completed_videos: 0,
    total_quizzes: 1,
    completed_quizzes: 0,
    total_items: 4,
    completed_items: 0,
    completion_percentage: 0.00
  }
]
```

### 특정 카테고리의 이수율만 조회

```typescript
const { data } = await supabase
  .from('user_learning_progress')
  .select('completion_percentage')
  .eq('user_id', userId)
  .eq('category_id', 1)  // 일자리 카테고리
  .single()

console.log(`이수율: ${data?.completion_percentage}%`)
```

---

## 💻 프론트엔드 구현 예시

### 1. 카테고리 상세페이지

```vue
<template>
  <div>
    <!-- 헤더: 이수율 표시 -->
    <div>
      <h1>{{ category }} 정책</h1>
      <div>전체 이수율: {{ completionRate }}%</div>
      <q-linear-progress :value="completionRate / 100" />
    </div>

    <!-- 1. 정책 목록 (이수율 무관) -->
    <section>
      <h2>정책 목록</h2>
      <PolicyCard v-for="policy in policies" :key="policy.id" />
    </section>

    <!-- 2. Q&A (이수율 무관) -->
    <section>
      <h2>Q&A</h2>
      <QnAItem v-for="qna in qnaList" :key="qna.id" />
    </section>

    <!-- 3. 학습영상 (이수율 포함) -->
    <section>
      <h2>학습영상</h2>
      <VideoCard
        v-for="video in videos"
        :key="video.id"
        @complete="handleVideoComplete"
      />
    </section>

    <!-- 4. OX퀴즈 (이수율 포함) -->
    <section>
      <h2>OX퀴즈</h2>
      <QuizCard
        v-for="quiz in quizzes"
        :key="quiz.id"
        @complete="handleQuizComplete"
      />
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { supabase } from '@/lib/supabase'

const userId = ref('')
const categoryId = ref(1)
const completionRate = ref(0)

const loadCompletionRate = async () => {
  const { data } = await supabase
    .from('user_learning_progress')
    .select('completion_percentage')
    .eq('user_id', userId.value)
    .eq('category_id', categoryId.value)
    .single()

  completionRate.value = data?.completion_percentage || 0
}

const handleVideoComplete = async () => {
  // 영상 완료 처리 후 이수율 새로고침
  await loadCompletionRate()
}

const handleQuizComplete = async (score: number) => {
  // 퀴즈 완료 처리 후 이수율 새로고침
  await loadCompletionRate()
}

onMounted(() => {
  loadCompletionRate()
})
</script>
```

### 2. 영상 완료 처리

```typescript
const completeVideo = async (userId: string, videoId: number) => {
  // 영상 완료 처리
  await supabase
    .from('user_video_progress')
    .upsert({
      user_id: userId,
      video_id: videoId,
      completed: true,
      completed_at: new Date().toISOString()
    })

  // 이수율 새로고침
  await refreshCompletionRate()
}
```

### 3. 퀴즈 완료 처리

```typescript
const submitQuiz = async (
  userId: string,
  quizId: number,
  answers: Record<number, number>
) => {
  // 정답 체크 및 점수 계산
  const { data: questions } = await supabase
    .from('quiz_questions')
    .select('*')
    .eq('quiz_id', quizId)

  let correctCount = 0
  questions?.forEach(q => {
    if (answers[q.id] === q.correct_answer) {
      correctCount++
    }
  })

  const totalQuestions = questions?.length || 0
  const score = Math.round((correctCount / totalQuestions) * 100)

  // 퀴즈 결과 저장
  await supabase
    .from('user_quiz_results')
    .insert({
      user_id: userId,
      quiz_id: quizId,
      score: score,
      total_questions: totalQuestions,
      correct_answers: correctCount,
      answers: answers
    })

  // 60점 이상이면 자동으로 이수율에 반영됨
  await refreshCompletionRate()

  return { score, passed: score >= 60 }
}
```

---

## ✅ 체크리스트

### 데이터베이스 설정
- [ ] `supabase-schema.sql` 실행
- [ ] `supabase-seed-data.sql` 실행
- [ ] `user_learning_progress` 뷰 정상 작동 확인

### 프론트엔드 구현
- [ ] 카테고리 상세페이지 섹션 순서 조정 (정책 → Q&A → 영상 → 퀴즈)
- [ ] Q&A 섹션 추가
- [ ] 이수율 표시 (user_learning_progress 뷰 사용)
- [ ] 영상 완료 처리 로직
- [ ] 퀴즈 완료 처리 로직 (60점 이상 체크)
- [ ] 이수율 실시간 업데이트

### 테스트
- [ ] 영상 완료 시 이수율 증가 확인
- [ ] 퀴즈 60점 이상 시 이수율 증가 확인
- [ ] 퀴즈 60점 미만 시 이수율 변화 없음 확인
- [ ] 퀴즈 재도전 시 최신 점수 반영 확인
- [ ] 정책 조회 시 이수율 변화 없음 확인
- [ ] Q&A 조회 시 이수율 변화 없음 확인

---

## 🤔 FAQ

### Q1. 정책을 모두 읽어도 이수율이 오르지 않는 이유는?
**A**: 정책 목록은 이수율 계산에 포함되지 않습니다. 이수율은 영상 시청과 퀴즈 완료만 체크합니다.

### Q2. 퀴즈에서 59점을 받았는데 왜 완료가 안 되나요?
**A**: 퀴즈 완료 기준은 60점 이상입니다. 재도전하여 60점 이상을 획득해야 이수율에 반영됩니다.

### Q3. 퀴즈를 재도전했는데 이수율이 줄어들었어요.
**A**: 퀴즈는 최신 점수만 반영됩니다. 재도전 시 60점 미만을 받으면 완료가 취소됩니다.

### Q4. 영상을 중간까지만 봐도 완료 처리되나요?
**A**: 아니오. 영상을 끝까지 시청해야 `completed = true`로 처리됩니다. 중간 위치는 `last_position`에 저장되어 이어보기가 가능합니다.

### Q5. Q&A는 왜 이수율에 포함되지 않나요?
**A**: Q&A는 참고 자료이며, 학습 이해도를 측정하는 항목이 아니기 때문에 이수율 계산에서 제외됩니다.

### Q6. 카테고리별로 이수율을 100% 달성하려면?
**A**: 해당 카테고리의 모든 영상을 시청하고, 모든 퀴즈에서 60점 이상을 획득해야 합니다.

---

## 📚 관련 문서

- [DATABASE_SCHEMA.md](./DATABASE_SCHEMA.md) - 전체 데이터베이스 스키마
- [supabase-schema.sql](./supabase-schema.sql) - SQL 스키마 파일
- [supabase-seed-data.sql](./supabase-seed-data.sql) - 초기 데이터
