-- ============================================
-- 이수율 계산 로직 변경
-- 영상 시청만으로 이수율 계산 (퀴즈는 제외)
-- ============================================

-- 기존 뷰 삭제
DROP VIEW IF EXISTS user_learning_progress;

-- 새로운 뷰 생성 (영상만으로 이수율 계산)
CREATE OR REPLACE VIEW user_learning_progress AS
WITH video_progress AS (
  SELECT
    p.id AS user_id,
    v.category_id,
    COUNT(v.id) AS total_videos,
    COUNT(CASE WHEN uvp.completed = true THEN 1 END) AS completed_videos
  FROM public.profiles p
  CROSS JOIN public.videos v
  LEFT JOIN public.user_video_progress uvp
    ON v.id = uvp.video_id AND p.id = uvp.user_id
  GROUP BY p.id, v.category_id
)
SELECT
  vp.user_id,
  vp.category_id,
  c.name AS category_name,
  vp.total_videos,
  vp.completed_videos,
  0 AS total_quizzes,  -- 퀴즈는 이수율에 영향 없음
  0 AS completed_quizzes,  -- 퀴즈는 이수율에 영향 없음
  vp.total_videos AS total_items,  -- 영상만 카운트
  vp.completed_videos AS completed_items,  -- 완료한 영상만 카운트
  ROUND(
    COALESCE(vp.completed_videos, 0)::DECIMAL /
    NULLIF(COALESCE(vp.total_videos, 0), 0) * 100,
    2
  ) AS completion_percentage  -- 영상만으로 이수율 계산
FROM video_progress vp
JOIN public.categories c ON vp.category_id = c.id;
