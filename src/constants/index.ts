// 공통 상수 정의
export const SPACING = {
  xs: '4px',
  sm: '8px',
  md: '12px',
  lg: '16px',
  xl: '20px',
  '2xl': '24px',
  '3xl': '32px',
  '4xl': '48px',
  '5xl': '64px',
} as const;

export const COLORS = {
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
  danger: {
    red: '#EF4444',
    redDark: '#DC2626',
    redLight: '#F87171',
  },
  gray: {
    50: '#F9FAFB',
    100: '#F3F4F6',
    200: '#E5E7EB',
    300: '#D1D5DB',
    400: '#9CA3AF',
    500: '#6B7280',
    600: '#4B5563',
    700: '#374151',
    800: '#1F2937',
    900: '#111827',
  },
  text: {
    primary: '#1F2937',
    secondary: '#6B7280',
    tertiary: '#9CA3AF',
    inverse: '#FFFFFF',
  },
} as const;

export const FONT_SIZES = {
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
} as const;

export const FONT_WEIGHTS = {
  normal: 400,
  medium: 500,
  semibold: 600,
  bold: 700,
  extraBold: 800,
} as const;

export const BORDER_RADIUS = {
  sm: '6px',
  md: '8px',
  lg: '12px',
  xl: '16px',
  '2xl': '20px',
  '3xl': '24px',
  full: '50%',
  phone: '38px',
} as const;

export const SHADOWS = {
  sm: '0 1px 4px rgba(0,0,0,0.08)',
  md: '0 2px 8px rgba(0,0,0,0.08)',
  lg: '0 3px 24px rgba(0,0,0,0.08)',
  xl: '0 8px 80px rgba(0,0,0,0.25)',
  card: '0 1px 12px rgba(0,0,0,0.04)',
} as const;

export const AVATAR_COLORS = [
  ['#2563EB', '#1D4ED8'], // Blue
  ['#10B981', '#059669'], // Green
  ['#F59E0B', '#D97706'], // Yellow/Orange
  ['#EF4444', '#DC2626'], // Red
  ['#8B5CF6', '#7C3AED'], // Purple
  ['#06B6D4', '#0891B2'], // Cyan
  ['#84CC16', '#65A30D'], // Lime
  ['#F97316', '#EA580C'], // Orange
] as const;

export const ANIMATION_DURATION = {
  fast: 150,
  normal: 200,
  slow: 300,
} as const;

export const BREAKPOINTS = {
  sm: '640px',
  md: '768px',
  lg: '1024px',
  xl: '1280px',
  '2xl': '1536px',
} as const;

export const Z_INDEX = {
  dropdown: 1000,
  sticky: 1020,
  fixed: 1030,
  modalBackdrop: 1040,
  modal: 1050,
  popover: 1060,
  tooltip: 1070,
} as const;