/**
 * Figma 프로토타입 라우트
 * 청년있슈 - 청년 정책 통합 플랫폼
 */

const routes = [
  // ============================================
  // 메인 랜딩 페이지
  // ============================================
  {
    path: '/',
    name: 'landing',
    component: () => import('../pages/FigmaLandingPage.vue'),
    meta: {
      title: '청년있슈 - 청년 정책 통합 플랫폼'
    }
  },

  // ============================================
  // 카테고리 상세 페이지
  // ============================================
  {
    path: '/category/:category',
    name: 'category',
    component: () => import('../pages/FigmaCategoryPage.vue'),
    meta: {
      title: '정책 상세'
    }
  },

  // ============================================
  // 로그인 페이지
  // ============================================
  {
    path: '/login',
    name: 'login',
    component: () => import('../pages/FigmaLoginPage.vue'),
    meta: {
      title: '로그인'
    }
  },

  // ============================================
  // 회원가입 페이지
  // ============================================
  {
    path: '/signup',
    name: 'signup',
    component: () => import('../pages/FigmaSignupPage.vue'),
    meta: {
      title: '회원가입'
    }
  },

  // ============================================
  // 퀴즈 페이지
  // ============================================
  {
    path: '/category/:category/quiz/:quizId',
    name: 'quiz',
    component: () => import('../pages/FigmaQuizPage.vue'),
    meta: {
      title: '퀴즈'
    }
  },

  // ============================================
  // 영상 페이지
  // ============================================
  {
    path: '/category/:category/video/:videoId',
    name: 'video',
    component: () => import('../pages/FigmaVideoPage.vue'),
    meta: {
      title: '영상 시청'
    }
  },

  // ============================================
  // 정책 상세 페이지
  // ============================================
  {
    path: '/category/:category/policy/:policyId',
    name: 'policy-detail',
    component: () => import('../pages/FigmaPolicyDetailPage.vue'),
    meta: {
      title: '정책 상세'
    }
  },

  // ============================================
  // 준비중 페이지
  // ============================================
  {
    path: '/coming-soon',
    name: 'coming-soon',
    component: () => import('../pages/FigmaComingSoonPage.vue'),
    meta: {
      title: '준비중'
    }
  },

  // ============================================
  // 404 페이지
  // ============================================
  {
    path: '/:catchAll(.*)*',
    redirect: '/'
  }
]

export default routes
