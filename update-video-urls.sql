-- YouTube 영상 URL 업데이트
-- 각 카테고리별 첫 번째 영상(display_order = 1)에 URL 설정

-- 1. 일자리 카테고리 영상
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=EkxH_hmnw1w',
  title = '청년 일자리 정책 완벽 가이드',
  description = '청년을 위한 일자리 정책을 자세히 안내합니다.',
  thumbnail_url = 'https://img.youtube.com/vi/EkxH_hmnw1w/maxresdefault.jpg'
WHERE category_id = 1 AND display_order = 1;

-- 2. 주거 카테고리 영상
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=3EnF0AF_-XE',
  title = '청년 주거 지원 정책 총정리',
  description = '청년을 위한 주거 정책을 자세히 안내합니다.',
  thumbnail_url = 'https://img.youtube.com/vi/3EnF0AF_-XE/maxresdefault.jpg'
WHERE category_id = 2 AND display_order = 1;

-- 3. 교육 카테고리 영상
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=sVeKq4nvTsU',
  title = '청년 교육 지원 제도 안내',
  description = '청년을 위한 교육 정책을 자세히 안내합니다.',
  thumbnail_url = 'https://img.youtube.com/vi/sVeKq4nvTsU/maxresdefault.jpg'
WHERE category_id = 3 AND display_order = 1;

-- 4. 금융복지문화 카테고리 영상
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=u0rvn9tsX2A',
  title = '청년 금융 복지 문화 정책 설명',
  description = '청년을 위한 금융, 복지, 문화 정책을 자세히 안내합니다.',
  thumbnail_url = 'https://img.youtube.com/vi/u0rvn9tsX2A/maxresdefault.jpg'
WHERE category_id = 4 AND display_order = 1;

-- 5. 참여 카테고리 영상
UPDATE public.videos
SET
  video_url = 'https://www.youtube.com/watch?v=bztcdEUfgeA',
  title = '청년 참여 정책 소개',
  description = '청년을 위한 참여 정책을 자세히 안내합니다.',
  thumbnail_url = 'https://img.youtube.com/vi/bztcdEUfgeA/maxresdefault.jpg'
WHERE category_id = 5 AND display_order = 1;

-- 확인: 업데이트된 영상 목록 조회
SELECT
  v.id,
  c.name as category,
  v.title,
  v.video_url,
  v.display_order
FROM public.videos v
JOIN public.categories c ON v.category_id = c.id
WHERE v.display_order = 1
ORDER BY v.category_id;
