-- profiles 테이블 스키마 업데이트
-- phone 컬럼 삭제하고 school, student_id 컬럼 추가

-- 1. 기존 phone 컬럼 삭제
ALTER TABLE public.profiles DROP COLUMN IF EXISTS phone;

-- 2. 새로운 컬럼 추가
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS school TEXT;
ALTER TABLE public.profiles ADD COLUMN IF NOT EXISTS student_id TEXT;

-- 3. 확인: profiles 테이블 구조 조회
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'profiles'
ORDER BY ordinal_position;
