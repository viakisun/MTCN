import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface CardProps {
  children: React.ReactNode;
  variant?: 'default' | 'elevated' | 'outlined' | 'filled';
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
  hover?: boolean;
  className?: string;
  onClick?: () => void;
  style?: React.CSSProperties;
}

const Card: React.FC<CardProps> = ({
  children,
  variant = 'default',
  padding = 'md',
  hover = false,
  className = '',
  onClick,
  style = {}
}) => {
  const baseStyles: React.CSSProperties = {
    borderRadius: designTokens.borderRadius.xl,
    fontFamily: designTokens.typography.fontFamily.sans.join(', '),
    transition: `all ${designTokens.animation.duration.normal} ${designTokens.animation.easing.inOut}`,
  };

  const variantStyles = {
    default: {
      backgroundColor: designTokens.colors.neutral[0],
      border: `1px solid ${designTokens.colors.neutral[200]}`,
      boxShadow: designTokens.boxShadow.sm,
    },
    elevated: {
      backgroundColor: designTokens.colors.neutral[0],
      border: 'none',
      boxShadow: designTokens.boxShadow.lg,
    },
    outlined: {
      backgroundColor: 'transparent',
      border: `2px solid ${designTokens.colors.neutral[300]}`,
      boxShadow: 'none',
    },
    filled: {
      backgroundColor: designTokens.colors.neutral[50],
      border: 'none',
      boxShadow: 'none',
    },
  };

  const paddingStyles = {
    none: { padding: 0 },
    sm: { padding: designTokens.spacing[3] },
    md: { padding: designTokens.spacing[4] },
    lg: { padding: designTokens.spacing[6] },
    xl: { padding: designTokens.spacing[8] },
  };

  const hoverStyles = hover ? {
    '&:hover': {
      transform: 'translateY(-2px)',
      boxShadow: designTokens.boxShadow.xl,
    },
  } : {};

  const combinedStyles = {
    ...baseStyles,
    ...variantStyles[variant],
    ...paddingStyles[padding],
    ...hoverStyles,
    ...style,
  };

  return (
    <motion.div
      whileHover={hover ? { 
        y: -2,
        boxShadow: designTokens.boxShadow.xl,
        transition: { duration: 0.2 }
      } : {}}
      style={combinedStyles}
      className={className}
      onClick={onClick}
    >
      {children}
    </motion.div>
  );
};

export default Card;