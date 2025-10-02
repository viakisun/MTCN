import React from 'react';
import { designTokens } from '@/styles/design-tokens';

export const StatusBar: React.FC = () => {
  const currentTime = new Date().toLocaleTimeString('ko-KR', { 
    hour: '2-digit', 
    minute: '2-digit',
    hour12: false 
  });

  return (
    <div
      style={{
        position: 'absolute',
        top: '0',
        left: '0',
        right: '0',
        height: '44px', // iPhone 16 Pro Status Bar 높이
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: `0 ${designTokens.spacing.lg}`,
        backgroundColor: 'transparent',
        zIndex: 20,
        pointerEvents: 'none',
      }}
    >
      {/* 왼쪽: 시간 */}
      <div
        style={{
          fontSize: designTokens.typography.fontSize.base,
          fontWeight: designTokens.typography.fontWeight.semibold,
          color: designTokens.colors.text.primary,
          fontFamily: designTokens.typography.fontFamily.sans.join(', '),
        }}
      >
        {currentTime}
      </div>

      {/* 오른쪽: 시스템 아이콘들 */}
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          gap: designTokens.spacing.xs,
        }}
      >
        {/* 신호 강도 */}
        <div style={{ display: 'flex', alignItems: 'center', gap: '2px' }}>
          {[1, 2, 3, 4].map((bar) => (
            <div
              key={bar}
              style={{
                width: '3px',
                height: `${bar * 3}px`,
                backgroundColor: designTokens.colors.text.primary,
                borderRadius: '1px',
                opacity: bar <= 3 ? 1 : 0.3,
              }}
            />
          ))}
        </div>

        {/* WiFi 아이콘 */}
        <div
          style={{
            width: '16px',
            height: '12px',
            position: 'relative',
          }}
        >
          <svg
            width="16"
            height="12"
            viewBox="0 0 16 12"
            fill="none"
            style={{ position: 'absolute', top: 0, left: 0 }}
          >
            <path
              d="M8 9L12 5M8 9L4 5M8 9V12M8 9V12"
              stroke={designTokens.colors.text.primary}
              strokeWidth="1.5"
              strokeLinecap="round"
            />
            <path
              d="M2 7L6 3M10 3L14 7"
              stroke={designTokens.colors.text.primary}
              strokeWidth="1"
              strokeLinecap="round"
              opacity="0.7"
            />
            <path
              d="M4 5L8 1M8 1L12 5"
              stroke={designTokens.colors.text.primary}
              strokeWidth="1"
              strokeLinecap="round"
              opacity="0.5"
            />
          </svg>
        </div>

        {/* 배터리 */}
        <div
          style={{
            width: '24px',
            height: '12px',
            border: `1px solid ${designTokens.colors.text.primary}`,
            borderRadius: '2px',
            position: 'relative',
            backgroundColor: 'transparent',
          }}
        >
          {/* 배터리 충전량 */}
          <div
            style={{
              position: 'absolute',
              top: '1px',
              left: '1px',
              width: '18px',
              height: '8px',
              backgroundColor: designTokens.colors.success[500],
              borderRadius: '1px',
            }}
          />
          {/* 배터리 극 */}
          <div
            style={{
              position: 'absolute',
              top: '3px',
              right: '-2px',
              width: '2px',
              height: '6px',
              backgroundColor: designTokens.colors.text.primary,
              borderRadius: '0 1px 1px 0',
            }}
          />
        </div>
      </div>
    </div>
  );
};

export default StatusBar;


