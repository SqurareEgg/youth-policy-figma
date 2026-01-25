-- 카테고리당 1개 영상만 남기기 (display_order = 1)
-- display_order가 2, 3인 영상들 삭제

-- 삭제할 영상 확인
SELECT
  v.id,
  c.name as category,
  v.title,
  v.display_order
FROM public.videos v
JOIN public.categories c ON v.category_id = c.id
WHERE v.display_order > 1
ORDER BY v.category_id, v.display_order;

-- display_order가 2 이상인 영상 삭제
DELETE FROM public.videos
WHERE display_order > 1;

-- 확인: 남은 영상 목록 (카테고리당 1개씩만)
SELECT
  v.id,
  c.name as category,
  v.title,
  v.video_url,
  v.display_order
FROM public.videos v
JOIN public.categories c ON v.category_id = c.id
ORDER BY v.category_id;
