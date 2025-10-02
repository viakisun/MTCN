import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

export interface ScoreCardData {
  id: string;
  courseName: string;
  date: string;
  totalScore: number;
  par: number;
  birdies: number;
  eagles?: number;
  pars?: number;
  bogeys: number;
  doubleBogeys?: number;
  holes: number[];
  weather: 'sunny' | 'cloudy' | 'rainy' | 'windy';
  temperature: number;
  status: 'excellent' | 'good' | 'average' | 'poor';
  description?: string;
}

interface ScoreCardProps {
  data: ScoreCardData;
  onClick?: () => void;
  className?: string;
}

export const ScoreCard: React.FC<ScoreCardProps> = ({ 
  data, 
  onClick,
  className = '' 
}) => {
  const getStatusConfig = () => {
    switch (data.status) {
      case 'excellent':
        return {
          label: '우수',
          color: designTokens.colors.success[500],
          background: designTokens.colors.success[50],
          border: designTokens.colors.success[200]
        };
      case 'good':
        return {
          label: '양호',
          color: designTokens.colors.primary[500],
          background: designTokens.colors.primary[50],
          border: designTokens.colors.primary[200]
        };
      case 'average':
        return {
          label: '보통',
          color: designTokens.colors.warning[500],
          background: designTokens.colors.warning[50],
          border: designTokens.colors.warning[200]
        };
      case 'poor':
        return {
          label: '개선',
          color: designTokens.colors.error[500],
          background: designTokens.colors.error[50],
          border: designTokens.colors.error[200]
        };
      default:
        return {
          label: '양호',
          color: designTokens.colors.primary[500],
          background: designTokens.colors.primary[50],
          border: designTokens.colors.primary[200]
        };
    }
  };

  const statusConfig = getStatusConfig();
  const scoreDifference = data.totalScore - data.par;
  const scoreLabel = scoreDifference === 0 ? 'E' : scoreDifference > 0 ? `+${scoreDifference}` : `${scoreDifference}`;

  const getInfoItems = () => [
    { 
      icon: getIconComponent('tee', { size: 16, color: designTokens.colors.text.secondary }), 
      label: `${data.holes.length}홀`,
      color: designTokens.colors.text.secondary
    },
    { 
      icon: getIconComponent(data.weather, { 
        size: 16, 
        color: data.weather === 'sunny' ? designTokens.colors.warning[500] : designTokens.colors.text.secondary 
      }), 
      label: `${data.temperature}°C`,
      color: data.weather === 'sunny' ? designTokens.colors.warning[500] : designTokens.colors.text.secondary
    },
    { 
      icon: getIconComponent('golf-ball', { size: 16, color: designTokens.colors.text.secondary }), 
      label: `파 ${data.par}`,
      color: designTokens.colors.text.secondary
    },
  ];

  const getScoreStats = () => [
    { label: '버디', value: data.birdies, color: designTokens.colors.success[600] },
    { label: '이글', value: data.eagles || 0, color: designTokens.colors.primary[600] },
    { label: '파', value: data.pars || 0, color: designTokens.colors.text.primary },
    { label: '보기', value: data.bogeys, color: designTokens.colors.warning[600] },
    { label: '더블보기', value: data.doubleBogeys || 0, color: designTokens.colors.error[600] },
  ];

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
      {/* 배경 패턴 (은은한 스코어 아이덴티티) */}
      <div style={{
        position: 'absolute',
        top: designTokens.spacing.lg,
        right: designTokens.spacing.xl,
        opacity: 0.1,
        pointerEvents: 'none',
        transform: 'rotate(15deg)'
      }}>
        {getIconComponent('chart', { size: 60, color: designTokens.colors.primary[300] })}
      </div>

      <div style={{ position: 'relative', zIndex: 1 }}>
        {/* 상단: 골프장명 + 상태 배지 */}
        <div style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'flex-start',
          marginBottom: designTokens.spacing.md
        }}>
          <div style={{ flex: 1, marginRight: designTokens.spacing.md }}>
            {/* 골프장명 - 가장 중요한 정보 */}
            <h3 style={{
              fontSize: designTokens.typography.fontSize.sm,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0,
              marginBottom: designTokens.spacing.xs,
              lineHeight: designTokens.typography.lineHeight.tight,
            }}>
              {data.courseName}
            </h3>
            
            {/* 날짜 - 보조 정보 */}
            <div style={{
              fontSize: '11px',
              fontWeight: designTokens.typography.fontWeight.medium,
              color: designTokens.colors.text.secondary,
              marginBottom: designTokens.spacing.sm,
            }}>
              {data.date}
            </div>
            
            {/* 총 스코어 */}
            <div style={{
              fontSize: '11px',
              fontWeight: designTokens.typography.fontWeight.medium,
              color: designTokens.colors.text.secondary,
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.sm,
            }}>
              {getIconComponent('chart', { size: 12, color: designTokens.colors.text.secondary })}
              <span>총 {data.totalScore}타 ({scoreLabel})</span>
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
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.2, duration: 0.3 }}
              style={{
                background: `
                  linear-gradient(135deg, 
                    ${statusConfig.color} 0%, 
                    ${statusConfig.color}80 50%,
                    ${statusConfig.color}60 100%
                  )
                `,
                borderRadius: '12px',
                padding: `${designTokens.spacing.xs} ${designTokens.spacing.sm}`,
                boxShadow: `
                  0 2px 8px ${statusConfig.color}20,
                  0 1px 2px rgba(0, 0, 0, 0.1)
                `,
                border: `1px solid rgba(255, 255, 255, 0.2)`,
                position: 'relative',
                overflow: 'hidden'
              }}
            >
              <span style={{
                fontSize: designTokens.typography.fontSize.xs,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.neutral[0],
                textShadow: '0 1px 2px rgba(0, 0, 0, 0.2)',
                position: 'relative',
                zIndex: 1
              }}>
                {statusConfig.label}
              </span>
            </motion.div>
          </div>
        </div>

        {/* 핵심 정보 섹션 - 일관된 디자인 */}
        <div style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'center',
          background: `linear-gradient(90deg, ${designTokens.colors.neutral[50]} 0%, ${designTokens.colors.neutral[100]} 100%)`,
          borderRadius: designTokens.borderRadius.md,
          padding: `${designTokens.spacing.sm} ${designTokens.spacing.md}`,
          marginBottom: designTokens.spacing.lg,
          boxShadow: `inset 0 1px 3px rgba(0,0,0,0.05)`
        }}>
          {getInfoItems().map((item, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 + index * 0.1, duration: 0.3 }}
              whileHover={{ 
                y: -2,
                transition: { duration: 0.1 }
              }}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.xs,
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: item.color,
              }}
            >
              {item.icon}
              <span>{item.label}</span>
            </motion.div>
          ))}
        </div>

        {/* 스코어 통계 */}
        <div style={{ 
          marginBottom: designTokens.spacing.lg
        }}>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(5, 1fr)',
            gap: designTokens.spacing.xs,
            marginBottom: designTokens.spacing.sm,
          }}>
            {getScoreStats().map((stat, index) => (
              <motion.div
                key={index}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.6 + index * 0.1, duration: 0.3 }}
                style={{
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  padding: designTokens.spacing.sm,
                  borderRadius: designTokens.borderRadius.md,
                  backgroundColor: `${stat.color}10`,
                  border: `1px solid ${stat.color}20`,
                }}
              >
                <div style={{
                  fontSize: designTokens.typography.fontSize.sm,
                  fontWeight: designTokens.typography.fontWeight.semibold,
                  color: stat.color,
                  marginBottom: designTokens.spacing.xs,
                }}>
                  {stat.value}
                </div>
                <div style={{
                  fontSize: designTokens.typography.fontSize.xs,
                  color: designTokens.colors.text.secondary,
                  textAlign: 'center',
                }}>
                  {stat.label}
                </div>
              </motion.div>
            ))}
          </div>
        </div>

        {/* 풀-위드스 CTA 버튼 */}
        <div style={{ marginBottom: designTokens.spacing.md }}>
          <motion.div
            whileHover={{ 
              scale: 1.02,
              boxShadow: `0 8px 20px ${statusConfig.color}40`,
              transition: { duration: 0.2 }
            }}
            whileTap={{ 
              scale: 0.98,
              transition: { duration: 0.1 }
            }}
            style={{
              width: '100%',
              display: 'inline-block',
              background: `
                linear-gradient(135deg, 
                  ${statusConfig.color} 0%, 
                  ${statusConfig.color}80 50%,
                  ${statusConfig.color}60 100%
                )
              `,
              borderRadius: '16px',
              padding: `${designTokens.spacing.xs} ${designTokens.spacing.lg}`,
              boxShadow: `
                0 6px 16px ${statusConfig.color}30,
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
              fontSize: designTokens.typography.fontSize.sm,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.neutral[0],
              textShadow: '0 1px 2px rgba(0, 0, 0, 0.3)',
              position: 'relative',
              zIndex: 1
            }}>
              상세보기
            </span>
          </motion.div>
        </div>

        {/* 설명 박스 */}
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