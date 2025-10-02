import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'text';
  size?: 'sm' | 'md' | 'lg' | 'xl';
  disabled?: boolean;
  loading?: boolean;
  onClick?: (e?: React.MouseEvent) => void;
  className?: string;
  style?: React.CSSProperties;
}

const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'md',
  disabled = false,
  loading = false,
  onClick,
  className = '',
  style = {}
}) => {
  const baseStyles: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    fontWeight: designTokens.typography.fontWeight.medium,
    fontFamily: designTokens.typography.fontFamily.sans.join(', '),
    borderRadius: designTokens.borderRadius.lg,
    border: 'none',
    cursor: disabled ? 'not-allowed' : 'pointer',
    transition: `all ${designTokens.animation.duration.normal} ${designTokens.animation.easing.inOut}`,
    position: 'relative',
    overflow: 'hidden',
    textDecoration: 'none',
    outline: 'none',
    ...style
  };

  const sizeStyles = {
    sm: {
      padding: `${designTokens.spacing[2]} ${designTokens.spacing[3]}`,
      fontSize: designTokens.typography.fontSize.sm,
      minHeight: '32px',
    },
    md: {
      padding: `${designTokens.spacing[3]} ${designTokens.spacing[4]}`,
      fontSize: designTokens.typography.fontSize.base,
      minHeight: '40px',
    },
    lg: {
      padding: `${designTokens.spacing[4]} ${designTokens.spacing[6]}`,
      fontSize: designTokens.typography.fontSize.lg,
      minHeight: '48px',
    },
    xl: {
      padding: `${designTokens.spacing[5]} ${designTokens.spacing[8]}`,
      fontSize: designTokens.typography.fontSize.xl,
      minHeight: '56px',
    },
  };

  const variantStyles = {
    primary: {
      backgroundColor: designTokens.colors.primary[600],
      color: designTokens.colors.neutral[0],
      boxShadow: designTokens.boxShadow.sm,
      '&:hover': {
        backgroundColor: designTokens.colors.primary[700],
        boxShadow: designTokens.boxShadow.md,
        transform: 'translateY(-1px)',
      },
      '&:active': {
        backgroundColor: designTokens.colors.primary[800],
        transform: 'translateY(0)',
      },
    },
    secondary: {
      backgroundColor: designTokens.colors.secondary[600],
      color: designTokens.colors.neutral[0],
      boxShadow: designTokens.boxShadow.sm,
      '&:hover': {
        backgroundColor: designTokens.colors.secondary[700],
        boxShadow: designTokens.boxShadow.md,
        transform: 'translateY(-1px)',
      },
      '&:active': {
        backgroundColor: designTokens.colors.secondary[800],
        transform: 'translateY(0)',
      },
    },
    outline: {
      backgroundColor: 'transparent',
      color: designTokens.colors.primary[600],
      border: `1px solid ${designTokens.colors.primary[300]}`,
      '&:hover': {
        backgroundColor: designTokens.colors.primary[50],
        borderColor: designTokens.colors.primary[400],
        transform: 'translateY(-1px)',
      },
      '&:active': {
        backgroundColor: designTokens.colors.primary[100],
        transform: 'translateY(0)',
      },
    },
    ghost: {
      backgroundColor: 'transparent',
      color: designTokens.colors.primary[600],
      '&:hover': {
        backgroundColor: designTokens.colors.primary[50],
        transform: 'translateY(-1px)',
      },
      '&:active': {
        backgroundColor: designTokens.colors.primary[100],
        transform: 'translateY(0)',
      },
    },
    text: {
      backgroundColor: 'transparent',
      color: designTokens.colors.primary[600],
      padding: `${designTokens.spacing[1]} ${designTokens.spacing[2]}`,
      '&:hover': {
        color: designTokens.colors.primary[700],
        textDecoration: 'underline',
      },
    },
  };

  const disabledStyles = disabled ? {
    opacity: 0.5,
    cursor: 'not-allowed',
    transform: 'none !important',
    boxShadow: 'none !important',
  } : {};

  const loadingStyles = loading ? {
    cursor: 'wait',
  } : {};

  const combinedStyles = {
    ...baseStyles,
    ...sizeStyles[size],
    ...variantStyles[variant],
    ...disabledStyles,
    ...loadingStyles,
  };

  return (
    <motion.button
      whileHover={!disabled && !loading ? { scale: 1.02 } : {}}
      whileTap={!disabled && !loading ? { scale: 0.98 } : {}}
      style={combinedStyles}
      className={className}
      onClick={disabled || loading ? undefined : onClick}
      disabled={disabled || loading}
    >
      {loading && (
        <motion.div
          animate={{ rotate: 360 }}
          transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
          style={{
            width: '16px',
            height: '16px',
            border: `2px solid ${designTokens.colors.neutral[300]}`,
            borderTop: `2px solid ${designTokens.colors.primary[600]}`,
            borderRadius: '50%',
            marginRight: designTokens.spacing[2],
          }}
        />
      )}
      {children}
    </motion.button>
  );
};

export default Button;