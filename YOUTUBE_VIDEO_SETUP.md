# YouTube 영상 설정 가이드

## 1단계: YouTube에 영상 업로드

### 업로드 방법

1. https://studio.youtube.com 접속
2. 오른쪽 상단 **만들기** 버튼 > **동영상 업로드** 클릭
3. 파일 선택: `청년정책 최종영상` 폴더의 영상 선택

### 공개 설정

**⚠️ 중요**: 공개 범위를 **"일부 공개"**로 설정하세요!

- ✅ **일부 공개 (Unlisted)**: 링크를 아는 사람만 시청 가능 (권장)
- ❌ 비공개: 본인만 시청 가능 (사용자가 볼 수 없음)
- ❌ 공개: 누구나 검색 가능 (원하지 않는 경우)

### 제목 및 설명

**카테고리별 제목 예시**:
- 일자리: "청년 일자리 정책 완벽 가이드"
- 주거: "청년 주거 지원 정책 총정리"
- 교육: "청년 교육 지원 제도 안내"
- 금융·복지·문화: "청년 금융 복지 문화 정책 설명"
- 참여: "청년 참여 정책 소개"

---

## 2단계: YouTube URL 확인

업로드 완료 후:

1. 업로드한 영상 클릭
2. **공유** 버튼 클릭
3. URL 복사 (예: `https://www.youtube.com/watch?v=ABC123xyz`)

---

## 3단계: Supabase에 URL 업데이트

### Supabase Dashboard 접속

1. https://supabase.com 로그인
2. 프로젝트 선택: **kgfrjqjrhdqvrzcuqtaw**
3. **SQL Editor** 클릭

### SQL 실행

**일자리 카테고리 (category_id = 1)**:

```sql
-- 일자리 정책 영상 URL 업데이트
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=YOUR_VIDEO_ID_1',
  title = '청년 일자리 정책 완벽 가이드',
  description = '청년을 위한 일자리 정책을 자세히 안내합니다.',
  duration = '12:30'
WHERE category_id = 1 AND display_order = 1;

-- 추가 영상이 있다면
UPDATE public.videos
SET video_url = 'https://www.youtube.com/watch?v=YOUR_VIDEO_ID_2'
WHERE category_id = 1 AND display_order = 2;
```

**주거 카테고리 (category_id = 2)**:

```sql
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=YOUR_VIDEO_ID_3',
  title = '청년 주거 지원 정책 총정리',
  description = '청년을 위한 주거 정책을 자세히 안내합니다.',
  duration = '10:45'
WHERE category_id = 2 AND display_order = 1;
```

**교육 카테고리 (category_id = 3)**:

```sql
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=YOUR_VIDEO_ID_4',
  title = '청년 교육 지원 제도 안내',
  description = '청년을 위한 교육 정책을 자세히 안내합니다.',
  duration = '15:20'
WHERE category_id = 3 AND display_order = 1;
```

**금융·복지·문화 카테고리 (category_id = 4)**:

```sql
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=YOUR_VIDEO_ID_5',
  title = '청년 금융 복지 문화 정책 설명',
  description = '청년을 위한 금융, 복지, 문화 정책을 자세히 안내합니다.',
  duration = '14:00'
WHERE category_id = 4 AND display_order = 1;
```

**참여 카테고리 (category_id = 5)**:

```sql
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=YOUR_VIDEO_ID_6',
  title = '청년 참여 정책 소개',
  description = '청년을 위한 참여 정책을 자세히 안내합니다.',
  duration = '11:30'
WHERE category_id = 5 AND display_order = 1;
```

### 썸네일 URL (선택사항)

YouTube 썸네일을 사용하려면:

```sql
UPDATE public.videos
SET thumbnail_url = 'https://img.youtube.com/vi/YOUR_VIDEO_ID/maxresdefault.jpg'
WHERE id = 1;
```

썸네일 URL 형식:
- 고화질: `https://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg`
- 중간 화질: `https://img.youtube.com/vi/VIDEO_ID/hqdefault.jpg`
- 저화질: `https://img.youtube.com/vi/VIDEO_ID/default.jpg`

---

## 4단계: 테스트

### 로컬 테스트

1. http://localhost:9003/category/job 접속
2. 학습영상 섹션에서 영상 카드 클릭
3. YouTube 플레이어가 정상적으로 로드되는지 확인
4. 영상 재생 테스트
5. "완료로 표시" 버튼 클릭 테스트

### 배포 버전 테스트

1. https://youth-policy-figma.vercel.app/category/job
2. 동일하게 테스트

---

## 5단계: 영상별 매핑

현재 데이터베이스에 있는 영상:

| ID | 카테고리 | display_order | 제목 (변경 가능) |
|----|----------|---------------|------------------|
| 1  | 일자리   | 1             | 일자리 정책 이해하기 |
| 2  | 일자리   | 2             | 2026년 신규 일자리 정책 안내 |
| 3  | 일자리   | 3             | 일자리 혜택 신청 방법 |
| 4  | 주거     | 1             | 주거 정책 이해하기 |
| 5  | 주거     | 2             | 2026년 신규 주거 정책 안내 |
| 6  | 주거     | 3             | 주거 혜택 신청 방법 |
| 7  | 교육     | 1             | 교육 정책 이해하기 |
| 8  | 교육     | 2             | 2026년 신규 교육 정책 안내 |
| 9  | 교육     | 3             | 교육 혜택 신청 방법 |
| 10 | 금융·복지·문화 | 1       | 금융·복지·문화 정책 이해하기 |
| 11 | 금융·복지·문화 | 2       | 2026년 신규 금융·복지·문화 정책 |
| 12 | 금융·복지·문화 | 3       | 금융·복지·문화 혜택 신청 방법 |
| 13 | 참여     | 1             | 참여 정책 이해하기 |
| 14 | 참여     | 2             | 2026년 신규 참여 정책 안내 |
| 15 | 참여     | 3             | 참여 혜택 신청 방법 |

**카테고리당 영상 1개만 사용하는 경우**:

각 카테고리의 display_order = 1만 업데이트하고, 나머지는 삭제:

```sql
-- 카테고리당 1개 영상만 남기기
DELETE FROM public.videos WHERE display_order > 1;

-- 또는 URL만 NULL로 설정
UPDATE public.videos SET video_url = NULL WHERE display_order > 1;
```

---

## 문제 해결

### Q1. 영상이 재생되지 않아요

**원인**: YouTube 공개 설정이 "비공개"로 되어있음

**해결**:
1. YouTube Studio 접속
2. 해당 영상 클릭
3. 세부정보 > 공개 상태를 **"일부 공개"**로 변경
4. 저장

### Q2. 썸네일이 표시되지 않아요

**원인**: YouTube 썸네일 URL이 잘못됨

**해결**:
- Video ID 확인 (URL의 `v=` 뒤 문자열)
- 썸네일 URL 형식 확인: `https://img.youtube.com/vi/VIDEO_ID/maxresdefault.jpg`

### Q3. "완료로 표시"가 작동하지 않아요

**원인**: 로그인하지 않았거나 데이터베이스 권한 문제

**해결**:
1. 로그인 확인
2. Supabase RLS 정책 확인
3. 브라우저 콘솔 에러 확인

---

## 참고

### YouTube Unlisted의 장점

- ✅ 무제한 대역폭
- ✅ 자동 화질 조정 (240p ~ 1080p)
- ✅ 빠른 스트리밍 (Google CDN)
- ✅ 모바일 최적화
- ✅ 자막, 속도 조절 등 기본 기능

### Supabase Storage 대비

- Supabase 무료 플랜: 1GB 저장소, 월 2GB 전송량
- YouTube: 무제한

따라서 YouTube Unlisted가 더 안정적이고 경제적입니다.
