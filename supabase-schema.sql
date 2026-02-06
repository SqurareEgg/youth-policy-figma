-- ============================================
-- 청년있슈 (Youth Policy Platform) Database Schema
-- Supabase PostgreSQL
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- 1. USERS TABLE (extends Supabase Auth)
-- ============================================
-- Note: Supabase Auth already provides auth.users table
-- We create a public.profiles table for additional user info
CREATE TABLE public.profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  birth_date DATE,
  school TEXT,
  student_id TEXT,
  terms_agreed BOOLEAN DEFAULT false,
  privacy_agreed BOOLEAN DEFAULT false,
  marketing_agreed BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Enable Row Level Security
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Profiles policies: Users can only read/update their own profile
CREATE POLICY "Users can view own profile"
  ON public.profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- ============================================
-- 2. CATEGORIES TABLE
-- ============================================
CREATE TABLE public.categories (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL, -- '일자리', '주거', '교육', '금융･복지･문화', '참여'
  slug TEXT UNIQUE NOT NULL, -- 'job', 'housing', 'education', 'finance-welfare-culture', 'participation'
  icon TEXT NOT NULL, -- Lucide icon name
  description TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Categories are public
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Categories are viewable by everyone"
  ON public.categories FOR SELECT
  USING (true);

-- ============================================
-- 3. POLICIES TABLE
-- ============================================
CREATE TABLE public.policies (
  id SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES public.categories(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  icon TEXT NOT NULL, -- Lucide icon name
  image_url TEXT, -- Main policy image
  intro TEXT, -- Main introduction text
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.policies ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Policies are viewable by everyone"
  ON public.policies FOR SELECT
  USING (true);

-- ============================================
-- 4. POLICY DETAILS TABLE (1:N with policies)
-- ============================================
CREATE TABLE public.policy_details (
  id SERIAL PRIMARY KEY,
  policy_id INTEGER REFERENCES public.policies(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.policy_details ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Policy details are viewable by everyone"
  ON public.policy_details FOR SELECT
  USING (true);

-- ============================================
-- 5. VIDEOS TABLE
-- ============================================
CREATE TABLE public.videos (
  id SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES public.categories(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  duration TEXT NOT NULL, -- Format: "MM:SS" or "HH:MM:SS"
  thumbnail_url TEXT,
  video_url TEXT, -- YouTube URL or other video platform
  description TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.videos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Videos are viewable by everyone"
  ON public.videos FOR SELECT
  USING (true);

-- ============================================
-- 6. USER VIDEO PROGRESS TABLE
-- ============================================
CREATE TABLE public.user_video_progress (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  video_id INTEGER REFERENCES public.videos(id) ON DELETE CASCADE,
  completed BOOLEAN DEFAULT false,
  last_position INTEGER DEFAULT 0, -- In seconds
  completed_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(user_id, video_id)
);

ALTER TABLE public.user_video_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own video progress"
  ON public.user_video_progress FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own video progress"
  ON public.user_video_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own video progress"
  ON public.user_video_progress FOR UPDATE
  USING (auth.uid() = user_id);

-- ============================================
-- 7. QUIZZES TABLE
-- ============================================
CREATE TABLE public.quizzes (
  id SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES public.categories(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  description TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Quizzes are viewable by everyone"
  ON public.quizzes FOR SELECT
  USING (true);

-- ============================================
-- 8. QUIZ QUESTIONS TABLE
-- ============================================
CREATE TABLE public.quiz_questions (
  id SERIAL PRIMARY KEY,
  quiz_id INTEGER REFERENCES public.quizzes(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  options JSONB NOT NULL, -- Array of options: ["Option 1", "Option 2", ...]
  correct_answer INTEGER NOT NULL, -- Index of correct option (0-based)
  explanation TEXT,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.quiz_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Quiz questions are viewable by everyone"
  ON public.quiz_questions FOR SELECT
  USING (true);

-- ============================================
-- 9. USER QUIZ RESULTS TABLE
-- ============================================
CREATE TABLE public.user_quiz_results (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  quiz_id INTEGER REFERENCES public.quizzes(id) ON DELETE CASCADE,
  score INTEGER NOT NULL, -- 0-100
  total_questions INTEGER NOT NULL,
  correct_answers INTEGER NOT NULL,
  answers JSONB, -- User's answers: {"1": 0, "2": 2, ...} (question_id: selected_option_index)
  completed_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.user_quiz_results ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own quiz results"
  ON public.user_quiz_results FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own quiz results"
  ON public.user_quiz_results FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ============================================
-- 10. QNA TABLE (Frequently Asked Questions)
-- ============================================
CREATE TABLE public.qna (
  id SERIAL PRIMARY KEY,
  category_id INTEGER REFERENCES public.categories(id) ON DELETE CASCADE,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.qna ENABLE ROW LEVEL SECURITY;

CREATE POLICY "QnA are viewable by everyone"
  ON public.qna FOR SELECT
  USING (true);

-- ============================================
-- 11. USER BOOKMARKS TABLE (Saved Policies)
-- ============================================
CREATE TABLE public.user_bookmarks (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  policy_id INTEGER REFERENCES public.policies(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(user_id, policy_id)
);

ALTER TABLE public.user_bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own bookmarks"
  ON public.user_bookmarks FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own bookmarks"
  ON public.user_bookmarks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own bookmarks"
  ON public.user_bookmarks FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 12. COMMUNITY POSTS TABLE
-- ============================================
CREATE TABLE public.community_posts (
  id SERIAL PRIMARY KEY,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  category_id INTEGER REFERENCES public.categories(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  views INTEGER DEFAULT 0,
  likes INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.community_posts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Posts are viewable by everyone"
  ON public.community_posts FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can create posts"
  ON public.community_posts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own posts"
  ON public.community_posts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own posts"
  ON public.community_posts FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 13. COMMENTS TABLE
-- ============================================
CREATE TABLE public.comments (
  id SERIAL PRIMARY KEY,
  post_id INTEGER REFERENCES public.community_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  likes INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

ALTER TABLE public.comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Comments are viewable by everyone"
  ON public.comments FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can create comments"
  ON public.comments FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own comments"
  ON public.comments FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own comments"
  ON public.comments FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 14. POST LIKES TABLE
-- ============================================
CREATE TABLE public.post_likes (
  id SERIAL PRIMARY KEY,
  post_id INTEGER REFERENCES public.community_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(post_id, user_id)
);

ALTER TABLE public.post_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Post likes are viewable by everyone"
  ON public.post_likes FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can like posts"
  ON public.post_likes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike posts"
  ON public.post_likes FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- 15. COMMENT LIKES TABLE
-- ============================================
CREATE TABLE public.comment_likes (
  id SERIAL PRIMARY KEY,
  comment_id INTEGER REFERENCES public.comments(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(comment_id, user_id)
);

ALTER TABLE public.comment_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Comment likes are viewable by everyone"
  ON public.comment_likes FOR SELECT
  USING (true);

CREATE POLICY "Authenticated users can like comments"
  ON public.comment_likes FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike comments"
  ON public.comment_likes FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================
-- INDEXES for Performance
-- ============================================

-- Policies
CREATE INDEX idx_policies_category ON public.policies(category_id);

-- Policy Details
CREATE INDEX idx_policy_details_policy ON public.policy_details(policy_id);

-- Videos
CREATE INDEX idx_videos_category ON public.videos(category_id);

-- User Video Progress
CREATE INDEX idx_user_video_progress_user ON public.user_video_progress(user_id);
CREATE INDEX idx_user_video_progress_video ON public.user_video_progress(video_id);

-- Quizzes
CREATE INDEX idx_quizzes_category ON public.quizzes(category_id);

-- Quiz Questions
CREATE INDEX idx_quiz_questions_quiz ON public.quiz_questions(quiz_id);

-- User Quiz Results
CREATE INDEX idx_user_quiz_results_user ON public.user_quiz_results(user_id);
CREATE INDEX idx_user_quiz_results_quiz ON public.user_quiz_results(quiz_id);

-- QnA
CREATE INDEX idx_qna_category ON public.qna(category_id);

-- User Bookmarks
CREATE INDEX idx_user_bookmarks_user ON public.user_bookmarks(user_id);
CREATE INDEX idx_user_bookmarks_policy ON public.user_bookmarks(policy_id);

-- Community Posts
CREATE INDEX idx_community_posts_user ON public.community_posts(user_id);
CREATE INDEX idx_community_posts_category ON public.community_posts(category_id);
CREATE INDEX idx_community_posts_created ON public.community_posts(created_at DESC);

-- Comments
CREATE INDEX idx_comments_post ON public.comments(post_id);
CREATE INDEX idx_comments_user ON public.comments(user_id);

-- Post Likes
CREATE INDEX idx_post_likes_post ON public.post_likes(post_id);
CREATE INDEX idx_post_likes_user ON public.post_likes(user_id);

-- Comment Likes
CREATE INDEX idx_comment_likes_comment ON public.comment_likes(comment_id);
CREATE INDEX idx_comment_likes_user ON public.comment_likes(user_id);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = TIMEZONE('utc', NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_policies_updated_at BEFORE UPDATE ON public.policies
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_videos_updated_at BEFORE UPDATE ON public.videos
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_video_progress_updated_at BEFORE UPDATE ON public.user_video_progress
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quizzes_updated_at BEFORE UPDATE ON public.quizzes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_qna_updated_at BEFORE UPDATE ON public.qna
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_community_posts_updated_at BEFORE UPDATE ON public.community_posts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_comments_updated_at BEFORE UPDATE ON public.comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, created_at)
  VALUES (NEW.id, NEW.email, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to auto-create profile when user signs up
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update post likes count
CREATE OR REPLACE FUNCTION update_post_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.community_posts
    SET likes = likes + 1
    WHERE id = NEW.post_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.community_posts
    SET likes = likes - 1
    WHERE id = OLD.post_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger for post likes count
CREATE TRIGGER update_post_likes_count_trigger
  AFTER INSERT OR DELETE ON public.post_likes
  FOR EACH ROW EXECUTE FUNCTION update_post_likes_count();

-- Function to update comment likes count
CREATE OR REPLACE FUNCTION update_comment_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE public.comments
    SET likes = likes + 1
    WHERE id = NEW.comment_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE public.comments
    SET likes = likes - 1
    WHERE id = OLD.comment_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Trigger for comment likes count
CREATE TRIGGER update_comment_likes_count_trigger
  AFTER INSERT OR DELETE ON public.comment_likes
  FOR EACH ROW EXECUTE FUNCTION update_comment_likes_count();

-- ============================================
-- VIEWS for Common Queries
-- ============================================

-- View: Policy with details and category
CREATE OR REPLACE VIEW policy_full_view AS
SELECT
  p.id,
  p.title,
  p.icon,
  p.image_url,
  p.intro,
  c.name AS category_name,
  c.slug AS category_slug,
  json_agg(
    json_build_object(
      'id', pd.id,
      'title', pd.title,
      'description', pd.description,
      'display_order', pd.display_order
    ) ORDER BY pd.display_order
  ) AS details
FROM public.policies p
JOIN public.categories c ON p.category_id = c.id
LEFT JOIN public.policy_details pd ON p.id = pd.policy_id
GROUP BY p.id, p.title, p.icon, p.image_url, p.intro, c.name, c.slug;

-- View: User learning progress by category
-- 이수율 = (완료한 영상 수 + 완료한 퀴즈 수) / (전체 영상 수 + 전체 퀴즈 수) * 100
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
),
quiz_progress AS (
  SELECT
    p.id AS user_id,
    q.category_id,
    COUNT(DISTINCT q.id) AS total_quizzes,
    COUNT(DISTINCT CASE WHEN uqr.score >= 60 THEN q.id END) AS completed_quizzes
  FROM public.profiles p
  CROSS JOIN public.quizzes q
  LEFT JOIN (
    SELECT DISTINCT ON (user_id, quiz_id) *
    FROM public.user_quiz_results
    ORDER BY user_id, quiz_id, completed_at DESC
  ) uqr ON q.id = uqr.quiz_id AND p.id = uqr.user_id
  GROUP BY p.id, q.category_id
)
SELECT
  vp.user_id,
  vp.category_id,
  c.name AS category_name,
  vp.total_videos,
  vp.completed_videos,
  qp.total_quizzes,
  qp.completed_quizzes,
  (vp.total_videos + qp.total_quizzes) AS total_items,
  (vp.completed_videos + qp.completed_quizzes) AS completed_items,
  ROUND(
    (COALESCE(vp.completed_videos, 0) + COALESCE(qp.completed_quizzes, 0))::DECIMAL /
    NULLIF((COALESCE(vp.total_videos, 0) + COALESCE(qp.total_quizzes, 0)), 0) * 100,
    2
  ) AS completion_percentage
FROM video_progress vp
JOIN quiz_progress qp ON vp.user_id = qp.user_id AND vp.category_id = qp.category_id
JOIN public.categories c ON vp.category_id = c.id;

-- View: Community posts with user info
CREATE OR REPLACE VIEW community_posts_with_user AS
SELECT
  cp.id,
  cp.title,
  cp.content,
  cp.views,
  cp.likes,
  cp.created_at,
  cp.updated_at,
  p.name AS author_name,
  p.email AS author_email,
  c.name AS category_name,
  (SELECT COUNT(*) FROM public.comments WHERE post_id = cp.id) AS comment_count
FROM public.community_posts cp
JOIN public.profiles p ON cp.user_id = p.id
LEFT JOIN public.categories c ON cp.category_id = c.id;

-- ============================================
-- 16. PAGE VIEWS TABLE (접속자 추적)
-- ============================================
CREATE TABLE public.page_views (
  id SERIAL PRIMARY KEY,
  session_id TEXT NOT NULL, -- 브라우저 세션 ID (고유 방문자 구분용)
  page_path TEXT NOT NULL, -- 방문한 페이지 경로
  referrer TEXT, -- 유입 경로
  user_agent TEXT, -- 브라우저 정보
  ip_address TEXT, -- IP 주소 (선택사항)
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Page views are public for analytics
ALTER TABLE public.page_views ENABLE ROW LEVEL SECURITY;

-- Anyone can insert page views (for analytics)
CREATE POLICY "Anyone can insert page views"
  ON public.page_views FOR INSERT
  WITH CHECK (true);

-- Only admins can view page views (for privacy)
-- Note: You may want to create an admin role or adjust this policy
CREATE POLICY "Public can view page view stats"
  ON public.page_views FOR SELECT
  USING (true);

-- Indexes for performance
CREATE INDEX idx_page_views_session ON public.page_views(session_id);
CREATE INDEX idx_page_views_page_path ON public.page_views(page_path);
CREATE INDEX idx_page_views_created ON public.page_views(created_at DESC);

-- View: Page view statistics
CREATE OR REPLACE VIEW page_view_stats AS
SELECT
  page_path,
  COUNT(*) AS total_views,
  COUNT(DISTINCT session_id) AS unique_visitors,
  DATE(created_at) AS view_date
FROM public.page_views
GROUP BY page_path, DATE(created_at);

-- View: Daily statistics
CREATE OR REPLACE VIEW daily_stats AS
SELECT
  DATE(created_at) AS date,
  COUNT(*) AS total_views,
  COUNT(DISTINCT session_id) AS unique_visitors,
  COUNT(DISTINCT page_path) AS pages_visited
FROM public.page_views
GROUP BY DATE(created_at)
ORDER BY DATE(created_at) DESC;
