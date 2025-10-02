// 글로벌 스탠다드 프리미엄 디자인 시스템
// 골프장 이용객을 위한 고급스러운 디자인 토큰

export const designTokens = {
  // 호주 프리미엄 골프장 색상 시스템
  colors: {
    // Primary - 호주 대지에서 영감받은 테라코타 계열
    primary: {
      50: '#FEF7F0',   // 매우 연한 테라코타
      100: '#FEE7D6',  // 연한 테라코타
      200: '#FDD0AD',  // 밝은 테라코타
      300: '#FCB584',  // 중간 밝은 테라코타
      400: '#FB9A5B',  // 중간 테라코타
      500: '#D97706',  // 메인 테라코타 (호주 대지)
      600: '#B45309',  // 진한 테라코타
      700: '#92400E',  // 매우 진한 테라코타
      800: '#78350F',  // 어두운 테라코타
      900: '#451A03',  // 가장 어두운 테라코타
      950: '#1C0A00',  // 거의 검은 테라코타
    },
    
    // Secondary - 호주 골드 러시에서 영감받은 골드 계열
    secondary: {
      50: '#FFFBEB',
      100: '#FEF3C7',
      200: '#FDE68A',
      300: '#FCD34D',
      400: '#FBBF24',
      500: '#F59E0B',  // 호주 골드
      600: '#D97706',
      700: '#B45309',
      800: '#92400E',
      900: '#78350F',
      950: '#451A03',
      blue: '#1E3A8A', // 호주 바다 블루 (기존 호환성)
    },
    
    // Neutral - 고급스러운 그레이 스케일
    neutral: {
      0: '#FFFFFF',    // 순백색
      50: '#FAFAFA',   // 거의 흰색
      100: '#F5F5F5',  // 매우 연한 그레이
      200: '#E5E5E5',  // 연한 그레이
      300: '#D4D4D4',  // 중간 연한 그레이
      400: '#A3A3A3',  // 중간 그레이
      500: '#737373',  // 중간 진한 그레이
      600: '#525252',  // 진한 그레이
      700: '#404040',  // 매우 진한 그레이
      800: '#262626',  // 어두운 그레이
      900: '#171717',  // 거의 검은 그레이
      950: '#0A0A0A',  // 거의 검은색
    },
    
    // Accent - 호주 자연에서 영감받은 포인트 컬러
    accent: {
      gold: '#F59E0B',      // 호주 골드 러시
      bronze: '#CD7F32',     // 호주 브론즈
      navy: '#1E3A8A',       // 호주 해군 블루
      cream: '#F5F5DC',      // 호주 크림 (클럽하우스)
      eucalyptus: '#22C55E', // 유칼립투스 그린
      sandstone: '#D97706',  // 호주 사암
    },
    
    // Semantic Colors
    success: {
      50: '#F0FDF4',
      100: '#DCFCE7',
      200: '#BBF7D0',
      500: '#22C55E',
      600: '#16A34A',
      700: '#15803D',
      800: '#166534',
    },
    warning: {
      50: '#FFFBEB',
      100: '#FEF3C7',
      200: '#FDE68A',
      500: '#F59E0B',
      600: '#D97706',
      700: '#B45309',
      800: '#92400E',
    },
    error: {
      50: '#FEF2F2',
      100: '#FEE2E2',
      200: '#FECACA',
      500: '#EF4444',
      600: '#DC2626',
      700: '#B91C1C',
      800: '#991B1B',
    },
    info: {
      50: '#EFF6FF',
      100: '#DBEAFE',
      200: '#BFDBFE',
      500: '#3B82F6',
      600: '#2563EB',
      700: '#1D4ED8',
      800: '#1E40AF',
    },

    // Text Colors
    text: {
      primary: '#1F2937', // Neutral 800
      secondary: '#6B7280', // Neutral 500
      tertiary: '#9CA3AF', // Neutral 400
      disabled: '#D1D5DB', // Neutral 300
      inverse: '#FFFFFF', // White
    },

    // Border Colors
    border: {
      light: '#E5E7EB', // Neutral 200
      medium: '#D1D5DB', // Neutral 300
      dark: '#9CA3AF', // Neutral 400
    },

    // Background Colors
    background: {
      light: '#F9FAFB', // Neutral 50
      medium: '#F3F4F6', // Neutral 100
      dark: '#E5E7EB', // Neutral 200
    },

    // Gradients for special elements - 호주 자연에서 영감
    gradient: {
      terracotta: 'linear-gradient(135deg, #FB9A5B 0%, #D97706 100%)', // 호주 대지
      gold: 'linear-gradient(135deg, #FBBF24 0%, #F59E0B 100%)', // 호주 골드 러시
      eucalyptus: 'linear-gradient(135deg, #4ADE80 0%, #22C55E 100%)', // 유칼립투스
      sunset: 'linear-gradient(135deg, #F59E0B 0%, #D97706 100%)', // 호주 석양
      sandstone: 'linear-gradient(135deg, #FDD0AD 0%, #D97706 100%)', // 호주 사암
      blue: 'linear-gradient(135deg, #1E3A8A 0%, #1D4ED8 100%)', // 호주 바다 (기존 호환성)
    },
  },
  
  // 타이포그래피 시스템
  typography: {
    fontFamily: {
      sans: [
        'Inter',
        '-apple-system',
        'BlinkMacSystemFont',
        '"Segoe UI"',
        'Roboto',
        '"Helvetica Neue"',
        'Arial',
        'sans-serif'
      ],
      serif: [
        'Playfair Display',
        'Georgia',
        'Cambria',
        '"Times New Roman"',
        'Times',
        'serif'
      ],
      mono: [
        'JetBrains Mono',
        'Menlo',
        'Monaco',
        'Consolas',
        '"Liberation Mono"',
        '"Courier New"',
        'monospace'
      ],
    },
    
    fontSize: {
      xs: '0.75rem',      // 12px
      sm: '0.875rem',     // 14px
      base: '1rem',       // 16px
      lg: '1.125rem',     // 18px
      xl: '1.25rem',      // 20px
      '2xl': '1.5rem',    // 24px
      '3xl': '1.875rem',  // 30px
      '4xl': '2.25rem',   // 36px
      '5xl': '3rem',      // 48px
      '6xl': '3.75rem',   // 60px
      '7xl': '4.5rem',    // 72px
      '8xl': '6rem',      // 96px
      '9xl': '8rem',      // 128px
    },
    
    fontWeight: {
      thin: 100,
      extralight: 200,
      light: 300,
      normal: 400,
      medium: 500,
      semibold: 600,
      bold: 700,
      extrabold: 800,
      black: 900,
    },
    
    lineHeight: {
      none: 1,
      tight: 1.25,
      snug: 1.375,
      normal: 1.5,
      relaxed: 1.625,
      loose: 2,
    },
    
    letterSpacing: {
      tighter: '-0.05em',
      tight: '-0.025em',
      normal: '0em',
      wide: '0.025em',
      wider: '0.05em',
      widest: '0.1em',
    },
  },
  
  // 스페이싱 시스템 (8px 기반)
  spacing: {
    0: '0px',
    1: '0.25rem',   // 4px
    2: '0.5rem',    // 8px
    3: '0.75rem',   // 12px
    4: '1rem',      // 16px
    5: '1.25rem',   // 20px
    6: '1.5rem',    // 24px
    7: '1.75rem',   // 28px
    8: '2rem',      // 32px
    9: '2.25rem',   // 36px
    10: '2.5rem',   // 40px
    11: '2.75rem',  // 44px
    12: '3rem',     // 48px
    14: '3.5rem',   // 56px
    16: '4rem',     // 64px
    20: '5rem',     // 80px
    24: '6rem',     // 96px
    28: '7rem',     // 112px
    32: '8rem',     // 128px
    36: '9rem',     // 144px
    40: '10rem',    // 160px
    44: '11rem',    // 176px
    48: '12rem',    // 192px
    52: '13rem',    // 208px
    56: '14rem',    // 224px
    60: '15rem',    // 240px
    64: '16rem',    // 256px
    72: '18rem',    // 288px
    80: '20rem',    // 320px
    96: '24rem',    // 384px
    // 기존 호환성을 위한 별칭
    xs: '0.5rem',   // 8px
    sm: '0.75rem',  // 12px
    md: '1rem',     // 16px
    lg: '1.5rem',   // 24px
    xl: '2rem',     // 32px
    '2xl': '3rem',  // 48px
    '3xl': '4rem',  // 64px
    '4xl': '6rem',  // 96px
    '5xl': '8rem',  // 128px
  },
  
  // 보더 반경 시스템
  borderRadius: {
    none: '0px',
    sm: '0.125rem',   // 2px
    base: '0.25rem',  // 4px
    md: '0.375rem',   // 6px
    lg: '0.5rem',     // 8px
    xl: '0.75rem',    // 12px
    '2xl': '1rem',    // 16px
    '3xl': '1.5rem',  // 24px
    full: '9999px',
    phone: '2.5rem',  // 40px - 폰 프레임용
  },
  
  // 그림자 시스템
  boxShadow: {
    xs: '0 1px 2px 0 rgb(0 0 0 / 0.05)',
    sm: '0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)',
    base: '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)',
    md: '0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)',
    lg: '0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)',
    xl: '0 25px 50px -12px rgb(0 0 0 / 0.25)',
    '2xl': '0 25px 50px -12px rgb(0 0 0 / 0.25)',
    inner: 'inset 0 2px 4px 0 rgb(0 0 0 / 0.05)',
    none: '0 0 #0000',
  },
  
  // 애니메이션 시스템
  animation: {
    duration: {
      fast: '150ms',
      normal: '200ms',
      slow: '300ms',
      slower: '500ms',
    },
    easing: {
      linear: 'linear',
      in: 'cubic-bezier(0.4, 0, 1, 1)',
      out: 'cubic-bezier(0, 0, 0.2, 1)',
      inOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
    },
  },
  
  // Z-Index 시스템
  zIndex: {
    hide: -1,
    auto: 'auto',
    base: 0,
    docked: 10,
    dropdown: 1000,
    sticky: 1100,
    banner: 1200,
    overlay: 1300,
    modal: 1400,
    popover: 1500,
    skipLink: 1600,
    toast: 1700,
    tooltip: 1800,
  },

  // iPhone 16 Pro 프레임 관련 (최신 사양)
  phone: {
    // 물리적 해상도: 2622 × 1206 px (3x Retina)
    // CSS 뷰포트: 402 × 874 px
    // 물리적 크기: 149.6 × 71.5 × 8.3 mm
    width: '402px',
    height: '874px',
    notch: {
      width: '126px',  // Dynamic Island 폭
      height: '37px',  // Dynamic Island 높이
      top: '0px',
      borderRadius: '18.5px', // Dynamic Island 둥근 모서리
    },
    safeArea: {
      top: '59px',     // Dynamic Island + Status Bar
      bottom: '34px',  // Home Indicator
      left: '0px',
      right: '0px',
    },
    borderRadius: '47px', // 화면 모서리 라운드 처리
    frameThickness: '8.3mm',
  },

  // 그림자 시스템 (기존 boxShadow와 호환)
  shadows: {
    sm: '0 1px 2px 0 rgb(0 0 0 / 0.05)',
    md: '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)',
    lg: '0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)',
    xl: '0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)',
    '2xl': '0 25px 50px -12px rgb(0 0 0 / 0.25)',
  },
  
  // 브레이크포인트 시스템
  breakpoints: {
    xs: '475px',
    sm: '640px',
    md: '768px',
    lg: '1024px',
    xl: '1280px',
    '2xl': '1536px',
  },
  
  // iPhone 16 Pro 최신 글로벌 앱 트렌드 네비게이션
  navigation: {
    // Flat + Minimal + Adaptive 스타일
    style: 'flat-minimal-adaptive',
    height: '88px', // iPhone 16 Pro 하단 네비게이션 높이
    backgroundColor: 'rgba(255, 255, 255, 0.95)',
    backdropFilter: 'blur(20px)',
    borderTop: '1px solid rgba(0, 0, 0, 0.1)',
    borderRadius: '0px', // 하단은 라운드 처리 안함
    padding: {
      horizontal: '20px',
      vertical: '8px',
    },
    // 탭 아이템 스타일
    tabItem: {
      height: '72px',
      borderRadius: '12px',
      padding: '8px 12px',
      gap: '4px',
      // 선택된 상태
      selected: {
        backgroundColor: 'rgba(217, 119, 6, 0.1)',
        color: '#B45309', // primary[600]
        fontWeight: '600',
      },
      // 비선택 상태
      unselected: {
        backgroundColor: 'transparent',
        color: '#6B7280', // text.secondary
        fontWeight: '400',
      },
    },
  },

  // 글로벌 골프 라운딩 앱 디자인 시스템
  golf: {
    // 상태별 컬러 시스템 (Apple HIG + Material 3 기준)
    status: {
      scheduled: {
        primary: '#F59E0B',    // 주황 (예정)
        secondary: '#FEF3C7',  // 연한 주황
        accent: '#D97706',     // 진한 주황
      },
      inProgress: {
        primary: '#3B82F6',    // 파랑 (진행)
        secondary: '#DBEAFE',  // 연한 파랑
        accent: '#1D4ED8',     // 진한 파랑
      },
      completed: {
        primary: '#6B7280',    // 회색 (완료)
        secondary: '#F3F4F6',  // 연한 회색
        accent: '#374151',     // 진한 회색
      },
    },
    
    // 골프 특화 그라데이션 (은은한 골프 아이덴티티)
    gradients: {
      fairway: 'linear-gradient(135deg, #22C55E 0%, #16A34A 100%)', // 페어웨이 그린
      sand: 'linear-gradient(135deg, #FDD0AD 0%, #FCB584 100%)',     // 벙커 샌드
      sky: 'linear-gradient(135deg, #FEF3C7 0%, #FDE68A 100%)',       // 하늘색
      ocean: 'linear-gradient(135deg, #1E3A8A 0%, #1D4ED8 100%)',    // 바다색
      sunset: 'linear-gradient(135deg, #F59E0B 0%, #D97706 100%)',    // 석양색
    },
    
    // 벡터 기반 커스텀 아이콘 시스템 (이모지 완전 금지)
    icons: {
      // 네비게이션 아이콘
      home: 'home-outline',
      homeFilled: 'home-filled',
      rounding: 'calendar-outline',
      roundingFilled: 'calendar-filled',
      groups: 'users-outline',
      groupsFilled: 'users-filled',
      score: 'chart-outline',
      scoreFilled: 'chart-filled',
      profile: 'user-outline',
      profileFilled: 'user-filled',
      
      // 골프 특화 아이콘 (일관된 라인 굵기와 둥근 느낌)
      golfBall: 'golf-ball',
      flag: 'flag',
      club: 'golf-club',
      trophy: 'trophy',
      tee: 'tee',
      green: 'green',
      
      // 날씨 아이콘
      sunny: 'sunny',
      cloudy: 'cloudy',
      rainy: 'rainy',
      windy: 'windy',
      
      // 참가자 아이콘
      user: 'user',
      users: 'users',
      avatar: 'avatar',
    },
    
    // 카드 디자인 시스템
    card: {
      borderRadius: '16px',
      shadow: {
        sm: '0 2px 8px rgba(0, 0, 0, 0.08)',
        md: '0 4px 16px rgba(0, 0, 0, 0.12)',
        lg: '0 8px 24px rgba(0, 0, 0, 0.16)',
      },
      padding: {
        sm: '16px',
        md: '20px',
        lg: '24px',
      },
    },
    
    // 네비게이션 디자인 시스템
    navigation: {
      height: '88px',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      backdropFilter: 'blur(20px)',
      borderTop: '1px solid rgba(0, 0, 0, 0.08)',
      tabItem: {
        height: '72px',
        borderRadius: '12px',
        padding: '8px 12px',
        gap: '4px',
        selected: {
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          color: '#3B82F6',
          fontWeight: '600',
        },
        unselected: {
          backgroundColor: 'transparent',
          color: '#6B7280',
          fontWeight: '400',
        },
      },
    },
  },
} as const;

// 타입 정의
export type DesignTokens = typeof designTokens;
export type ColorScale = keyof typeof designTokens.colors.primary;
export type SpacingScale = keyof typeof designTokens.spacing;
export type FontSizeScale = keyof typeof designTokens.typography.fontSize;
export type FontWeightScale = keyof typeof designTokens.typography.fontWeight;