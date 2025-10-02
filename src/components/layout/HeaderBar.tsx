'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface HeaderBarProps {
  title?: string;
  showBackButton?: boolean;
  showMenuButton?: boolean;
  onBack?: () => void;
  onMenu?: () => void;
  rightButton?: React.ReactNode;
}

export const HeaderBar: React.FC<HeaderBarProps> = ({
  title,
  showBackButton = false,
  showMenuButton = false,
  onBack,
  onMenu,
  rightButton,
}) => {
  return (
    <div
      className="flex justify-between items-center"
      style={{
        padding: `${designTokens.spacing.xl} ${designTokens.spacing['3xl']} ${designTokens.spacing['2xl']}`,
      }}
    >
      {/* 왼쪽 버튼 */}
      <div className="flex-shrink-0">
        {showBackButton ? (
          <motion.button
            onClick={onBack}
            className="flex items-center justify-center cursor-pointer transition-all duration-200 border-none"
            style={{
              width: '44px',
              height: '44px',
              borderRadius: designTokens.borderRadius.full,
              background: '#f8f8f8',
              fontSize: designTokens.typography.fontSize['2xl'],
              color: designTokens.colors.text.primary,
            }}
            whileHover={{ 
              background: '#efefef',
              scale: 1.05 
            }}
            whileTap={{ scale: 0.95 }}
          >
            ←
          </motion.button>
        ) : showMenuButton ? (
          <motion.button
            onClick={onMenu}
            className="flex items-center justify-center cursor-pointer transition-all duration-200 border-none"
            style={{
              width: '44px',
              height: '44px',
              borderRadius: designTokens.borderRadius.full,
              background: '#f8f8f8',
              fontSize: designTokens.typography.fontSize.xl,
              color: designTokens.colors.text.primary,
            }}
            whileHover={{ 
              background: '#efefef',
              scale: 1.05 
            }}
            whileTap={{ scale: 0.95 }}
          >
            ☰
          </motion.button>
        ) : (
          <div style={{ width: '44px' }} />
        )}
      </div>

      {/* 제목 */}
      {title && (
        <div
          className="flex-1 text-center"
          style={{
            fontSize: designTokens.typography.fontSize['3xl'],
            fontWeight: designTokens.typography.fontWeight.bold,
            color: designTokens.colors.text.primary,
            letterSpacing: designTokens.typography.letterSpacing.tight,
            margin: `0 ${designTokens.spacing.xl}`,
          }}
        >
          {title}
        </div>
      )}

      {/* 오른쪽 버튼 */}
      <div className="flex-shrink-0">
        {rightButton || <div style={{ width: '44px' }} />}
      </div>
    </div>
  );
};

export default HeaderBar;


