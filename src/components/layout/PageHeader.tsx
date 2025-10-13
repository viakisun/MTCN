import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

interface PageHeaderProps {
  icon: string;
  title: string;
  description: string;
  delay?: number;
}

/**
 * PageHeader - Reusable page header with icon, title, and description
 * Provides consistent header styling across all pages
 */
export const PageHeader: React.FC<PageHeaderProps> = ({
  icon,
  title,
  description,
  delay = 0.1
}) => {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay, duration: 0.5 }}
      style={{ marginBottom: designTokens.spacing.lg }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
        {getIconComponent(icon, { size: 24, color: designTokens.colors.primary[600] })}
        <h1 style={{
          fontSize: designTokens.typography.fontSize.xl,
          fontWeight: designTokens.typography.fontWeight.semibold,
          color: designTokens.colors.text.primary,
          margin: 0
        }}>
          {title}
        </h1>
      </div>
      <p style={{
        fontSize: designTokens.typography.fontSize.sm,
        color: designTokens.colors.text.secondary,
        margin: 0
      }}>
        {description}
      </p>
    </motion.div>
  );
};

export default PageHeader;
