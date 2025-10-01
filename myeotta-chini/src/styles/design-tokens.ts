// HTML 파일에서 추출한 디자인 토큰
export const designTokens = {
  colors: {
    primary: {
      blue: '#2563EB',
      blueDark: '#1D4ED8',
      blueLight: '#3B82F6',
    },
    secondary: {
      blue: '#2E5A87',
    },
    success: {
      green: '#16A34A',
      greenDark: '#15803D',
      greenLight: '#22C55E',
    },
    warning: {
      orange: '#F59E0B',
      orangeDark: '#D97706',
      orangeLight: '#FBBF24',
    },
    background: {
      main: '#F5F7FA',
      card: '#FFFFFF',
      overlay: 'rgba(255,255,255,0.95)',
    },
    text: {
      primary: '#1a1a1a',
      secondary: '#6B7280',
      tertiary: '#9CA3AF',
      disabled: '#999',
    },
    border: {
      light: '#E6E8EC',
      medium: '#F3F4F6',
      dark: 'rgba(0,0,0,0.08)',
    },
    gradient: {
      blue: 'linear-gradient(135deg, #2563EB, #1D4ED8)',
      green: 'linear-gradient(135deg, #16A34A, #15803D)',
      red: 'linear-gradient(135deg, #DC2626, #B91C1C)',
      orange: 'linear-gradient(135deg, #F59E0B, #D97706)',
      yellow: 'linear-gradient(135deg, #FEF3C7, #FDE68A)',
    },
  },
  typography: {
    fontFamily: "'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Noto Sans KR', sans-serif",
    fontWeight: {
      normal: 500,
      medium: 600,
      bold: 700,
      extraBold: 800,
    },
    fontSize: {
      xs: '10px',
      sm: '11px',
      base: '12px',
      md: '13px',
      lg: '14px',
      xl: '15px',
      '2xl': '16px',
      '3xl': '18px',
      '4xl': '19px',
      '5xl': '20px',
      '6xl': '24px',
      '7xl': '32px',
    },
    lineHeight: {
      tight: 1.2,
      normal: 1.4,
      relaxed: 1.6,
    },
    letterSpacing: {
      tight: '-0.4px',
      normal: '-0.2px',
      wide: '-0.1px',
    },
  },
  spacing: {
    xs: '4px',
    sm: '6px',
    md: '8px',
    lg: '12px',
    xl: '16px',
    '2xl': '20px',
    '3xl': '24px',
    '4xl': '28px',
    '5xl': '32px',
  },
  borderRadius: {
    sm: '6px',
    md: '8px',
    lg: '12px',
    xl: '16px',
    '2xl': '20px',
    '3xl': '24px',
    full: '50%',
    phone: '38px',
  },
  shadows: {
    sm: '0 1px 4px rgba(0,0,0,0.08)',
    md: '0 2px 8px rgba(0,0,0,0.08)',
    lg: '0 3px 24px rgba(0,0,0,0.08)',
    xl: '0 8px 80px rgba(0,0,0,0.25)',
    card: '0 1px 12px rgba(0,0,0,0.04)',
  },
  phone: {
    width: '393px', // iPhone 16 Pro width
    height: '852px', // iPhone 16 Pro height
    borderRadius: '42px', // iPhone 16 Pro border radius
    notch: {
      width: '120px', // Dynamic Island width
      height: '6px', // Dynamic Island height
      top: '14px', // Dynamic Island position
    },
  },
  animations: {
    transition: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)',
    transitionSlow: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
    spring: {
      type: 'spring',
      stiffness: 300,
      damping: 30,
    },
  },
} as const;

export type DesignTokens = typeof designTokens;
