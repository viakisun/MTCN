import React from 'react';
import { designTokens } from '@/styles/design-tokens';

// 골프 특화 벡터 아이콘 컴포넌트들 (일관된 라인 굵기와 둥근 느낌)

interface IconProps {
  size?: number;
  color?: string;
  filled?: boolean;
}

export const GolfBallIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <circle cx="12" cy="12" r="10" fill={filled ? color : 'none'} />
    <path d="M8 12h8M12 8v8" stroke={color} strokeWidth="1.5" />
  </svg>
);

export const FlagIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z" fill={filled ? color : 'none'} />
    <line x1="4" y1="22" x2="4" y2="15" />
  </svg>
);

export const GolfClubIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M3 21h18M5 21V7l8-4v18M13 3l5 5" fill={filled ? color : 'none'} />
  </svg>
);

export const TrophyIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M6 9H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h2M18 9h2a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2h-2M4 22h16M10 14.66V17c0 .55.47.98.97 1.21l1.03.34c.15.05.34.05.49 0l1.03-.34c.5-.23.97-.66.97-1.21v-2.34" fill={filled ? color : 'none'} />
    <path d="M18 2H6v7a6 6 0 0 0 12 0V2Z" fill={filled ? color : 'none'} />
  </svg>
);

export const TeeIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M12 2L8 8h8l-4-6z" fill={filled ? color : 'none'} />
    <line x1="12" y1="8" x2="12" y2="22" />
  </svg>
);

export const GreenIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <circle cx="12" cy="12" r="10" fill={filled ? color : 'none'} />
    <path d="M8 12h8M12 8v8" stroke={color} strokeWidth="1" />
  </svg>
);

// 날씨 아이콘들
export const SunnyIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.warning[500],
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <circle cx="12" cy="12" r="5" fill={filled ? color : 'none'} />
    <path d="M12 1v2M12 21v2M4.22 4.22l1.42 1.42M18.36 18.36l1.42 1.42M1 12h2M21 12h2M4.22 19.78l1.42-1.42M18.36 5.64l1.42-1.42" />
  </svg>
);

export const CloudyIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.secondary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z" fill={filled ? color : 'none'} />
  </svg>
);

export const RainyIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.info[500],
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M18 10h-1.26A8 8 0 1 0 9 20h9a5 5 0 0 0 0-10z" fill={filled ? color : 'none'} />
    <path d="M8 16l2-4M12 16l2-4M16 16l2-4" />
  </svg>
);

export const WindyIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.secondary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M17.7 7.7a2.5 2.5 0 1 1 1.8 4.3H2M9.6 4.6A2 2 0 1 1 11 8H2M12.6 19.4A2 2 0 1 0 14 16H2" />
  </svg>
);

// 참가자 아이콘들
export const UserIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" fill={filled ? color : 'none'} />
    <circle cx="12" cy="7" r="4" fill={filled ? color : 'none'} />
  </svg>
);

export const UsersIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" fill={filled ? color : 'none'} />
    <circle cx="9" cy="7" r="4" fill={filled ? color : 'none'} />
    <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
  </svg>
);

// 네비게이션 아이콘들
export const HomeIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    {filled ? (
      <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" fill={color} />
    ) : (
      <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z" />
    )}
    <polyline points="9,22 9,12 15,12 15,22" />
  </svg>
);

export const CalendarIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" fill={filled ? color : 'none'} />
    <line x1="16" y1="2" x2="16" y2="6" />
    <line x1="8" y1="2" x2="8" y2="6" />
    <line x1="3" y1="10" x2="21" y2="10" />
  </svg>
);

export const ChartIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <line x1="18" y1="20" x2="18" y2="10" fill={filled ? color : 'none'} />
    <line x1="12" y1="20" x2="12" y2="4" fill={filled ? color : 'none'} />
    <line x1="6" y1="20" x2="6" y2="14" fill={filled ? color : 'none'} />
  </svg>
);

export const ProfileIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.primary,
  filled = false 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" fill={filled ? color : 'none'} />
    <circle cx="12" cy="7" r="4" fill={filled ? color : 'none'} />
  </svg>
);

// Search Icon
export const SearchIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <circle cx="11" cy="11" r="8" />
    <path d="m21 21-4.35-4.35" />
  </svg>
);

// Close Icon
export const CloseIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <line x1="18" y1="6" x2="6" y2="18" />
    <line x1="6" y1="6" x2="18" y2="18" />
  </svg>
);

// Filter Icon
export const FilterIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <polygon points="22,3 2,3 10,12.46 10,19 14,21 14,12.46" />
  </svg>
);

// Clock Icon
export const ClockIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <circle cx="12" cy="12" r="10" />
    <polyline points="12,6 12,12 16,14" />
  </svg>
);

// Location Icon
export const LocationIcon: React.FC<IconProps> = ({ 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
    <circle cx="12" cy="10" r="3" />
  </svg>
);

// 아이콘 매핑 함수
export const getIconComponent = (iconName: string, props: IconProps = {}) => {
  const iconMap: { [key: string]: React.ComponentType<IconProps> } = {
    // 골프 아이콘
    'golf-ball': GolfBallIcon,
    'flag': FlagIcon,
    'golf-club': GolfClubIcon,
    'trophy': TrophyIcon,
    'tee': TeeIcon,
    'green': GreenIcon,
    
    // 날씨 아이콘
    'sunny': SunnyIcon,
    'cloudy': CloudyIcon,
    'rainy': RainyIcon,
    'windy': WindyIcon,
    
    // 참가자 아이콘
    'user': UserIcon,
    'users': UsersIcon,
    
    // 네비게이션 아이콘
    'home': HomeIcon,
    'calendar': CalendarIcon,
    'chart': ChartIcon,
    'profile': ProfileIcon,
    
    // 필터링 아이콘
    'search': SearchIcon,
    'close': CloseIcon,
    'filter': FilterIcon,
    'clock': ClockIcon,
    'location': LocationIcon,
  };
  
  const IconComponent = iconMap[iconName];
  return IconComponent ? <IconComponent {...props} /> : null;
};
