// 정책 카테고리별 더미 데이터

export interface PolicyDetail {
  title: string
  description: string
  image?: string
}

export interface Policy {
  id: number
  title: string
  icon: string
  image: string
  content: {
    intro: string
    details: PolicyDetail[]
  }
  description: string[]
}

// 일자리 정책 데이터
export const jobPolicies: Policy[] = [
  {
    id: 1,
    title: '첫 일자리 진입 및 조기 사회진출 지원',
    icon: 'briefcase',
    image: '/src/assets/images/3f6ab8e09e6f53adbc0109187c3a0884f928ca53.png',
    content: {
      intro: '청년들이 학교를 졸업한 후 지체 없이 노동시장에 안착할 수 있도록 민간과 공공의 협력을 통한 통합 지원 체계를 가동합니다.',
      details: [
        {
          title: '민·관 협업 채용 확대',
          description: '청년 일자리 창출을 유도하기 위해 신규 채용 기업에 재정, 세제, 포상 등 전방위적인 인센티브를 제공합니다.'
        },
        {
          title: '국가 R&D 기업 우대',
          description: '국가 연구개발(R&D) 과제를 수행하는 기업이 청년을 채용할 경우 선정 과정에서 가점을 부여합니다.'
        },
        {
          title: '선제적 패키지 지원',
          description: '졸업 예정자나 졸업 직후의 미취업 청년이 구직에 어려움을 겪지 않도록 통합 패키지를 시행합니다.'
        }
      ]
    },
    description: [
      '민·관 협업 채용 확대',
      '• 기업 인센티브: 청년 신규 채용 기업에 재정·세제·포상 등 전방위 지원',
      '• 장기 고용 유도: 고용 기간이 길수록 세제 혜택이 커지는 구조 개편'
    ]
  },
  {
    id: 2,
    title: '다시 서기 및 안정적 구직 지원',
    icon: 'refresh-cw',
    image: '/src/assets/images/d49f90f45d2930ee07a549ebf68315fe9c99713c.png',
    content: {
      intro: '일시적으로 구직을 중단하거나 어려움을 겪는 청년들이 사회로 다시 돌아올 수 있는 튼튼한 안전망을 구축합니다.',
      details: [
        {
          title: '쉬는 청년 맞춤 케어',
          description: '청년 일자리 첫걸음 플랫폼을 구축하여 장기 미취업 위험군을 선제적으로 발굴하고 맞춤형 복귀 프로그램을 제공합니다.'
        },
        {
          title: '청년도전지원사업',
          description: '구직 단념 청년들에게 밀착 상담과 역량 강화 프로그램을 제공하며, 참여 수당을 지급합니다.'
        }
      ]
    },
    description: [
      '쉬는 청년 맞춤 케어',
      '• 청년 일자리 첫걸음 플랫폼: 장기 미취업 위험군을 선제 발굴하여 맞춤형 복귀 프로그램 제공'
    ]
  }
]

// 주거 정책 데이터
export const housingPolicies: Policy[] = [
  {
    id: 1,
    title: '청년 주거 지원',
    icon: 'home',
    image: '/src/assets/images/2a0a0ef36e2f77b30610e49e3935952966ee2efd.png',
    content: {
      intro: '청년들이 안정적인 주거 환경에서 미래를 준비할 수 있도록 다양한 주거 지원 정책을 제공합니다.',
      details: [
        {
          title: '청년 전세자금 대출',
          description: '저금리로 전세자금을 대출받아 안정적인 주거를 확보할 수 있도록 지원합니다.'
        },
        {
          title: '청년 매입임대주택',
          description: '시세보다 저렴한 가격으로 청년 전용 임대주택을 제공합니다.'
        }
      ]
    },
    description: [
      '청년 전세자금 대출',
      '• 저금리 전세자금 대출 지원',
      '청년 매입임대주택',
      '• 시세보다 저렴한 청년 전용 임대주택 제공'
    ]
  }
]

// 교육 정책 데이터
export const educationPolicies: Policy[] = [
  {
    id: 1,
    title: '청년 교육 지원',
    icon: 'graduation-cap',
    image: '/src/assets/images/56c273b8d4ac0b2979417b8dbce4f8facf68b59b.png',
    content: {
      intro: '청년들의 역량 개발과 평생 학습을 지원하여 미래 경쟁력을 강화합니다.',
      details: [
        {
          title: '국가장학금',
          description: '소득 수준에 따라 등록금을 지원하여 교육 기회를 확대합니다.'
        },
        {
          title: '직업훈련 지원',
          description: '취업에 필요한 실무 역량을 키울 수 있는 다양한 직업훈련 프로그램을 제공합니다.'
        }
      ]
    },
    description: [
      '국가장학금',
      '• 소득 수준에 따른 등록금 지원',
      '직업훈련 지원',
      '• 실무 역량 강화를 위한 직업훈련 프로그램 제공'
    ]
  }
]

// 금융·복지·문화 정책 데이터
export const financeWelfareCulturePolicies: Policy[] = [
  {
    id: 1,
    title: '청년 금융 지원',
    icon: 'credit-card',
    image: '/src/assets/images/358c4e4f557593b8c8e02844e772c0b98227e503.png',
    content: {
      intro: '청년들의 경제적 자립과 안정을 위한 다양한 금융 지원 정책을 제공합니다.',
      details: [
        {
          title: '청년희망적금',
          description: '일정 기간 적금을 유지하면 정부가 이자를 지원하여 자산 형성을 돕습니다.'
        },
        {
          title: '청년 문화패스',
          description: '문화생활을 즐길 수 있도록 문화비를 지원합니다.'
        }
      ]
    },
    description: [
      '청년희망적금',
      '• 정부 이자 지원을 통한 자산 형성 지원',
      '청년 문화패스',
      '• 문화생활을 위한 문화비 지원'
    ]
  }
]

// 참여·권리 정책 데이터
export const participationPolicies: Policy[] = [
  {
    id: 1,
    title: '청년 참여 확대',
    icon: 'users',
    image: '/src/assets/images/13ef0fc53f4788c0f50b3837b8fd902c63c99d07.png',
    content: {
      intro: '청년들이 정책 결정 과정에 직접 참여하고 목소리를 낼 수 있는 기회를 제공합니다.',
      details: [
        {
          title: '청년정책네트워크',
          description: '청년들이 직접 정책을 제안하고 토론할 수 있는 플랫폼을 운영합니다.'
        },
        {
          title: '청년참여위원회',
          description: '각 부처별 청년참여위원회를 통해 청년의 의견을 정책에 반영합니다.'
        }
      ]
    },
    description: [
      '청년정책네트워크',
      '• 청년 정책 제안 및 토론 플랫폼 운영',
      '청년참여위원회',
      '• 부처별 청년참여위원회를 통한 의견 반영'
    ]
  }
]

// 카테고리별 정책 데이터 맵
export const categoryPolicies: Record<string, Policy[]> = {
  '일자리': jobPolicies,
  '주거': housingPolicies,
  '교육': educationPolicies,
  '금융･복지･문화': financeWelfareCulturePolicies,
  '참여': participationPolicies
}
