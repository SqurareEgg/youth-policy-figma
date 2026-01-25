-- ============================================
-- 청년있슈 초기 샘플 데이터
-- ============================================

-- ============================================
-- 1. CATEGORIES 데이터
-- ============================================
INSERT INTO public.categories (name, slug, icon, description, display_order) VALUES
('일자리', 'job', 'briefcase', '청년 일자리 창출 및 취업 지원 정책', 1),
('주거', 'housing', 'home', '청년 주거 안정 및 주택 지원 정책', 2),
('교육', 'education', 'graduation-cap', '청년 교육 및 역량 개발 지원 정책', 3),
('금융･복지･문화', 'finance-welfare-culture', 'credit-card', '청년 금융, 복지, 문화 지원 정책', 4),
('참여', 'participation', 'users', '청년 정책 참여 및 권리 증진', 5);

-- ============================================
-- 2. POLICIES 데이터 (일자리)
-- ============================================
INSERT INTO public.policies (category_id, title, icon, image_url, intro) VALUES
(1, '첫 일자리 진입 및 조기 사회진출 지원', 'briefcase', '/src/assets/images/3f6ab8e09e6f53adbc0109187c3a0884f928ca53.png',
'청년들이 학교를 졸업한 후 지체 없이 노동시장에 안착할 수 있도록 민간과 공공의 협력을 통한 통합 지원 체계를 가동합니다.'),

(1, '다시 서기 및 안정적 구직 지원', 'refresh-cw', '/src/assets/images/d49f90f45d2930ee07a549ebf68315fe9c99713c.png',
'일시적으로 구직을 중단하거나 어려움을 겪는 청년들이 사회로 다시 돌아올 수 있는 튼튼한 안전망을 구축합니다.');

-- ============================================
-- 3. POLICY DETAILS 데이터 (일자리)
-- ============================================
INSERT INTO public.policy_details (policy_id, title, description, display_order) VALUES
(1, '민·관 협업 채용 확대', '청년 일자리 창출을 유도하기 위해 신규 채용 기업에 재정, 세제, 포상 등 전방위적인 인센티브를 제공합니다.', 1),
(1, '국가 R&D 기업 우대', '국가 연구개발(R&D) 과제를 수행하는 기업이 청년을 채용할 경우 선정 과정에서 가점을 부여합니다.', 2),
(1, '선제적 패키지 지원', '졸업 예정자나 졸업 직후의 미취업 청년이 구직에 어려움을 겪지 않도록 통합 패키지를 시행합니다.', 3),

(2, '쉬는 청년 맞춤 케어', '청년 일자리 첫걸음 플랫폼을 구축하여 장기 미취업 위험군을 선제적으로 발굴하고 맞춤형 복귀 프로그램을 제공합니다.', 1),
(2, '청년도전지원사업', '구직 단념 청년들에게 밀착 상담과 역량 강화 프로그램을 제공하며, 참여 수당을 지급합니다.', 2);

-- ============================================
-- 4. POLICIES 데이터 (주거)
-- ============================================
INSERT INTO public.policies (category_id, title, icon, image_url, intro) VALUES
(2, '청년 주거 지원', 'home', '/src/assets/images/2a0a0ef36e2f77b30610e49e3935952966ee2efd.png',
'청년들이 안정적인 주거 환경에서 미래를 준비할 수 있도록 다양한 주거 지원 정책을 제공합니다.');

INSERT INTO public.policy_details (policy_id, title, description, display_order) VALUES
(3, '청년 전세자금 대출', '저금리로 전세자금을 대출받아 안정적인 주거를 확보할 수 있도록 지원합니다.', 1),
(3, '청년 매입임대주택', '시세보다 저렴한 가격으로 청년 전용 임대주택을 제공합니다.', 2);

-- ============================================
-- 5. POLICIES 데이터 (교육)
-- ============================================
INSERT INTO public.policies (category_id, title, icon, image_url, intro) VALUES
(3, '청년 교육 지원', 'graduation-cap', '/src/assets/images/56c273b8d4ac0b2979417b8dbce4f8facf68b59b.png',
'청년들의 역량 개발과 평생 학습을 지원하여 미래 경쟁력을 강화합니다.');

INSERT INTO public.policy_details (policy_id, title, description, display_order) VALUES
(4, '국가장학금', '소득 수준에 따라 등록금을 지원하여 교육 기회를 확대합니다.', 1),
(4, '직업훈련 지원', '취업에 필요한 실무 역량을 키울 수 있는 다양한 직업훈련 프로그램을 제공합니다.', 2);

-- ============================================
-- 6. POLICIES 데이터 (금융･복지･문화)
-- ============================================
INSERT INTO public.policies (category_id, title, icon, image_url, intro) VALUES
(4, '청년 금융 지원', 'credit-card', '/src/assets/images/358c4e4f557593b8c8e02844e772c0b98227e503.png',
'청년들의 경제적 자립과 안정을 위한 다양한 금융 지원 정책을 제공합니다.');

INSERT INTO public.policy_details (policy_id, title, description, display_order) VALUES
(5, '청년희망적금', '일정 기간 적금을 유지하면 정부가 이자를 지원하여 자산 형성을 돕습니다.', 1),
(5, '청년 문화패스', '문화생활을 즐길 수 있도록 문화비를 지원합니다.', 2);

-- ============================================
-- 7. POLICIES 데이터 (참여)
-- ============================================
INSERT INTO public.policies (category_id, title, icon, image_url, intro) VALUES
(5, '청년 참여 확대', 'users', '/src/assets/images/13ef0fc53f4788c0f50b3837b8fd902c63c99d07.png',
'청년들이 정책 결정 과정에 직접 참여하고 목소리를 낼 수 있는 기회를 제공합니다.');

INSERT INTO public.policy_details (policy_id, title, description, display_order) VALUES
(6, '청년정책네트워크', '청년들이 직접 정책을 제안하고 토론할 수 있는 플랫폼을 운영합니다.', 1),
(6, '청년참여위원회', '각 부처별 청년참여위원회를 통해 청년의 의견을 정책에 반영합니다.', 2);

-- ============================================
-- 8. VIDEOS 데이터
-- ============================================
-- 일자리 카테고리 영상
INSERT INTO public.videos (category_id, title, duration, thumbnail_url, video_url, display_order) VALUES
(1, '일자리 정책 이해하기', '12:30', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
(1, '2026년 신규 일자리 정책 안내', '08:45', 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
(1, '일자리 혜택 신청 방법', '15:20', 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- 주거 카테고리 영상
INSERT INTO public.videos (category_id, title, duration, thumbnail_url, video_url, display_order) VALUES
(2, '주거 정책 이해하기', '12:30', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
(2, '2026년 신규 주거 정책 안내', '08:45', 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
(2, '주거 혜택 신청 방법', '15:20', 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- 교육 카테고리 영상
INSERT INTO public.videos (category_id, title, duration, thumbnail_url, video_url, display_order) VALUES
(3, '교육 정책 이해하기', '12:30', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
(3, '2026년 신규 교육 정책 안내', '08:45', 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
(3, '교육 혜택 신청 방법', '15:20', 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- 금융･복지･문화 카테고리 영상
INSERT INTO public.videos (category_id, title, duration, thumbnail_url, video_url, display_order) VALUES
(4, '금융･복지･문화 정책 이해하기', '12:30', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
(4, '2026년 신규 금융･복지･문화 정책 안내', '08:45', 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
(4, '금융･복지･문화 혜택 신청 방법', '15:20', 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- 참여 카테고리 영상
INSERT INTO public.videos (category_id, title, duration, thumbnail_url, video_url, display_order) VALUES
(5, '참여 정책 이해하기', '12:30', 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 1),
(5, '2026년 신규 참여 정책 안내', '08:45', 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 2),
(5, '참여 혜택 신청 방법', '15:20', 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400', 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 3);

-- ============================================
-- 9. QUIZZES 데이터
-- ============================================
INSERT INTO public.quizzes (category_id, title, description, display_order) VALUES
(1, '일자리 정책 기본 Quiz', '일자리 정책의 기본 내용을 확인하는 퀴즈입니다.', 1),
(1, '일자리 신청 절차 Quiz', '일자리 정책 신청 절차를 확인하는 퀴즈입니다.', 2),
(2, '주거 정책 기본 Quiz', '주거 정책의 기본 내용을 확인하는 퀴즈입니다.', 1),
(3, '교육 정책 기본 Quiz', '교육 정책의 기본 내용을 확인하는 퀴즈입니다.', 1),
(4, '금융･복지･문화 정책 기본 Quiz', '금융･복지･문화 정책의 기본 내용을 확인하는 퀴즈입니다.', 1),
(5, '참여 정책 기본 Quiz', '참여 정책의 기본 내용을 확인하는 퀴즈입니다.', 1);

-- ============================================
-- 10. QUIZ QUESTIONS 데이터 (일자리 정책 기본 Quiz)
-- ============================================
INSERT INTO public.quiz_questions (quiz_id, question, options, correct_answer, explanation, display_order) VALUES
(1, '일자리 정책의 주요 대상 연령은?',
'["만 18세~30세", "만 19세~34세", "만 20세~35세", "만 19세~39세"]'::jsonb,
1, '대부분의 청년 정책은 만 19세~34세를 대상으로 합니다.', 1),

(1, '일자리 정책 신청 시 가장 먼저 확인해야 할 것은?',
'["신청 기한", "소득 요건", "연령 조건", "모든 항목"]'::jsonb,
3, '정책 신청 전에 모든 지원 요건을 꼼꼼히 확인하는 것이 중요합니다.', 2),

(1, '온라인으로 일자리 정책을 신청할 수 있나요?',
'["네, 가능합니다", "아니요, 방문만 가능합니다", "일부만 가능합니다", "정책마다 다릅니다"]'::jsonb,
0, '대부분의 청년 정책은 온라인으로 편리하게 신청할 수 있습니다.', 3),

(1, '일자리 정책의 혜택 기간은?',
'["1년", "2년", "정책마다 다름", "무기한"]'::jsonb,
2, '각 정책마다 지원 기간과 혜택 기간이 상이합니다.', 4),

(1, '일자리 정책 관련 문의는 어디로 하나요?',
'["청년있슈 고객센터", "해당 정책 담당 기관", "주민센터", "모두 가능"]'::jsonb,
3, '청년있슈 고객센터, 정책 담당 기관, 주민센터 모두 문의가 가능합니다.', 5);

-- ============================================
-- 11. QNA 데이터
-- ============================================
-- 일자리 Q&A
INSERT INTO public.qna (category_id, question, answer, display_order) VALUES
(1, '일자리 정책은 누가 신청할 수 있나요?',
'만 19세~34세 청년이라면 누구나 신청 가능합니다. 단, 일부 정책의 경우 소득 요건 등 추가 조건이 있을 수 있습니다.', 1),

(1, '일자리 정책 신청은 어디서 하나요?',
'청년있슈 웹사이트 또는 각 정책별 담당 기관 홈페이지에서 온라인으로 신청하실 수 있습니다.', 2),

(1, '신청 후 결과는 언제 나오나요?',
'정책마다 상이하지만, 일반적으로 신청 후 2주~4주 이내에 결과를 받아보실 수 있습니다.', 3),

(1, '중복 신청이 가능한가요?',
'대부분의 정책은 중복 신청이 가능하지만, 일부 정책은 중복 수혜가 제한될 수 있습니다. 각 정책의 세부 조건을 확인해주세요.', 4),

(1, '신청에 필요한 서류는 무엇인가요?',
'주민등록등본, 소득증명서류, 재학/졸업증명서 등이 기본적으로 필요하며, 정책에 따라 추가 서류가 요구될 수 있습니다.', 5);

-- 주거 Q&A
INSERT INTO public.qna (category_id, question, answer, display_order) VALUES
(2, '주거 정책은 누가 신청할 수 있나요?',
'만 19세~34세 청년이라면 누구나 신청 가능합니다. 단, 일부 정책의 경우 소득 요건 등 추가 조건이 있을 수 있습니다.', 1),

(2, '주거 정책 신청은 어디서 하나요?',
'청년있슈 웹사이트 또는 각 정책별 담당 기관 홈페이지에서 온라인으로 신청하실 수 있습니다.', 2);

-- 교육 Q&A
INSERT INTO public.qna (category_id, question, answer, display_order) VALUES
(3, '교육 정책은 누가 신청할 수 있나요?',
'만 19세~34세 청년이라면 누구나 신청 가능합니다. 단, 일부 정책의 경우 소득 요건 등 추가 조건이 있을 수 있습니다.', 1),

(3, '교육 정책 신청은 어디서 하나요?',
'청년있슈 웹사이트 또는 각 정책별 담당 기관 홈페이지에서 온라인으로 신청하실 수 있습니다.', 2);

-- 금융･복지･문화 Q&A
INSERT INTO public.qna (category_id, question, answer, display_order) VALUES
(4, '금융･복지･문화 정책은 누가 신청할 수 있나요?',
'만 19세~34세 청년이라면 누구나 신청 가능합니다. 단, 일부 정책의 경우 소득 요건 등 추가 조건이 있을 수 있습니다.', 1),

(4, '금융･복지･문화 정책 신청은 어디서 하나요?',
'청년있슈 웹사이트 또는 각 정책별 담당 기관 홈페이지에서 온라인으로 신청하실 수 있습니다.', 2);

-- 참여 Q&A
INSERT INTO public.qna (category_id, question, answer, display_order) VALUES
(5, '참여 정책은 누가 신청할 수 있나요?',
'만 19세~34세 청년이라면 누구나 신청 가능합니다. 단, 일부 정책의 경우 소득 요건 등 추가 조건이 있을 수 있습니다.', 1),

(5, '참여 정책 신청은 어디서 하나요?',
'청년있슈 웹사이트 또는 각 정책별 담당 기관 홈페이지에서 온라인으로 신청하실 수 있습니다.', 2);
