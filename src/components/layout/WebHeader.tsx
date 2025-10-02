import React from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

const WebHeader: React.FC = () => {
  const { activeTab } = useAppStore();

  const getPageTitle = () => {
    switch (activeTab) {
      case 'home': return '홈';
      case 'rounding': return '라운딩';
      case 'groups': return '동문회';
      case 'score': return '스코어';
      case 'profile': return '프로필';
      default: return 'MTCN';
    }
  };

  const getPageIcon = () => {
    switch (activeTab) {
      case 'home': return 'home';
      case 'rounding': return 'golf-ball';
      case 'groups': return 'users';
      case 'score': return 'chart';
      case 'profile': return 'user';
      default: return 'golf-ball';
    }
  };

  return (
    <motion.div
      initial={{ y: -100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.5, delay: 0.1 }}
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        backgroundColor: designTokens.colors.neutral[0],
        borderBottom: `1px solid ${designTokens.colors.neutral[200]}`,
        boxShadow: '0 2px 20px rgba(0, 0, 0, 0.1)',
        zIndex: 1000,
        padding: `${designTokens.spacing.md} 0`,
        backdropFilter: 'blur(20px)',
      }}
    >
      <div style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        maxWidth: '480px',
        margin: '0 auto',
        padding: `0 ${designTokens.spacing.lg}`,
        gap: designTokens.spacing.sm,
      }}>
        <div style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          width: '32px',
          height: '32px',
          backgroundColor: designTokens.colors.primary[100],
          borderRadius: designTokens.borderRadius.lg,
        }}>
          {getIconComponent(getPageIcon(), { 
            size: 20, 
            color: designTokens.colors.primary[600],
            filled: true
          })}
        </div>
        <h1 style={{
          fontSize: designTokens.typography.fontSize.xl,
          fontWeight: designTokens.typography.fontWeight.semibold,
          color: designTokens.colors.text.primary,
          margin: 0,
        }}>
          {getPageTitle()}
        </h1>
      </div>
    </motion.div>
  );
};

export default WebHeader;
