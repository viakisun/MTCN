'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

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

const navItems: NavItem[] = [
  { id: 'home', icon: '🏠', label: '홈' },
  { id: 'rounding', icon: '🌍', label: '라운딩' },
  { id: 'groups', icon: '👥', label: '동문회' },
  { id: 'score', icon: '📊', label: '스코어' },
  { id: 'profile', icon: '👤', label: '프로필' },
];

export const BottomNav: React.FC<BottomNavProps> = ({ activeTab, onTabChange }) => {
  return (
    <motion.div
      initial={{ y: 100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ delay: 0.3, duration: 0.5 }}
      className="relative z-30"
      style={{
        background: 'rgba(255, 255, 255, 0.95)',
        backdropFilter: 'blur(20px)',
        borderTop: '1px solid rgba(0, 0, 0, 0.1)',
        padding: `${designTokens.spacing.lg} 0 ${designTokens.spacing.lg}`,
        borderRadius: `0 0 ${designTokens.borderRadius.phone} ${designTokens.borderRadius.phone}`,
        flexShrink: 0
      }}
    >
      <div className="flex">
        {navItems.map((item) => (
          <motion.button
            key={item.id}
            onClick={() => onTabChange(item.id)}
            className="flex-1 text-center cursor-pointer transition-all duration-200"
            style={{
              color: activeTab === item.id ? designTokens.colors.secondary.blue : designTokens.colors.text.disabled,
              fontSize: designTokens.typography.fontSize.xs,
              fontWeight: designTokens.typography.fontWeight.medium,
              letterSpacing: designTokens.typography.letterSpacing.wide,
              lineHeight: designTokens.typography.lineHeight.tight,
              padding: `${designTokens.spacing.md} ${designTokens.spacing.xs}`,
            }}
            whileTap={{ scale: 0.95 }}
            whileHover={{ scale: 1.05 }}
          >
            <div className="flex flex-col items-center justify-center">
              <div
                className="mb-1"
                style={{
                  fontSize: designTokens.typography.fontSize['3xl'],
                }}
              >
                {item.icon}
              </div>
              <div>{item.label}</div>
            </div>
          </motion.button>
        ))}
      </div>
    </motion.div>
  );
};

export default BottomNav;


