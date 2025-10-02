import React from 'react';
import { motion } from 'framer-motion';
import { Rounding } from '@/types';
import { Card, Badge, Button, Avatar, EmptyState } from '@/components/ui';
import { dateUtils, formatUtils } from '@/utils';
import { designTokens } from '@/styles/design-tokens';

interface UpcomingRoundingProps {
  rounding: Rounding | null;
  onViewDetail?: (id: string) => void;
  onEnterStadium?: (id: string) => void;
  className?: string;
}

const UpcomingRounding: React.FC<UpcomingRoundingProps> = ({
  rounding,
  onViewDetail,
  onEnterStadium,
  className = ''
}) => {
  if (!rounding) {
    return (
      <div className={className}>
        <EmptyState
          icon="⛳"
          title="예정된 라운딩이 없습니다"
          description="새로운 라운딩을 등록하거나 참가해보세요"
        />
      </div>
    );
  }

  const dDay = dateUtils.calculateDDay(rounding.date);

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.2, duration: 0.5 }}
      className={className}
    >
      <div style={{ marginBottom: designTokens.spacing['2xl'] }}>
        <h2 style={{
          fontSize: designTokens.typography.fontSize['4xl'],
          fontWeight: designTokens.typography.fontWeight.bold,
          color: designTokens.colors.text.primary,
          marginBottom: designTokens.spacing.sm
        }}>
          다가오는 라운딩
        </h2>
        <p style={{
          fontSize: designTokens.typography.fontSize.sm,
          color: designTokens.colors.text.secondary
        }}>
          {rounding.courseName}
        </p>
      </div>

      <Card className="p-5">
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'flex-start',
          marginBottom: designTokens.spacing.md
        }}>
          <div>
            <h3 style={{
              fontSize: designTokens.typography.fontSize['2xl'],
              fontWeight: designTokens.typography.fontWeight.bold,
              color: designTokens.colors.text.primary,
              marginBottom: designTokens.spacing.xs
            }}>
              {rounding.courseName}
            </h3>
            <p style={{
              fontSize: designTokens.typography.fontSize.sm,
              color: designTokens.colors.text.secondary
            }}>
              {dateUtils.formatDate(rounding.date)} • {rounding.time}
            </p>
          </div>
          {dDay >= 0 && (
            <Badge variant="primary">
              D-{dDay}
            </Badge>
          )}
        </div>

        <div style={{
          display: 'flex',
          gap: designTokens.spacing.sm,
          marginBottom: designTokens.spacing.lg,
          flexWrap: 'wrap'
        }}>
          <Badge variant="success">
            ☀️ {rounding.weather} {rounding.temperature}°C
          </Badge>
          <Badge variant="secondary">
            {formatUtils.formatPrice(rounding.greenFee)}
          </Badge>
        </div>

        <div style={{
          display: 'flex',
          gap: designTokens.spacing.sm,
          marginBottom: designTokens.spacing.lg,
          alignItems: 'center'
        }}>
          {rounding.players.slice(0, 4).map((player, index) => (
            <Avatar
              key={player.id}
              name={player.name}
              avatar={player.avatar}
              size="md"
            />
          ))}
          {rounding.players.length > 4 && (
            <div style={{
              width: '32px',
              height: '32px',
              borderRadius: '50%',
              background: '#F3F4F6',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '12px',
              color: '#6B7280',
              border: '2px solid white',
              boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)'
            }}>
              +{rounding.players.length - 4}
            </div>
          )}
        </div>

        <div style={{
          background: '#FEF3C7',
          color: '#92400E',
          fontSize: designTokens.typography.fontSize.xs,
          padding: designTokens.spacing.sm,
          borderRadius: designTokens.borderRadius.md,
          marginBottom: designTokens.spacing.lg,
          textAlign: 'center'
        }}>
          입장 가능 시간: 경기 시작 30분 전부터
        </div>

        <div style={{
          display: 'flex',
          gap: designTokens.spacing.sm
        }}>
          <Button 
            variant="secondary" 
            onClick={() => onViewDetail?.(rounding.id)}
            style={{ flex: 1 }}
          >
            상세보기
          </Button>
          <Button 
            variant="primary" 
            onClick={() => onEnterStadium?.(rounding.id)}
            style={{ flex: 1 }}
          >
            경기장 입장
          </Button>
        </div>
      </Card>
    </motion.div>
  );
};

export default UpcomingRounding;
