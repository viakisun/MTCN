import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

export interface ProfileMenuItemData {
  id: string;
  label: string;
  icon: string;
  description?: string;
  badge?: string;
  color?: string;
  onClick?: () => void;
}

interface ProfileMenuItemProps {
  data: ProfileMenuItemData;
  onClick?: () => void;
  className?: string;
}

export const ProfileMenuItem: React.FC<ProfileMenuItemProps> = ({ 
  data, 
  onClick,
  className = '' 
}) => {
  const handleClick = () => {
    if (data.onClick) {
      data.onClick();
    } else if (onClick) {
      onClick();
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      whileHover={{ 
        y: -2,
        scale: 1.01,
        boxShadow: `
          0 8px 24px rgba(0, 0, 0, 0.12),
          0 4px 8px rgba(0, 0, 0, 0.08),
          inset 0 1px 0 rgba(255, 255, 255, 0.1)
        `,
        transition: { duration: 0.2, ease: "easeOut" }
      }}
      whileTap={{ 
        scale: 0.98,
        transition: { duration: 0.1 }
      }}
      onClick={handleClick}
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
          0 4px 12px rgba(0, 0, 0, 0.08),
          0 2px 4px rgba(0, 0, 0, 0.06),
          inset 0 1px 0 rgba(255, 255, 255, 0.1)
        `,
        padding: designTokens.golf.card.padding.md,
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      <div style={{ position: 'relative', zIndex: 1 }}>
        {/* 메뉴 아이템 내용 */}
        <div style={{ 
          display: 'flex', 
          alignItems: 'center',
          gap: designTokens.spacing.md
        }}>
          {/* 아이콘 */}
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            width: '40px',
            height: '40px',
            borderRadius: designTokens.borderRadius.md,
            backgroundColor: data.color ? `${data.color}20` : `${designTokens.colors.primary[500]}20`,
            border: `1px solid ${data.color ? `${data.color}30` : `${designTokens.colors.primary[500]}30`}`,
            flexShrink: 0,
          }}>
            {getIconComponent(data.icon, { 
              size: 20, 
              color: data.color || designTokens.colors.primary[500]
            })}
          </div>

          {/* 텍스트 영역 */}
          <div style={{ flex: 1 }}>
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.sm,
              marginBottom: data.description ? designTokens.spacing.xs : 0,
            }}>
              <h3 style={{
                fontSize: designTokens.typography.fontSize.base,
                fontWeight: designTokens.typography.fontWeight.semibold,
                color: designTokens.colors.text.primary,
                margin: 0,
              }}>
                {data.label}
              </h3>
              
              {/* 배지 */}
              {data.badge && (
                <motion.div
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.1 }}
                  style={{
                    backgroundColor: designTokens.colors.primary[500],
                    color: designTokens.colors.neutral[0],
                    fontSize: designTokens.typography.fontSize.xs,
                    fontWeight: designTokens.typography.fontWeight.semibold,
                    padding: `2px ${designTokens.spacing.xs}`,
                    borderRadius: designTokens.borderRadius.full,
                    minWidth: '20px',
                    textAlign: 'center',
                  }}
                >
                  {data.badge}
                </motion.div>
              )}
            </div>
            
            {/* 설명 */}
            {data.description && (
              <p style={{
                fontSize: designTokens.typography.fontSize.sm,
                color: designTokens.colors.text.secondary,
                margin: 0,
                lineHeight: designTokens.typography.lineHeight.relaxed,
              }}>
                {data.description}
              </p>
            )}
          </div>

          {/* 화살표 아이콘 */}
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            width: '20px',
            height: '20px',
            color: designTokens.colors.text.secondary,
            flexShrink: 0,
          }}>
            {getIconComponent('golf-ball', { 
              size: 16, 
              color: designTokens.colors.text.secondary 
            })}
          </div>
        </div>
      </div>
    </motion.div>
  );
};
