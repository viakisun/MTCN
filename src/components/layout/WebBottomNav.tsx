import React from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

const WebBottomNav: React.FC = () => {
  const { activeTab, setActiveTab } = useAppStore();

  const tabs = [
    { id: 'home', label: '홈', icon: 'home' },
    { id: 'rounding', label: '라운딩', icon: 'golf-ball' },
    { id: 'groups', label: '동문회', icon: 'users' },
    { id: 'score', label: '스코어', icon: 'chart' },
    { id: 'profile', label: '프로필', icon: 'user' },
  ];

  return (
    <motion.div
      initial={{ y: 100, opacity: 0 }}
      animate={{ y: 0, opacity: 1 }}
      transition={{ duration: 0.5, delay: 0.3 }}
      style={{
        position: 'fixed',
        bottom: 0,
        left: 0,
        right: 0,
        backgroundColor: designTokens.colors.neutral[0],
        borderTop: `1px solid ${designTokens.colors.neutral[200]}`,
        boxShadow: '0 -4px 20px rgba(0, 0, 0, 0.1)',
        zIndex: 1000,
        padding: `${designTokens.spacing.sm} 0`,
        backdropFilter: 'blur(20px)',
      }}
    >
      <div style={{
        display: 'flex',
        justifyContent: 'space-around',
        alignItems: 'center',
        maxWidth: '480px',
        margin: '0 auto',
        padding: `0 ${designTokens.spacing.md}`,
      }}>
        {tabs.map((tab) => {
          const isActive = activeTab === tab.id;
          
          return (
            <motion.button
              key={tab.id}
              onClick={() => setActiveTab(tab.id as any)}
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.05 }}
              style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: designTokens.spacing.xs,
                padding: `${designTokens.spacing.sm} ${designTokens.spacing.md}`,
                borderRadius: designTokens.borderRadius.lg,
                border: 'none',
                background: 'transparent',
                cursor: 'pointer',
                transition: 'all 0.2s ease',
                minWidth: '60px',
              }}
            >
              <div style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                width: '24px',
                height: '24px',
                color: isActive ? designTokens.colors.primary[600] : designTokens.colors.text.secondary,
                transition: 'color 0.2s ease',
              }}>
                {getIconComponent(tab.icon, { 
                  size: 20, 
                  color: isActive ? designTokens.colors.primary[600] : designTokens.colors.text.secondary,
                  filled: isActive
                })}
              </div>
              <span style={{
                fontSize: designTokens.typography.fontSize.xs,
                fontWeight: isActive ? designTokens.typography.fontWeight.semibold : designTokens.typography.fontWeight.medium,
                color: isActive ? designTokens.colors.primary[600] : designTokens.colors.text.secondary,
                transition: 'all 0.2s ease',
              }}>
                {tab.label}
              </span>
              {isActive && (
                <motion.div
                  initial={{ scaleX: 0 }}
                  animate={{ scaleX: 1 }}
                  transition={{ duration: 0.2 }}
                  style={{
                    position: 'absolute',
                    bottom: 0,
                    left: '50%',
                    transform: 'translateX(-50%)',
                    width: '20px',
                    height: '2px',
                    backgroundColor: designTokens.colors.primary[600],
                    borderRadius: designTokens.borderRadius.full,
                  }}
                />
              )}
            </motion.button>
          );
        })}
      </div>
    </motion.div>
  );
};

export default WebBottomNav;
