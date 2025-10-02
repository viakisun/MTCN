'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent as getGolfIcon } from '@/components/icons/GolfIcons';

interface NavItem {
  id: string;
  icon: string;
  label: string;
  href?: string;
  onClick?: () => void;
}

interface BottomNavProps {
  activeTab: string;
  onTabChange: (tabId: string) => void;
}

// 벡터 기반 커스텀 아이콘 컴포넌트들 (이모지 금지)
const HomeIcon: React.FC<{ filled?: boolean; size?: number; color?: string }> = ({ 
  filled = false, 
  size = 24, 
  color = designTokens.colors.text.secondary 
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

const CalendarIcon: React.FC<{ filled?: boolean; size?: number; color?: string }> = ({ 
  filled = false, 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <rect x="3" y="4" width="18" height="18" rx="2" ry="2" fill={filled ? color : 'none'} />
    <line x1="16" y1="2" x2="16" y2="6" />
    <line x1="8" y1="2" x2="8" y2="6" />
    <line x1="3" y1="10" x2="21" y2="10" />
  </svg>
);

const UsersIcon: React.FC<{ filled?: boolean; size?: number; color?: string }> = ({ 
  filled = false, 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2" fill={filled ? color : 'none'} />
    <circle cx="9" cy="7" r="4" fill={filled ? color : 'none'} />
    <path d="M23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" />
  </svg>
);

const ChartIcon: React.FC<{ filled?: boolean; size?: number; color?: string }> = ({ 
  filled = false, 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <line x1="18" y1="20" x2="18" y2="10" fill={filled ? color : 'none'} />
    <line x1="12" y1="20" x2="12" y2="4" fill={filled ? color : 'none'} />
    <line x1="6" y1="20" x2="6" y2="14" fill={filled ? color : 'none'} />
  </svg>
);

const UserIcon: React.FC<{ filled?: boolean; size?: number; color?: string }> = ({ 
  filled = false, 
  size = 24, 
  color = designTokens.colors.text.secondary 
}) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke={color} strokeWidth="2">
    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" fill={filled ? color : 'none'} />
    <circle cx="12" cy="7" r="4" fill={filled ? color : 'none'} />
  </svg>
);

const getIconComponent = (iconName: string, isActive: boolean) => {
  const color = isActive ? designTokens.colors.secondary.blue : designTokens.colors.text.disabled;
  
  switch (iconName) {
    case 'home':
      return <HomeIcon filled={isActive} size={24} color={color} />;
    case 'calendar':
      return <CalendarIcon filled={isActive} size={24} color={color} />;
    case 'users':
      return <UsersIcon filled={isActive} size={24} color={color} />;
    case 'chart':
      return <ChartIcon filled={isActive} size={24} color={color} />;
    case 'user':
      return <UserIcon filled={isActive} size={24} color={color} />;
    default:
      return null;
  }
};

const navItems: NavItem[] = [
  { id: 'home', icon: 'home', label: '홈' },
  { id: 'rounding', icon: 'calendar', label: '라운딩' },
  { id: 'groups', icon: 'users', label: '동문회' },
  { id: 'score', icon: 'chart', label: '스코어' },
  { id: 'profile', icon: 'user', label: '프로필' },
];

export const BottomNav: React.FC<BottomNavProps> = ({ activeTab, onTabChange }) => {
  return (
    <motion.div
      initial={{ y: 100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.3, duration: 0.5 }}
      style={{
        height: designTokens.golf.navigation.height,
        background: designTokens.golf.navigation.backgroundColor,
        backdropFilter: designTokens.golf.navigation.backdropFilter,
        borderTop: designTokens.golf.navigation.borderTop,
        borderRadius: `0 0 ${designTokens.borderRadius.phone} ${designTokens.borderRadius.phone}`,
        padding: `${designTokens.spacing.md} ${designTokens.spacing.lg}`,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-around',
        position: 'relative',
        zIndex: 50,
      }}
    >
      {navItems.map((item) => {
        const isActive = activeTab === item.id;
        const tabConfig = isActive 
          ? designTokens.golf.navigation.tabItem.selected 
          : designTokens.golf.navigation.tabItem.unselected;
        
        return (
          <motion.button
            key={item.id}
            onClick={() => onTabChange(item.id)}
            whileTap={{ scale: 0.95 }}
            whileHover={{ scale: 1.05 }}
            style={{
              height: designTokens.golf.navigation.tabItem.height,
              borderRadius: designTokens.golf.navigation.tabItem.borderRadius,
              padding: designTokens.golf.navigation.tabItem.padding,
              display: 'flex',
              flexDirection: 'column',
              alignItems: 'center',
              justifyContent: 'center',
              gap: designTokens.golf.navigation.tabItem.gap,
              backgroundColor: tabConfig.backgroundColor,
              border: 'none',
              cursor: 'pointer',
              transition: 'all 0.2s ease',
              minWidth: '60px',
            }}
          >
            <div
              style={{
                width: '24px',
                height: '24px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              {getGolfIcon(item.icon, { 
                size: 24, 
                color: tabConfig.color,
                filled: isActive 
              })}
            </div>
            <span
              style={{
                fontSize: designTokens.typography.fontSize.xs,
                fontWeight: tabConfig.fontWeight,
                color: tabConfig.color,
                lineHeight: 1,
                letterSpacing: designTokens.typography.letterSpacing.tight,
              }}
            >
              {item.label}
            </span>
          </motion.button>
        );
      })}
    </motion.div>
  );
};

export default BottomNav;


