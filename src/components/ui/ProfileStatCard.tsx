import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

export interface ProfileStatCardData {
  id: string;
  title: string;
  value: string | number;
  unit?: string;
  icon: string;
  color: string;
  description?: string;
  trend?: 'up' | 'down' | 'stable';
  trendValue?: string;
}

interface ProfileStatCardProps {
  data: ProfileStatCardData;
  onClick?: () => void;
  className?: string;
}

export const ProfileStatCard: React.FC<ProfileStatCardProps> = ({ 
  data, 
  onClick,
  className = '' 
}) => {
  const getTrendIcon = () => {
    if (!data.trend) return null;
    
    switch (data.trend) {
      case 'up':
        return getIconComponent('golf-ball', { 
          size: 12, 
          color: designTokens.colors.success[600] 
        });
      case 'down':
        return getIconComponent('golf-ball', { 
          size: 12, 
          color: designTokens.colors.error[600] 
        });
      case 'stable':
        return getIconComponent('golf-ball', { 
          size: 12, 
          color: designTokens.colors.neutral[500] 
        });
      default:
        return null;
    }
  };

  const getTrendColor = () => {
    if (!data.trend) return designTokens.colors.text.secondary;
    
    switch (data.trend) {
      case 'up':
        return designTokens.colors.success[600];
      case 'down':
        return designTokens.colors.error[600];
      case 'stable':
        return designTokens.colors.neutral[500];
      default:
        return designTokens.colors.text.secondary;
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      whileHover={{ 
        y: -4,
        scale: 1.02,
        boxShadow: `
          0 12px 32px rgba(0, 0, 0, 0.16),
          0 6px 12px rgba(0, 0, 0, 0.12),
          inset 0 1px 0 rgba(255, 255, 255, 0.15)
        `,
        transition: { duration: 0.3, ease: "easeOut" }
      }}
      onClick={onClick}
      className={`cursor-pointer ${className}`}
      style={{
        background: `
          linear-gradient(135deg, 
            rgba(255, 255, 255, 0.98) 0%, 
            rgba(250, 250, 250, 0.95) 100%
          )
        `,
        backdropFilter: 'blur(20px)',
        borderRadius: designTokens.golf.card.borderRadius,
        border: `1px solid rgba(0, 0, 0, 0.08)`,
        boxShadow: `
          0 8px 24px rgba(0, 0, 0, 0.12),
          0 4px 8px rgba(0, 0, 0, 0.08),
          inset 0 1px 0 rgba(255, 255, 255, 0.1)
        `,
        padding: designTokens.golf.card.padding.md,
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* 배경 패턴 (은은한 통계 아이덴티티) */}
      <div style={{
        position: 'absolute',
        top: designTokens.spacing.lg,
        right: designTokens.spacing.xl,
        opacity: 0.1,
        pointerEvents: 'none',
        transform: 'rotate(15deg)'
      }}>
        {getIconComponent(data.icon, { size: 60, color: data.color })}
      </div>

      <div style={{ position: 'relative', zIndex: 1 }}>
        {/* 상단: 아이콘 + 제목 */}
        <div style={{ 
          display: 'flex', 
          alignItems: 'center',
          gap: designTokens.spacing.sm,
          marginBottom: designTokens.spacing.md
        }}>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            width: '32px',
            height: '32px',
            borderRadius: designTokens.borderRadius.md,
            backgroundColor: `${data.color}20`,
            border: `1px solid ${data.color}30`,
          }}>
            {getIconComponent(data.icon, { 
              size: 16, 
              color: data.color 
            })}
          </div>
          
          <h3 style={{
            fontSize: designTokens.typography.fontSize.sm,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0,
            flex: 1,
          }}>
            {data.title}
          </h3>
        </div>

        {/* 값 표시 */}
        <div style={{ 
          marginBottom: designTokens.spacing.sm,
          textAlign: 'center'
        }}>
          <div style={{
            fontSize: designTokens.typography.fontSize['2xl'],
            fontWeight: designTokens.typography.fontWeight.bold,
            color: data.color,
            marginBottom: designTokens.spacing.xs,
            lineHeight: 1,
          }}>
            {data.value}
            {data.unit && (
              <span style={{
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.text.secondary,
                marginLeft: designTokens.spacing.xs,
              }}>
                {data.unit}
              </span>
            )}
          </div>
          
          {/* 트렌드 표시 */}
          {data.trend && data.trendValue && (
            <div style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: designTokens.spacing.xs,
              fontSize: designTokens.typography.fontSize.xs,
              fontWeight: designTokens.typography.fontWeight.medium,
              color: getTrendColor(),
            }}>
              {getTrendIcon()}
              <span>{data.trendValue}</span>
            </div>
          )}
        </div>

        {/* 설명 */}
        {data.description && (
          <div style={{
            textAlign: 'center',
            fontSize: designTokens.typography.fontSize.xs,
            color: designTokens.colors.text.secondary,
            fontWeight: designTokens.typography.fontWeight.normal,
            lineHeight: designTokens.typography.lineHeight.relaxed,
            opacity: 0.8
          }}>
            {data.description}
          </div>
        )}
      </div>
    </motion.div>
  );
};
