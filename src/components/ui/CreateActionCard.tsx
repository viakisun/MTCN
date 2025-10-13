import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

interface CreateActionCardProps {
  icon: string;
  title: string;
  description: string;
  onClick: () => void;
  delay?: number;
}

/**
 * CreateActionCard - Reusable "create new" action card
 * Used for creating new roundings, groups, scores, etc.
 */
export const CreateActionCard: React.FC<CreateActionCardProps> = ({
  icon,
  title,
  description,
  onClick,
  delay = 0.6
}) => {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay, duration: 0.5 }}
      style={{ marginTop: designTokens.spacing['3xl'] }}
    >
      <motion.div
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
          padding: designTokens.golf.card.padding.lg,
          position: 'relative',
          overflow: 'hidden',
          cursor: 'pointer',
          textAlign: 'center',
        }}
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
        whileTap={{
          scale: 0.98,
          transition: { duration: 0.1 }
        }}
        onClick={onClick}
      >
        {/* 배경 패턴 */}
        <div style={{
          position: 'absolute',
          top: designTokens.spacing.lg,
          right: designTokens.spacing.xl,
          opacity: 0.1,
          pointerEvents: 'none',
          transform: 'rotate(15deg)'
        }}>
          {getIconComponent(icon, { size: 60, color: designTokens.colors.primary[300] })}
        </div>

        <div style={{ position: 'relative', zIndex: 1 }}>
          {/* 아이콘 */}
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: delay + 0.2, duration: 0.3 }}
            style={{
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              width: '64px',
              height: '64px',
              borderRadius: designTokens.borderRadius.full,
              background: `
                linear-gradient(135deg,
                  ${designTokens.colors.primary[500]} 0%,
                  ${designTokens.colors.primary[600]} 50%,
                  ${designTokens.colors.primary[700]} 100%
                )
              `,
              margin: '0 auto',
              marginBottom: designTokens.spacing.lg,
              boxShadow: `
                0 8px 16px ${designTokens.colors.primary[500]}40,
                0 4px 8px rgba(0, 0, 0, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.2)
              `,
            }}
          >
            {getIconComponent(icon, { size: 32, color: designTokens.colors.neutral[0] })}
          </motion.div>

          {/* 제목 */}
          <h3 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0,
            marginBottom: designTokens.spacing.sm,
          }}>
            {title}
          </h3>

          {/* 설명 */}
          <p style={{
            fontSize: designTokens.typography.fontSize.sm,
            color: designTokens.colors.text.secondary,
            margin: 0,
            lineHeight: designTokens.typography.lineHeight.relaxed,
          }}>
            {description}
          </p>
        </div>
      </motion.div>
    </motion.div>
  );
};

export default CreateActionCard;
