import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface AvatarProps {
  name: string;
  avatar?: string;
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl' | '2xl';
  status?: 'online' | 'offline' | 'away' | 'busy';
  className?: string;
  style?: React.CSSProperties;
}

const Avatar: React.FC<AvatarProps> = ({
  name,
  avatar,
  size = 'md',
  status,
  className = '',
  style = {}
}) => {
  const [imageError, setImageError] = useState(false);

  const sizeStyles = {
    xs: { width: '24px', height: '24px', fontSize: '10px' },
    sm: { width: '32px', height: '32px', fontSize: '12px' },
    md: { width: '40px', height: '40px', fontSize: '14px' },
    lg: { width: '48px', height: '48px', fontSize: '16px' },
    xl: { width: '64px', height: '64px', fontSize: '20px' },
    '2xl': { width: '80px', height: '80px', fontSize: '24px' },
  };

  const statusStyles = {
    online: {
      backgroundColor: designTokens.colors.success[500],
      border: `2px solid ${designTokens.colors.neutral[0]}`,
      width: '12px',
      height: '12px',
    },
    offline: {
      backgroundColor: designTokens.colors.neutral[400],
      border: `2px solid ${designTokens.colors.neutral[0]}`,
      width: '12px',
      height: '12px',
    },
    away: {
      backgroundColor: designTokens.colors.warning[500],
      border: `2px solid ${designTokens.colors.neutral[0]}`,
      width: '12px',
      height: '12px',
    },
    busy: {
      backgroundColor: designTokens.colors.error[500],
      border: `2px solid ${designTokens.colors.neutral[0]}`,
      width: '12px',
      height: '12px',
    },
  };

  // 이름에서 이니셜 추출
  const getInitials = (name: string): string => {
    return name
      .split(' ')
      .map(word => word.charAt(0))
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  // 이름 기반 그라데이션 색상 생성
  const getGradientColors = (name: string): [string, string] => {
    const colors: [string, string][] = [
      [designTokens.colors.primary[500], designTokens.colors.primary[700]],
      [designTokens.colors.secondary[500], designTokens.colors.secondary[700]],
      [designTokens.colors.accent.gold, designTokens.colors.accent.bronze],
      [designTokens.colors.accent.navy, designTokens.colors.primary[600]],
    ];
    const index = name.charCodeAt(0) % colors.length;
    return colors[index];
  };

  const [startColor, endColor] = getGradientColors(name);
  const initials = getInitials(name);

  // 이미지 로딩 에러 처리
  const handleImageError = () => {
    setImageError(true);
  };

  const avatarStyles: React.CSSProperties = {
    ...sizeStyles[size],
    borderRadius: designTokens.borderRadius.full,
    background: (avatar && !imageError)
      ? `url(${avatar}) center/cover no-repeat`
      : `linear-gradient(135deg, ${startColor}, ${endColor})`,
    border: `2px solid ${designTokens.colors.neutral[0]}`,
    boxShadow: designTokens.boxShadow.md,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    color: designTokens.colors.neutral[0],
    fontWeight: designTokens.typography.fontWeight.semibold,
    fontFamily: designTokens.typography.fontFamily.sans.join(', '),
    position: 'relative',
    flexShrink: 0,
    ...style,
  };

  return (
    <motion.div
      initial={{ scale: 0 }}
      animate={{ scale: 1 }}
      transition={{ duration: 0.3, ease: 'backOut' }}
      style={avatarStyles}
      className={className}
      title={name}
    >
      {/* 이미지가 있고 에러가 없을 때만 이미지 표시 */}
      {avatar && !imageError && (
        <img
          src={avatar}
          alt={name}
          style={{
            width: '100%',
            height: '100%',
            borderRadius: designTokens.borderRadius.full,
            objectFit: 'cover',
          }}
          onError={handleImageError}
          onLoad={() => setImageError(false)}
        />
      )}
      
      {/* 이미지가 없거나 에러가 있을 때 이니셜 표시 */}
      {(!avatar || imageError) && initials}
      
      {/* 상태 표시기 */}
      {status && (
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{ delay: 0.2, duration: 0.2 }}
          style={{
            ...statusStyles[status],
            position: 'absolute',
            bottom: '-2px',
            right: '-2px',
            borderRadius: designTokens.borderRadius.full,
            boxShadow: designTokens.boxShadow.sm,
          }}
        />
      )}
    </motion.div>
  );
};

export default Avatar;