'use client';

import React from 'react';
import { designTokens } from '@/styles/design-tokens';

interface StatusBarProps {
  time?: string;
  battery?: string;
  signal?: string;
}

export const StatusBar: React.FC<StatusBarProps> = ({ 
  time = '6:10', 
  battery = '🔋', 
  signal = '📶' 
}) => {
  return (
    <div
      className="flex justify-between items-center"
      style={{
        padding: `${designTokens.spacing.xl} ${designTokens.spacing['3xl']} ${designTokens.spacing.md}`,
        fontSize: designTokens.typography.fontSize.xl,
        color: designTokens.colors.text.primary,
        fontWeight: designTokens.typography.fontWeight.medium,
        letterSpacing: designTokens.typography.letterSpacing.normal,
      }}
    >
      <span>{time}</span>
      <span>{signal} {battery}</span>
    </div>
  );
};

export default StatusBar;


