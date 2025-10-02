import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useRoundingData } from '@/hooks';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import { Card, Badge, Avatar, Button } from '@/components/ui';
import LiveGamePage from './LiveGamePage';

interface RoundingDetailPageProps {
  roundingId?: string;
  onBack?: () => void;
}

const RoundingDetailPage: React.FC<RoundingDetailPageProps> = ({ roundingId, onBack }) => {
  const { setActiveTab } = useAppStore();
  
  // 목업 데이터 초기화
  useMockData();
  
  // 라운딩 데이터 가져오기
  const { roundings } = useRoundingData();

  // 실시간 경기 페이지 상태
  const [showLiveGame, setShowLiveGame] = useState(false);

  // 선택된 라운딩 찾기 (기본적으로 첫 번째 라운딩 사용)
  const selectedRounding = roundingId 
    ? roundings.find(r => r.id === roundingId) 
    : roundings[0];

  // D-Day 계산 함수
  const calculateDDay = (dateString: string) => {
    const today = new Date();
    const targetDate = new Date(dateString);
    const diffTime = targetDate.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
  };

  // 상태 매핑
  const statusMapping: { [key: string]: keyof typeof designTokens.golf.status } = {
    'upcoming': 'scheduled',
    'in-progress': 'inProgress',
    'completed': 'completed',
    'scheduled': 'scheduled',
    'inProgress': 'inProgress'
  };

  const mappedStatus = selectedRounding ? statusMapping[selectedRounding.status] || 'scheduled' : 'scheduled';
  const statusConfig = designTokens.golf.status[mappedStatus];

  // 실시간 경기 페이지 표시
  if (showLiveGame && selectedRounding) {
    return (
      <LiveGamePage 
        roundingId={selectedRounding.id}
        onBack={() => setShowLiveGame(false)}
      />
    );
  }

  if (!selectedRounding) {
    return (
      <div 
        className="flex-1 overflow-y-auto scroll-container"
        style={{ 
          padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
          backgroundColor: designTokens.colors.background.light
        }}
      >
        <div style={{ textAlign: 'center', padding: designTokens.spacing['4xl'] }}>
          <div style={{ 
            color: designTokens.colors.text.secondary, 
            fontSize: designTokens.typography.fontSize.lg 
          }}>
            라운딩 정보를 찾을 수 없습니다
          </div>
        </div>
      </div>
    );
  }

  const dDay = calculateDDay(selectedRounding.date);

  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ 
        padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
        backgroundColor: designTokens.colors.background.light
      }}
    >
      {/* 헤더 - 홈페이지와 일관된 스타일 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
          {getIconComponent('calendar', { size: 24, color: designTokens.colors.primary[600] })}
          <h1 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0
          }}>
            라운딩 상세
          </h1>
        </div>
        <p style={{
          fontSize: designTokens.typography.fontSize.sm,
          color: designTokens.colors.text.secondary,
          margin: 0
        }}>
          라운딩 정보와 참가자들을 확인하세요
        </p>
      </motion.div>

      {/* 메인 라운딩 정보 카드 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <Card
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
          }}
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
            {getIconComponent('golf-ball', { size: 60, color: designTokens.colors.primary[300] })}
          </div>

          <div style={{ position: 'relative', zIndex: 1 }}>
            {/* 상단: 이벤트명 + 상태 배지 */}
            <div style={{ 
              display: 'flex', 
              justifyContent: 'space-between', 
              alignItems: 'flex-start',
              marginBottom: designTokens.spacing.lg
            }}>
              <div style={{ flex: 1, marginRight: designTokens.spacing.md }}>
                {/* 이벤트명 */}
                <h2 style={{
                  fontSize: designTokens.typography.fontSize['2xl'],
                  fontWeight: designTokens.typography.fontWeight.bold,
                  color: designTokens.colors.text.primary,
                  margin: 0,
                  marginBottom: designTokens.spacing.sm,
                  lineHeight: designTokens.typography.lineHeight.tight,
                }}>
                  {selectedRounding.eventName}
                </h2>
                
                {/* 골프장명 */}
                <div style={{
                  fontSize: designTokens.typography.fontSize.lg,
                  fontWeight: designTokens.typography.fontWeight.semibold,
                  color: designTokens.colors.text.secondary,
                  marginBottom: designTokens.spacing.md,
                }}>
                  {selectedRounding.courseName}
                </div>
                
                {/* 날짜/시간 */}
                <div style={{
                  fontSize: designTokens.typography.fontSize.base,
                  fontWeight: designTokens.typography.fontWeight.medium,
                  color: designTokens.colors.text.secondary,
                  display: 'flex',
                  alignItems: 'center',
                  gap: designTokens.spacing.sm,
                }}>
                  {getIconComponent('calendar', { size: 16, color: designTokens.colors.text.secondary })}
                  <span>{selectedRounding.date} • {selectedRounding.time}</span>
                </div>
              </div>
              
              {/* 상태 배지들 */}
              <div style={{ 
                display: 'flex', 
                flexDirection: 'column', 
                gap: designTokens.spacing.sm, 
                alignItems: 'flex-end',
                flexShrink: 0
              }}>
                {/* 상태 배지 */}
                <Badge
                  variant="primary"
                  style={{
                    background: `
                      linear-gradient(135deg, 
                        ${statusConfig.primary} 0%, 
                        ${statusConfig.accent} 50%,
                        ${statusConfig.accent} 100%
                      )
                    `,
                    borderRadius: '12px',
                    padding: `${designTokens.spacing.sm} ${designTokens.spacing.md}`,
                    boxShadow: `
                      0 2px 8px ${statusConfig.primary}20,
                      0 1px 2px rgba(0, 0, 0, 0.1)
                    `,
                    border: `1px solid rgba(255, 255, 255, 0.2)`,
                  }}
                >
                  {(() => {
                    const statusLabels = {
                      scheduled: '예정',
                      inProgress: '진행중',
                      completed: '완료',
                      upcoming: '예정',
                      'in-progress': '진행중'
                    };
                    return statusLabels[selectedRounding.status] || '예정';
                  })()}
                </Badge>
                
                {/* D-Day 배지 */}
                {dDay >= 0 && (
                  <Badge
                    variant="primary"
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
                    }}
                  >
                    D-{dDay}
                  </Badge>
                )}
              </div>
            </div>

            {/* 핵심 정보 섹션 */}
            <div style={{ 
              display: 'grid', 
              gridTemplateColumns: 'repeat(2, 1fr)',
              gap: designTokens.spacing.md,
              background: `linear-gradient(90deg, ${designTokens.colors.neutral[50]} 0%, ${designTokens.colors.neutral[100]} 100%)`,
              borderRadius: designTokens.borderRadius.lg,
              padding: designTokens.spacing.lg,
              marginBottom: designTokens.spacing.lg,
              boxShadow: `inset 0 1px 3px rgba(0,0,0,0.05)`
            }}>
              {/* 홀 수 */}
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.sm,
                fontSize: designTokens.typography.fontSize.base,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.text.secondary,
              }}>
                {getIconComponent('tee', { size: 20, color: designTokens.colors.text.secondary })}
                <span>{selectedRounding.holes}홀</span>
              </div>

              {/* 날씨 */}
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.sm,
                fontSize: designTokens.typography.fontSize.base,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: selectedRounding.weather === 'sunny' ? designTokens.colors.warning[500] : designTokens.colors.text.secondary,
              }}>
                {getIconComponent(selectedRounding.weather, { 
                  size: 20, 
                  color: selectedRounding.weather === 'sunny' ? designTokens.colors.warning[500] : designTokens.colors.text.secondary 
                })}
                <span>{selectedRounding.temperature}°C</span>
              </div>

              {/* 참가자 수 */}
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.sm,
                fontSize: designTokens.typography.fontSize.base,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.text.secondary,
              }}>
                {getIconComponent('users', { size: 20, color: designTokens.colors.text.secondary })}
                <span>{selectedRounding.players.length}명</span>
              </div>

              {/* 그린피 */}
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.sm,
                fontSize: designTokens.typography.fontSize.base,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.text.secondary,
              }}>
                {getIconComponent('golf-ball', { size: 20, color: designTokens.colors.text.secondary })}
                <span>₩{selectedRounding.greenFee.toLocaleString()}</span>
              </div>
            </div>

            {/* 주의사항 */}
            {selectedRounding.notice && (
              <div style={{
                background: `linear-gradient(135deg, ${designTokens.colors.warning[50]} 0%, ${designTokens.colors.warning[100]} 100%)`,
                borderRadius: designTokens.borderRadius.md,
                padding: designTokens.spacing.md,
                marginBottom: designTokens.spacing.lg,
                border: `1px solid ${designTokens.colors.warning[200]}`,
              }}>
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: designTokens.spacing.sm,
                  marginBottom: designTokens.spacing.sm,
                }}>
                  {getIconComponent('golf-ball', { size: 16, color: designTokens.colors.warning[600] })}
                  <span style={{
                    fontSize: designTokens.typography.fontSize.sm,
                    fontWeight: designTokens.typography.fontWeight.semibold,
                    color: designTokens.colors.warning[700],
                  }}>
                    주의사항
                  </span>
                </div>
                <p style={{
                  fontSize: designTokens.typography.fontSize.sm,
                  color: designTokens.colors.warning[600],
                  margin: 0,
                  lineHeight: designTokens.typography.lineHeight.relaxed,
                }}>
                  {selectedRounding.notice}
                </p>
              </div>
            )}
          </div>
        </Card>
      </motion.div>

      {/* 참가자 섹션 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <div style={{ marginBottom: designTokens.spacing.md }}>
          <h3 style={{
            fontSize: designTokens.typography.fontSize.lg,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0,
            marginBottom: designTokens.spacing.sm,
          }}>
            참가자 ({selectedRounding.players.length}명)
          </h3>
        </div>

        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
          gap: designTokens.spacing.md,
        }}>
          {selectedRounding.players.map((player, index) => (
            <motion.div
              key={player.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 + index * 0.1, duration: 0.3 }}
            >
              <Card
                style={{
                  padding: designTokens.spacing.lg,
                  display: 'flex',
                  alignItems: 'center',
                  gap: designTokens.spacing.md,
                  background: `
                    linear-gradient(135deg, 
                      rgba(255, 255, 255, 0.95) 0%, 
                      rgba(250, 250, 250, 0.9) 100%
                    )
                  `,
                  backdropFilter: 'blur(10px)',
                  borderRadius: designTokens.borderRadius.lg,
                  border: `1px solid rgba(0, 0, 0, 0.06)`,
                  boxShadow: designTokens.boxShadow.sm,
                }}
              >
                <Avatar 
                  name={player.name} 
                  avatar={player.avatar} 
                  size="lg"
                />
                <div style={{ flex: 1 }}>
                  <div style={{
                    fontSize: designTokens.typography.fontSize.base,
                    fontWeight: designTokens.typography.fontWeight.semibold,
                    color: designTokens.colors.text.primary,
                    marginBottom: designTokens.spacing.xs,
                  }}>
                    {player.name}
                  </div>
                  <div style={{
                    fontSize: designTokens.typography.fontSize.sm,
                    color: designTokens.colors.text.secondary,
                  }}>
                    참가자 #{index + 1}
                  </div>
                </div>
                <div style={{
                  fontSize: designTokens.typography.fontSize.sm,
                  color: designTokens.colors.text.secondary,
                  fontWeight: designTokens.typography.fontWeight.medium,
                }}>
                  {index === 0 ? '주최자' : '참가자'}
                </div>
              </Card>
            </motion.div>
          ))}
        </div>
      </motion.div>

      {/* 액션 버튼들 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5, duration: 0.5 }}
        style={{ 
          display: 'flex', 
          gap: designTokens.spacing.md,
          marginBottom: designTokens.spacing['2xl']
        }}
      >
        {/* 뒤로가기 버튼 */}
        <Button
          variant="secondary"
          onClick={onBack || (() => setActiveTab('rounding'))}
          style={{
            flex: 1,
            padding: `${designTokens.spacing.md} ${designTokens.spacing.lg}`,
            borderRadius: designTokens.borderRadius.lg,
            fontSize: designTokens.typography.fontSize.base,
            fontWeight: designTokens.typography.fontWeight.medium,
          }}
        >
          뒤로가기
        </Button>

        {/* 메인 액션 버튼 */}
        <Button
          variant="primary"
          onClick={() => {
            if (mappedStatus === 'scheduled') {
              // 상세보기 액션
              console.log('상세보기');
            } else if (mappedStatus === 'inProgress') {
              // 경기장 입장 액션 - 실시간 경기 페이지로 이동
              setShowLiveGame(true);
            } else if (mappedStatus === 'completed') {
              // 결과보기 액션
              setActiveTab('score');
            }
          }}
          style={{
            flex: 2,
            padding: `${designTokens.spacing.md} ${designTokens.spacing.lg}`,
            borderRadius: designTokens.borderRadius.lg,
            fontSize: designTokens.typography.fontSize.base,
            fontWeight: designTokens.typography.fontWeight.semibold,
            background: `
              linear-gradient(135deg, 
                ${statusConfig.primary} 0%, 
                ${statusConfig.accent} 50%,
                ${statusConfig.accent} 100%
              )
            `,
            boxShadow: `
              0 6px 16px ${statusConfig.primary}30,
              0 2px 4px rgba(0, 0, 0, 0.1),
              inset 0 1px 0 rgba(255, 255, 255, 0.2)
            `,
          }}
        >
          {(() => {
            switch (mappedStatus) {
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
        </Button>
      </motion.div>
    </div>
  );
};

export default RoundingDetailPage;