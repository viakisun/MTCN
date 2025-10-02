import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import Avatar from '@/components/ui/Avatar';

export interface RoundingCardData {
  id: string;
  courseName: string;
  eventName: string; // 이벤트/대회명 추가
  date: string;
  time: string;
  status: 'scheduled' | 'inProgress' | 'completed' | 'upcoming' | 'in-progress';
  players: Array<{
    id: string;
    name: string;
    avatar?: string;
  }>;
  weather: 'sunny' | 'cloudy' | 'rainy' | 'windy';
  temperature: number;
  greenFee: number;
  holes: number; // 홀 수 추가
  dDay?: number;
  notice?: string;
}

interface RoundingCardProps {
  data: RoundingCardData;
  onClick?: () => void;
  className?: string;
}

export const RoundingCard: React.FC<RoundingCardProps> = ({ 
  data, 
  onClick,
  className = '' 
}) => {
  // 상태 매핑: 데이터 상태 → 디자인 토큰 상태
  const statusMapping: { [key: string]: keyof typeof designTokens.golf.status } = {
    'upcoming': 'scheduled',
    'in-progress': 'inProgress',
    'completed': 'completed',
    'scheduled': 'scheduled',
    'inProgress': 'inProgress'
  };
  
  const mappedStatus = statusMapping[data.status] || 'scheduled';
  const statusConfig = designTokens.golf.status[mappedStatus];
  
  const getWeatherIcon = (weather: string) => {
    return getIconComponent(weather, { 
      size: 20, 
      color: weather === 'sunny' ? designTokens.colors.warning[500] : designTokens.colors.text.secondary 
    });
  };

  const getStatusBadge = () => {
    const statusLabels = {
      scheduled: '예정',
      inProgress: '진행중',
      completed: '완료',
      upcoming: '예정',
      'in-progress': '진행중'
    };

    return (
      <motion.div
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{ delay: 0.2, duration: 0.3 }}
        style={{
          background: `
            linear-gradient(135deg, 
              ${statusConfig.primary} 0%, 
              ${statusConfig.accent} 50%,
              ${statusConfig.accent} 100%
            )
          `,
          borderRadius: '12px', // 16px → 12px (더 작고 자연스럽게)
          padding: `${designTokens.spacing.xs} ${designTokens.spacing.sm}`, // 더 작은 패딩
          boxShadow: `
            0 2px 8px ${statusConfig.primary}20,
            0 1px 2px rgba(0, 0, 0, 0.1)
          `,
          border: `1px solid rgba(255, 255, 255, 0.2)`,
          position: 'relative',
          overflow: 'hidden'
        }}
      >
        <span style={{
          fontSize: designTokens.typography.fontSize.xs, // sm → xs (더 작게)
          fontWeight: designTokens.typography.fontWeight.medium, // semibold → medium (더 자연스럽게)
          color: designTokens.colors.neutral[0],
          textShadow: '0 1px 2px rgba(0, 0, 0, 0.2)', // 그림자 줄임
          position: 'relative',
          zIndex: 1
        }}>
          {statusLabels[data.status]}
        </span>
      </motion.div>
    );
  };

  const getDDayBadge = () => {
    if (!data.dDay || data.dDay < 0) return null;
    
    return (
      <motion.div
        initial={{ scale: 0, rotate: -180 }}
        animate={{ scale: 1, rotate: 0 }}
        transition={{ delay: 0.3, duration: 0.4, ease: "backOut" }}
        style={{
          background: `
            linear-gradient(135deg, 
              ${designTokens.colors.primary[600]} 0%, 
              ${designTokens.colors.primary[700]} 50%,
              ${designTokens.colors.primary[800]} 100%
            )
          `,
          borderRadius: '16px',
          padding: `${designTokens.spacing.sm} ${designTokens.spacing.md}`,
          boxShadow: `
            0 8px 16px ${designTokens.colors.primary[600]}40,
            0 4px 8px rgba(0, 0, 0, 0.1),
            inset 0 1px 0 rgba(255, 255, 255, 0.2)
          `,
          border: `1px solid rgba(255, 255, 255, 0.2)`,
          position: 'relative',
          overflow: 'hidden'
        }}
      >
        <span style={{
          fontSize: designTokens.typography.fontSize.sm,
          fontWeight: designTokens.typography.fontWeight.semibold, // 볼드 제거
          color: designTokens.colors.neutral[0],
          textShadow: '0 1px 2px rgba(0, 0, 0, 0.3)',
          position: 'relative',
          zIndex: 1
        }}>
          D-{data.dDay}
        </span>
      </motion.div>
    );
  };

  const getParticipants = () => {
    const maxVisible = 3;
    const visiblePlayers = data.players.slice(0, maxVisible);
    const remainingCount = data.players.length - maxVisible;

    return (
      <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
        <div style={{ display: 'flex', position: 'relative' }}>
          {visiblePlayers.map((player, index) => (
            <motion.div
              key={player.id}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4 + index * 0.1, duration: 0.3 }}
              style={{
                marginLeft: index > 0 ? `-${designTokens.spacing[3]}` : '0',
                zIndex: visiblePlayers.length - index,
                border: `2px solid ${designTokens.colors.neutral[0]}`,
                borderRadius: designTokens.borderRadius.full,
                boxShadow: designTokens.boxShadow.sm,
              }}
            >
              <Avatar name={player.name} avatar={player.avatar} size="sm" />
            </motion.div>
          ))}
          {remainingCount > 0 && (
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4 + maxVisible * 0.1, duration: 0.3 }}
              style={{
                marginLeft: `-${designTokens.spacing[3]}`,
                zIndex: 0,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                width: '32px',
                height: '32px',
                borderRadius: designTokens.borderRadius.full,
                background: `linear-gradient(135deg, ${designTokens.colors.primary[100]} 0%, ${designTokens.colors.primary[200]} 100%)`,
                fontSize: designTokens.typography.fontSize.xs,
                fontWeight: designTokens.typography.fontWeight.semibold,
                color: designTokens.colors.primary[700],
                border: `2px solid ${designTokens.colors.neutral[0]}`,
                boxShadow: designTokens.boxShadow.sm,
              }}
            >
              +{remainingCount}
            </motion.div>
          )}
        </div>
        <span style={{
          fontSize: designTokens.typography.fontSize.sm,
          fontWeight: designTokens.typography.fontWeight.medium,
          color: designTokens.colors.text.secondary,
        }}>
          참가
        </span>
      </div>
    );
  };

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      whileHover={{ 
        y: -6,
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
      {/* 배경 패턴 (은은한 골프 아이덴티티) */}
      <div style={{
        position: 'absolute',
        top: designTokens.spacing.lg,
        right: designTokens.spacing.xl,
        opacity: 0.05,
        pointerEvents: 'none',
        transform: 'rotate(15deg)',
        zIndex: 0
      }}>
        {getIconComponent('golf-ball', { size: 60, color: designTokens.colors.primary[300] })}
      </div>

      <div style={{ position: 'relative', zIndex: 1 }}>
        {/* 상단: 이벤트명 + 상태 배지 (자연스러운 통합) */}
        <div style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'flex-start',
          marginBottom: designTokens.spacing.md
        }}>
          <div style={{ flex: 1, marginRight: designTokens.spacing.md }}>
            {/* 이벤트명 - 가장 중요한 정보 */}
            <h3 style={{
              fontSize: designTokens.typography.fontSize.sm,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0,
              marginBottom: designTokens.spacing.xs,
              lineHeight: designTokens.typography.lineHeight.tight,
            }}>
              {data.eventName}
            </h3>
            
            {/* 골프장명 - 보조 정보 */}
            <div style={{
              fontSize: '11px',
              fontWeight: designTokens.typography.fontWeight.medium,
              color: designTokens.colors.text.secondary,
              marginBottom: designTokens.spacing.sm,
            }}>
              {data.courseName}
            </div>
            
            {/* 날짜/시간 */}
            <div style={{
              fontSize: '11px',
              fontWeight: designTokens.typography.fontWeight.medium,
              color: designTokens.colors.text.secondary,
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.sm,
            }}>
              {getIconComponent('calendar', { size: 12, color: designTokens.colors.text.secondary })}
              <span>{data.date} • {data.time}</span>
            </div>
          </div>
          
          {/* 상태 배지 - 오른쪽 상단에 자연스럽게 */}
          <div style={{ 
            display: 'flex', 
            flexDirection: 'column', 
            gap: designTokens.spacing.xs, 
            alignItems: 'flex-end',
            flexShrink: 0
          }}>
            {getStatusBadge()}
            {getDDayBadge()}
          </div>
        </div>

        {/* 핵심 정보 섹션 - 일관된 디자인 */}
        <div style={{ 
          display: 'flex', 
          justifyContent: 'space-between',
          alignItems: 'center',
          marginBottom: designTokens.spacing.lg,
          padding: `${designTokens.spacing.md} ${designTokens.spacing.lg}`,
          backgroundColor: 'rgba(0, 0, 0, 0.02)',
          borderRadius: designTokens.borderRadius.md,
          border: '1px solid rgba(0, 0, 0, 0.05)'
        }}>
          {/* 홀 수 */}
          <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
            {getIconComponent('tee', { size: 18, color: designTokens.colors.primary[600] })}
            <div>
              <div style={{
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.semibold,
                color: designTokens.colors.text.primary,
                lineHeight: 1
              }}>
                {data.holes}홀
              </div>
            </div>
          </div>

          {/* 날씨/온도 */}
          <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
            {getWeatherIcon(data.weather)}
            <div>
              <div style={{
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.semibold,
                color: designTokens.colors.text.primary,
                lineHeight: 1
              }}>
                {data.temperature}°C
              </div>
            </div>
          </div>

          {/* 참가자 수 */}
          <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
            {getIconComponent('users', { size: 18, color: designTokens.colors.primary[600] })}
            <div>
              <div style={{
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.semibold,
                color: designTokens.colors.text.primary,
                lineHeight: 1
              }}>
                {data.players.length}명
              </div>
            </div>
          </div>
        </div>

        {/* 참가자 아바타 */}
        <div style={{ 
          marginBottom: designTokens.spacing.lg
        }}>
          {getParticipants()}
        </div>

        {/* 풀-위드스 CTA 버튼 */}
        <div style={{ marginBottom: designTokens.spacing.md }}>
          <motion.div
            whileHover={{ 
              scale: 1.02,
              boxShadow: `0 8px 20px ${statusConfig.primary}40`,
              transition: { duration: 0.2 }
            }}
            whileTap={{ 
              scale: 0.98,
              transition: { duration: 0.1 }
            }}
            style={{
              width: '100%', // 풀-위드스
              background: `
                linear-gradient(135deg, 
                  ${statusConfig.primary} 0%, 
                  ${statusConfig.accent} 50%,
                  ${statusConfig.accent} 100%
                )
              `,
              borderRadius: '16px',
              padding: `${designTokens.spacing.xs} ${designTokens.spacing.lg}`, // sm → xs (더 컴팩트하게)
              boxShadow: `
                0 6px 16px ${statusConfig.primary}30,
                0 2px 4px rgba(0, 0, 0, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.2)
              `,
              border: `1px solid rgba(255, 255, 255, 0.2)`,
              cursor: 'pointer',
              position: 'relative',
              overflow: 'hidden',
              textAlign: 'center'
            }}
          >
            <span style={{
              fontSize: designTokens.typography.fontSize.sm, // base → sm (버튼 텍스트도 약간 작게)
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.neutral[0],
              textShadow: '0 1px 2px rgba(0, 0, 0, 0.3)',
              position: 'relative',
              zIndex: 1
            }}>
              {(() => {
                const actualStatus = statusMapping[data.status] || 'scheduled';
                switch (actualStatus) {
                  case 'scheduled':
                    return '상세보기';
                  case 'inProgress':
                    return '경기장 입장';
                  case 'completed':
                    return '결과보기';
                  default:
                    return '상세보기';
                }
              })()}
            </span>
          </motion.div>
        </div>

        {/* 주의사항 - 버튼 아래 작은 스타일 */}
        {data.notice && (
          <div style={{
            textAlign: 'center',
            fontSize: designTokens.typography.fontSize.xs,
            color: designTokens.colors.text.secondary,
            fontWeight: designTokens.typography.fontWeight.normal,
            lineHeight: designTokens.typography.lineHeight.relaxed,
            opacity: 0.8
          }}>
            {data.notice}
          </div>
        )}
      </div>
    </motion.div>
  );
};