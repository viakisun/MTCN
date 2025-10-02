import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface BadgeProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'error' | 'info' | 'neutral' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  className?: string;
  style?: React.CSSProperties;
}

const Badge: React.FC<BadgeProps> = ({
  children,
  variant = 'neutral',
  size = 'md',
  className = '',
  style = {}
}) => {
  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontWeight: designTokens.typography.fontWeight.medium,
    fontFamily: designTokens.typography.fontFamily.sans.join(', '),
    borderRadius: designTokens.borderRadius.full,
    border: 'none',
    whiteSpace: 'nowrap',
  };

  const sizeStyles = {
    sm: {
      padding: `${designTokens.spacing[1]} ${designTokens.spacing[2]}`,
      fontSize: designTokens.typography.fontSize.xs,
      minHeight: '20px',
    },
    md: {
      padding: `${designTokens.spacing[1]} ${designTokens.spacing[3]}`,
      fontSize: designTokens.typography.fontSize.sm,
      minHeight: '24px',
    },
    lg: {
      padding: `${designTokens.spacing[2]} ${designTokens.spacing[4]}`,
      fontSize: designTokens.typography.fontSize.base,
      minHeight: '28px',
    },
  };

  const variantStyles = {
    primary: {
      backgroundColor: designTokens.colors.primary[100],
      color: designTokens.colors.primary[800],
      border: `1px solid ${designTokens.colors.primary[200]}`,
    },
    secondary: {
      backgroundColor: designTokens.colors.secondary[100],
      color: designTokens.colors.secondary[800],
      border: `1px solid ${designTokens.colors.secondary[200]}`,
    },
    success: {
      backgroundColor: designTokens.colors.success[50],
      color: designTokens.colors.success[700],
      border: `1px solid ${designTokens.colors.success[200]}`,
    },
    warning: {
      backgroundColor: designTokens.colors.warning[50],
      color: designTokens.colors.warning[700],
      border: `1px solid ${designTokens.colors.warning[200]}`,
    },
    error: {
      backgroundColor: designTokens.colors.error[50],
      color: designTokens.colors.error[700],
      border: `1px solid ${designTokens.colors.error[200]}`,
    },
    info: {
      backgroundColor: designTokens.colors.info[50],
      color: designTokens.colors.info[700],
      border: `1px solid ${designTokens.colors.info[200]}`,
    },
    neutral: {
      backgroundColor: designTokens.colors.neutral[100],
      color: designTokens.colors.neutral[700],
      border: `1px solid ${designTokens.colors.neutral[200]}`,
    },
    danger: {
      backgroundColor: designTokens.colors.error[50],
      color: designTokens.colors.error[700],
      border: `1px solid ${designTokens.colors.error[200]}`,
    },
  };

  const combinedStyles = {
    ...baseStyles,
    ...sizeStyles[size],
    ...variantStyles[variant],
    ...style,
  };

  return (
    <motion.span
      initial={{ scale: 0.8, opacity: 0 }}
      animate={{ scale: 1, opacity: 1 }}
      transition={{ duration: 0.2 }}
      style={combinedStyles}
      className={className}
    >
      {children}
    </motion.span>
  );
};

export default Badge;