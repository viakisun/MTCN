import React from 'react';
import { designTokens } from '@/styles/design-tokens';

interface PageContainerProps {
  children: React.ReactNode;
  className?: string;
}

/**
 * PageContainer - Reusable page wrapper with consistent styling
 * Provides scroll container, padding, and background color
 */
export const PageContainer: React.FC<PageContainerProps> = ({
  children,
  className = ''
}) => {
  return (
    <div
      className={`flex-1 overflow-y-auto scroll-container ${className}`}
      style={{
        padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
        backgroundColor: designTokens.colors.background.light
      }}
    >
      {children}
    </div>
  );
};

export default PageContainer;
