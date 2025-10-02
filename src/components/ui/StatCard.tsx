import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface StatCardProps {
  title: string;
  value: string | number;
  unit?: string;
  trend?: 'up' | 'down' | 'neutral';
  trendValue?: string;
  icon?: React.ReactNode;
  color?: 'primary' | 'secondary' | 'success' | 'warning' | 'error' | 'info';
  className?: string;
}

const StatCard: React.FC<StatCardProps> = ({
  title,
  value,
  unit,
  trend,
  trendValue,
  icon,
  color = 'primary',
  className = ''
}) => {
  const colorStyles = {
    primary: {
      background: designTokens.colors.primary[50],
      border: `1px solid ${designTokens.colors.primary[200]}`,
      iconColor: designTokens.colors.primary[600],
      valueColor: designTokens.colors.primary[700],
    },
    secondary: {
      background: designTokens.colors.secondary[50],
      border: `1px solid ${designTokens.colors.secondary[200]}`,
      iconColor: designTokens.colors.secondary[600],
      valueColor: designTokens.colors.secondary[700],
    },
    success: {
      background: designTokens.colors.success[50],
      border: `1px solid ${designTokens.colors.success[200]}`,
      iconColor: designTokens.colors.success[600],
      valueColor: designTokens.colors.success[700],
    },
    warning: {
      background: designTokens.colors.warning[50],
      border: `1px solid ${designTokens.colors.warning[200]}`,
      iconColor: designTokens.colors.warning[600],
      valueColor: designTokens.colors.warning[700],
    },
    error: {
      background: designTokens.colors.error[50],
      border: `1px solid ${designTokens.colors.error[200]}`,
      iconColor: designTokens.colors.error[600],
      valueColor: designTokens.colors.error[700],
    },
    info: {
      background: designTokens.colors.info[50],
      border: `1px solid ${designTokens.colors.info[200]}`,
      iconColor: designTokens.colors.info[600],
      valueColor: designTokens.colors.info[700],
    },
  };

  const trendStyles = {
    up: {
      color: designTokens.colors.success[600],
      icon: '↗',
    },
    down: {
      color: designTokens.colors.error[600],
      icon: '↘',
    },
    neutral: {
      color: designTokens.colors.neutral[500],
      icon: '→',
    },
  };

  const currentColorStyle = colorStyles[color];
  const currentTrendStyle = trend ? trendStyles[trend] : null;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
      style={{
        background: currentColorStyle.background,
        border: currentColorStyle.border,
        borderRadius: designTokens.borderRadius.xl,
        padding: designTokens.spacing[6],
        textAlign: 'center',
        position: 'relative',
        overflow: 'hidden',
      }}
      className={className}
    >
      {/* 배경 패턴 */}
      <div
        style={{
          position: 'absolute',
          top: '-20px',
          right: '-20px',
          width: '60px',
          height: '60px',
          background: `radial-gradient(circle, ${currentColorStyle.iconColor}20 0%, transparent 70%)`,
          borderRadius: '50%',
        }}
      />

      {/* 아이콘 */}
      {icon && (
        <div
          style={{
            color: currentColorStyle.iconColor,
            fontSize: '24px',
            marginBottom: designTokens.spacing[3],
            display: 'flex',
            justifyContent: 'center',
          }}
        >
          {icon}
        </div>
      )}

      {/* 제목 */}
      <div
        style={{
          fontSize: designTokens.typography.fontSize.sm,
          fontWeight: designTokens.typography.fontWeight.medium,
          color: designTokens.colors.neutral[600],
          marginBottom: designTokens.spacing[2],
          fontFamily: designTokens.typography.fontFamily.sans.join(', '),
        }}
      >
        {title}
      </div>

      {/* 값 */}
      <div
        style={{
          fontSize: designTokens.typography.fontSize['3xl'],
          fontWeight: designTokens.typography.fontWeight.bold,
          color: currentColorStyle.valueColor,
          marginBottom: designTokens.spacing[1],
          fontFamily: designTokens.typography.fontFamily.sans.join(', '),
          lineHeight: designTokens.typography.lineHeight.tight,
        }}
      >
        {value}
        {unit && (
          <span
            style={{
              fontSize: designTokens.typography.fontSize.lg,
              fontWeight: designTokens.typography.fontWeight.medium,
              marginLeft: designTokens.spacing[1],
            }}
          >
            {unit}
          </span>
        )}
      </div>

      {/* 트렌드 */}
      {trend && trendValue && (
        <div
          style={{
            fontSize: designTokens.typography.fontSize.sm,
            fontWeight: designTokens.typography.fontWeight.medium,
            color: currentTrendStyle!.color,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: designTokens.spacing[1],
          }}
        >
          <span>{currentTrendStyle!.icon}</span>
          <span>{trendValue}</span>
        </div>
      )}
    </motion.div>
  );
};

export default StatCard;