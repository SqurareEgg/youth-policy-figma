// 학습 콘텐츠 더미 데이터

export interface Video {
  id: number
  title: string
  duration: string
  thumbnail: string
  completed: boolean
  url?: string
}

export interface QnAItem {
  id: number
  question: string
  answer: string
  category: string
}

export interface Quiz {
  id: number
  title: string
  questions: number
  score: number | null
  completed: boolean
}

export interface QuizQuestion {
  id: number
  question: string
  options: string[]
  correctAnswer: number
  explanation: string
}

// 카테고리별 영상 데이터
export const getCategoryVideos = (category: string): Video[] => [
  {
    id: 1,
    title: `${category} 정책 이해하기`,
    duration: '12:30',
    thumbnail: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=400',
    completed: true,
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
  },
  {
    id: 2,
    title: `2026년 신규 ${category} 정책 안내`,
    duration: '08:45',
    thumbnail: 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?w=400',
    completed: false,
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
  },
  {
    id: 3,
    title: `${category} 혜택 신청 방법`,
    duration: '15:20',
    thumbnail: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400',
    completed: false,
    url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
  }
]

// 카테고리별 Q&A 데이터
export const getCategoryQnA = (category: string): QnAItem[] => [
  {
    id: 1,
    question: `${category} 정책은 누가 신청할 수 있나요?`,
    answer: `만 19세~34세 청년이라면 누구나 신청 가능합니다. 단, 일부 정책의 경우 소득 요건 등 추가 조건이 있을 수 있습니다.`,
    category
  },
  {
    id: 2,
    question: `${category} 정책 신청은 어디서 하나요?`,
    answer: `청년있슈 웹사이트 또는 각 정책별 담당 기관 홈페이지에서 온라인으로 신청하실 수 있습니다.`,
    category
  },
  {
    id: 3,
    question: '신청 후 결과는 언제 나오나요?',
    answer: '정책마다 상이하지만, 일반적으로 신청 후 2주~4주 이내에 결과를 받아보실 수 있습니다.',
    category
  },
  {
    id: 4,
    question: '중복 신청이 가능한가요?',
    answer: '대부분의 정책은 중복 신청이 가능하지만, 일부 정책은 중복 수혜가 제한될 수 있습니다. 각 정책의 세부 조건을 확인해주세요.',
    category
  },
  {
    id: 5,
    question: '신청에 필요한 서류는 무엇인가요?',
    answer: '주민등록등본, 소득증명서류, 재학/졸업증명서 등이 기본적으로 필요하며, 정책에 따라 추가 서류가 요구될 수 있습니다.',
    category
  }
]

// 카테고리별 퀴즈 목록
export const getCategoryQuizzes = (category: string): Quiz[] => [
  {
    id: 1,
    title: `${category} 정책 기본 Quiz`,
    questions: 10,
    score: 80,
    completed: true
  },
  {
    id: 2,
    title: `${category} 신청 절차 Quiz`,
    questions: 15,
    score: null,
    completed: false
  },
  {
    id: 3,
    title: `${category} 종합 평가 Quiz`,
    questions: 20,
    score: null,
    completed: false
  }
]

// 퀴즈 문제 예시 (카테고리별)
export const getQuizQuestions = (category: string, quizId: number): QuizQuestion[] => [
  {
    id: 1,
    question: `${category} 정책의 주요 대상 연령은?`,
    options: ['만 18세~30세', '만 19세~34세', '만 20세~35세', '만 19세~39세'],
    correctAnswer: 1,
    explanation: '대부분의 청년 정책은 만 19세~34세를 대상으로 합니다.'
  },
  {
    id: 2,
    question: `${category} 정책 신청 시 가장 먼저 확인해야 할 것은?`,
    options: ['신청 기한', '소득 요건', '연령 조건', '모든 항목'],
    correctAnswer: 3,
    explanation: '정책 신청 전에 모든 지원 요건을 꼼꼼히 확인하는 것이 중요합니다.'
  },
  {
    id: 3,
    question: `온라인으로 ${category} 정책을 신청할 수 있나요?`,
    options: ['네, 가능합니다', '아니요, 방문만 가능합니다', '일부만 가능합니다', '정책마다 다릅니다'],
    correctAnswer: 0,
    explanation: '대부분의 청년 정책은 온라인으로 편리하게 신청할 수 있습니다.'
  },
  {
    id: 4,
    question: `${category} 정책의 혜택 기간은?`,
    options: ['1년', '2년', '정책마다 다름', '무기한'],
    correctAnswer: 2,
    explanation: '각 정책마다 지원 기간과 혜택 기간이 상이합니다.'
  },
  {
    id: 5,
    question: `${category} 정책 관련 문의는 어디로 하나요?`,
    options: ['청년있슈 고객센터', '해당 정책 담당 기관', '주민센터', '모두 가능'],
    correctAnswer: 3,
    explanation: '청년있슈 고객센터, 정책 담당 기관, 주민센터 모두 문의가 가능합니다.'
  },
  {
    id: 6,
    question: '정책 신청 시 제출한 서류의 유효기간은?',
    options: ['1개월', '3개월', '6개월', '서류마다 다름'],
    correctAnswer: 3,
    explanation: '서류마다 유효기간이 다르므로 각 서류의 발급일자를 확인해야 합니다.'
  },
  {
    id: 7,
    question: `${category} 정책 수혜 중 다른 정책을 추가로 신청할 수 있나요?`,
    options: ['네, 가능합니다', '아니요, 불가능합니다', '정책에 따라 다릅니다', '소득에 따라 다릅니다'],
    correctAnswer: 2,
    explanation: '일부 정책은 중복 수혜가 가능하지만, 일부는 제한이 있을 수 있습니다.'
  },
  {
    id: 8,
    question: '정책 신청이 반려되면 재신청이 가능한가요?',
    options: ['네, 언제든 가능합니다', '아니요, 불가능합니다', '1회만 가능합니다', '조건 충족 시 가능합니다'],
    correctAnswer: 3,
    explanation: '반려 사유를 보완하고 조건을 충족하면 재신청이 가능합니다.'
  },
  {
    id: 9,
    question: `${category} 정책의 혜택을 받는 중 조건이 변경되면?`,
    options: ['즉시 신고해야 함', '신고 불필요', '종료 시 신고', '정책마다 다름'],
    correctAnswer: 0,
    explanation: '소득, 거주지 등 주요 조건이 변경되면 즉시 신고해야 합니다.'
  },
  {
    id: 10,
    question: '정책 관련 정보는 어디서 가장 정확하게 확인할 수 있나요?',
    options: ['청년있슈 공식 웹사이트', '블로그', 'SNS', '지인 추천'],
    correctAnswer: 0,
    explanation: '공식 웹사이트에서 가장 정확하고 최신의 정보를 확인할 수 있습니다.'
  }
]

// 학습 진행률 계산
export const calculateCompletionRate = (category: string): number => {
  // 더미 데이터 - 실제로는 사용자의 학습 진행 상태를 기반으로 계산
  const rates: Record<string, number> = {
    '일자리': 45,
    '주거': 30,
    '교육': 60,
    '금융･복지･문화': 25,
    '참여': 50
  }
  return rates[category] || 0
}
