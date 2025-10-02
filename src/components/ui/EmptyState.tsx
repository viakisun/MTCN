import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface EmptyStateProps {
  title: string;
  description?: string;
  icon?: React.ReactNode;
  action?: {
    label: string;
    onClick: () => void;
  };
  variant?: 'default' | 'minimal' | 'illustrated';
  className?: string;
}

const EmptyState: React.FC<EmptyStateProps> = ({
  title,
  description,
  icon,
  action,
  variant = 'default',
  className = ''
}) => {
  const baseStyles: React.CSSProperties = {
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    textAlign: 'center',
    fontFamily: designTokens.typography.fontFamily.sans.join(', '),
  };

  const variantStyles = {
    default: {
      padding: designTokens.spacing[12],
      minHeight: '300px',
    },
    minimal: {
      padding: designTokens.spacing[8],
      minHeight: '200px',
    },
    illustrated: {
      padding: designTokens.spacing[16],
      minHeight: '400px',
    },
  };

  const combinedStyles = {
    ...baseStyles,
    ...variantStyles[variant],
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      style={combinedStyles}
      className={className}
    >
      {/* 아이콘 */}
      {icon && (
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{ delay: 0.2, duration: 0.3 }}
          style={{
            fontSize: variant === 'illustrated' ? '64px' : '48px',
            color: designTokens.colors.neutral[400],
            marginBottom: designTokens.spacing[6],
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          {icon}
        </motion.div>
      )}

      {/* 제목 */}
      <motion.h3
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.3, duration: 0.3 }}
        style={{
          fontSize: designTokens.typography.fontSize['2xl'],
          fontWeight: designTokens.typography.fontWeight.semibold,
          color: designTokens.colors.neutral[800],
          marginBottom: designTokens.spacing[3],
          fontFamily: designTokens.typography.fontFamily.sans.join(', '),
        }}
      >
        {title}
      </motion.h3>

      {/* 설명 */}
      {description && (
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4, duration: 0.3 }}
          style={{
            fontSize: designTokens.typography.fontSize.base,
            color: designTokens.colors.neutral[600],
            marginBottom: designTokens.spacing[8],
            maxWidth: '400px',
            lineHeight: designTokens.typography.lineHeight.relaxed,
            fontFamily: designTokens.typography.fontFamily.sans.join(', '),
          }}
        >
          {description}
        </motion.p>
      )}

      {/* 액션 버튼 */}
      {action && (
        <motion.button
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ delay: 0.5, duration: 0.3 }}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={action.onClick}
          style={{
            backgroundColor: designTokens.colors.primary[600],
            color: designTokens.colors.neutral[0],
            border: 'none',
            borderRadius: designTokens.borderRadius.lg,
            padding: `${designTokens.spacing[3]} ${designTokens.spacing[6]}`,
            fontSize: designTokens.typography.fontSize.base,
            fontWeight: designTokens.typography.fontWeight.medium,
            cursor: 'pointer',
            transition: `all ${designTokens.animation.duration.normal} ${designTokens.animation.easing.inOut}`,
            fontFamily: designTokens.typography.fontFamily.sans.join(', '),
            boxShadow: designTokens.boxShadow.sm,
          }}
        >
          {action.label}
        </motion.button>
      )}

      {/* 골프장 패턴 배경 */}
      <div
        style={{
          position: 'absolute',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          width: '200px',
          height: '200px',
          background: `radial-gradient(circle, ${designTokens.colors.primary[100]}20 0%, transparent 70%)`,
          borderRadius: '50%',
          zIndex: -1,
        }}
      />
    </motion.div>
  );
};

export default EmptyState;