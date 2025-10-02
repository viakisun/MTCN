import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useRoundingData } from '@/hooks';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import { Card, Badge, Avatar, Button } from '@/components/ui';

interface LiveGamePageProps {
  roundingId?: string;
  onBack?: () => void;
}

interface HoleScore {
  hole: number;
  par: number;
  score: number;
  status: 'completed' | 'current' | 'upcoming';
}

interface PlayerScore {
  playerId: string;
  playerName: string;
  avatar?: string;
  totalScore: number;
  holes: HoleScore[];
  currentHole: number;
  status: 'playing' | 'finished' | 'waiting';
}

const LiveGamePage: React.FC<LiveGamePageProps> = ({ roundingId, onBack }) => {
  const { setActiveTab } = useAppStore();
  
  // 목업 데이터 초기화
  useMockData();
  
  // 라운딩 데이터 가져오기
  const { roundings } = useRoundingData();

  // 선택된 라운딩 찾기
  const selectedRounding = roundingId 
    ? roundings.find(r => r.id === roundingId) 
    : roundings.find(r => r.status === 'in-progress') || roundings[0];

  // 실시간 스코어 상태
  const [playerScores, setPlayerScores] = useState<PlayerScore[]>([]);
  const [currentHole, setCurrentHole] = useState(1);
  const [gameStatus, setGameStatus] = useState<'playing' | 'finished'>('playing');

  // 실시간 스코어 데이터 초기화
  useEffect(() => {
    if (selectedRounding) {
      const initialScores: PlayerScore[] = selectedRounding.players.map((player, index) => ({
        playerId: player.id,
        playerName: player.name,
        avatar: player.avatar,
        totalScore: 0,
        currentHole: 1,
        status: 'playing' as const,
        holes: Array.from({ length: selectedRounding.holes }, (_, i) => ({
          hole: i + 1,
          par: 4, // 기본 파 4
          score: 0,
          status: i === 0 ? 'current' as const : 'upcoming' as const
        }))
      }));
      setPlayerScores(initialScores);
    }
  }, [selectedRounding]);

  // 실시간 업데이트 시뮬레이션
  useEffect(() => {
    if (gameStatus === 'playing') {
      const interval = setInterval(() => {
        setPlayerScores(prevScores => {
          return prevScores.map(player => {
            if (player.status === 'playing' && Math.random() > 0.7) {
              const updatedHoles = player.holes.map(hole => {
                if (hole.status === 'current' && hole.score === 0) {
                  const newScore = Math.floor(Math.random() * 3) + 3; // 3-5점
                  return { ...hole, score: newScore, status: 'completed' as const };
                }
                return hole;
              });

              const nextHoleIndex = updatedHoles.findIndex(hole => hole.status === 'current');
              if (nextHoleIndex !== -1 && nextHoleIndex < updatedHoles.length - 1) {
                updatedHoles[nextHoleIndex + 1].status = 'current';
              }

              const totalScore = updatedHoles.reduce((sum, hole) => sum + hole.score, 0);
              const currentHoleNum = updatedHoles.findIndex(hole => hole.status === 'current') + 1;

              return {
                ...player,
                holes: updatedHoles,
                totalScore,
                currentHole: currentHoleNum || selectedRounding?.holes || 18,
                status: currentHoleNum > (selectedRounding?.holes || 18) ? 'finished' as const : 'playing' as const
              };
            }
            return player;
          });
        });
      }, 3000);

      return () => clearInterval(interval);
    }
  }, [gameStatus, selectedRounding]);

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
            진행 중인 경기를 찾을 수 없습니다
          </div>
        </div>
      </div>
    );
  }

  const getScoreColor = (score: number, par: number) => {
    if (score === 0) return designTokens.colors.text.secondary;
    if (score < par) return designTokens.colors.success[600]; // 언더파
    if (score === par) return designTokens.colors.text.primary; // 파
    if (score === par + 1) return designTokens.colors.warning[600]; // 보기
    return designTokens.colors.error[600]; // 더블보기 이상
  };

  const getScoreLabel = (score: number, par: number) => {
    if (score === 0) return '-';
    if (score < par) return `-${par - score}`;
    if (score === par) return 'E';
    return `+${score - par}`;
  };

  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ 
        padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
        backgroundColor: designTokens.colors.background.light
      }}
    >
      {/* 헤더 - 일관된 스타일 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
          {getIconComponent('golf-ball', { size: 24, color: designTokens.colors.primary[600] })}
          <h1 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0
          }}>
            실시간 경기
          </h1>
        </div>
        <p style={{
          fontSize: designTokens.typography.fontSize.sm,
          color: designTokens.colors.text.secondary,
          margin: 0
        }}>
          {selectedRounding.eventName} • {selectedRounding.courseName}
        </p>
      </motion.div>

      {/* 경기 상태 카드 */}
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
            {getIconComponent('flag', { size: 60, color: designTokens.colors.primary[300] })}
          </div>

          <div style={{ position: 'relative', zIndex: 1 }}>
            {/* 현재 홀 정보 */}
            <div style={{ 
              display: 'flex', 
              justifyContent: 'space-between', 
              alignItems: 'center',
              marginBottom: designTokens.spacing.lg
            }}>
              <div>
                <h2 style={{
                  fontSize: designTokens.typography.fontSize['2xl'],
                  fontWeight: designTokens.typography.fontWeight.bold,
                  color: designTokens.colors.text.primary,
                  margin: 0,
                  marginBottom: designTokens.spacing.sm,
                }}>
                  {currentHole}번 홀
                </h2>
                <div style={{
                  fontSize: designTokens.typography.fontSize.base,
                  color: designTokens.colors.text.secondary,
                  display: 'flex',
                  alignItems: 'center',
                  gap: designTokens.spacing.sm,
                }}>
                  {getIconComponent('tee', { size: 16, color: designTokens.colors.text.secondary })}
                  <span>파 4</span>
                </div>
              </div>
              
              {/* 경기 상태 배지 */}
              <Badge
                variant="primary"
                style={{
                  background: `
                    linear-gradient(135deg, 
                      ${designTokens.colors.success[500]} 0%, 
                      ${designTokens.colors.success[600]} 50%,
                      ${designTokens.colors.success[700]} 100%
                    )
                  `,
                  borderRadius: '12px',
                  padding: `${designTokens.spacing.sm} ${designTokens.spacing.md}`,
                  boxShadow: `
                    0 2px 8px ${designTokens.colors.success[500]}20,
                    0 1px 2px rgba(0, 0, 0, 0.1)
                  `,
                  border: `1px solid rgba(255, 255, 255, 0.2)`,
                }}
              >
                진행중
              </Badge>
            </div>

            {/* 날씨 정보 */}
            <div style={{ 
              display: 'flex', 
              justifyContent: 'space-between', 
              alignItems: 'center',
              background: `linear-gradient(90deg, ${designTokens.colors.neutral[50]} 0%, ${designTokens.colors.neutral[100]} 100%)`,
              borderRadius: designTokens.borderRadius.lg,
              padding: designTokens.spacing.md,
              boxShadow: `inset 0 1px 3px rgba(0,0,0,0.05)`
            }}>
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.sm,
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: selectedRounding.weather === 'sunny' ? designTokens.colors.warning[500] : designTokens.colors.text.secondary,
              }}>
                {getIconComponent(selectedRounding.weather, { 
                  size: 16, 
                  color: selectedRounding.weather === 'sunny' ? designTokens.colors.warning[500] : designTokens.colors.text.secondary 
                })}
                <span>{selectedRounding.temperature}°C</span>
              </div>
              <div style={{
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.text.secondary,
              }}>
                {selectedRounding.time}
              </div>
            </div>
          </div>
        </Card>
      </motion.div>

      {/* 실시간 스코어보드 */}
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
            실시간 스코어보드
          </h3>
        </div>

        <div style={{
          display: 'flex',
          flexDirection: 'column',
          gap: designTokens.spacing.md,
        }}>
          {playerScores.map((player, index) => (
            <motion.div
              key={player.playerId}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 + index * 0.1, duration: 0.3 }}
            >
              <Card
                style={{
                  padding: designTokens.spacing.lg,
                  background: `
                    linear-gradient(135deg, 
                      rgba(255, 255, 255, 0.95) 0%, 
                      rgba(250, 250, 250, 0.9) 100%
                    )
                  `,
                  backdropFilter: 'blur(10px)',
                  borderRadius: designTokens.borderRadius.lg,
                  border: `1px solid rgba(0, 0, 0, 0.06)`,
                  boxShadow: player.status === 'playing' 
                    ? `0 4px 16px ${designTokens.colors.primary[500]}20`
                    : designTokens.boxShadow.sm,
                }}
              >
                <div style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: designTokens.spacing.md,
                  marginBottom: designTokens.spacing.md,
                }}>
                  <Avatar 
                    name={player.playerName} 
                    avatar={player.avatar} 
                    size="md"
                  />
                  <div style={{ flex: 1 }}>
                    <div style={{
                      fontSize: designTokens.typography.fontSize.base,
                      fontWeight: designTokens.typography.fontWeight.semibold,
                      color: designTokens.colors.text.primary,
                      marginBottom: designTokens.spacing.xs,
                    }}>
                      {player.playerName}
                    </div>
                    <div style={{
                      fontSize: designTokens.typography.fontSize.sm,
                      color: designTokens.colors.text.secondary,
                    }}>
                      {player.status === 'playing' ? `${player.currentHole}번 홀 진행중` : '경기 완료'}
                    </div>
                  </div>
                  <div style={{
                    textAlign: 'right',
                  }}>
                    <div style={{
                      fontSize: designTokens.typography.fontSize['2xl'],
                      fontWeight: designTokens.typography.fontWeight.bold,
                      color: designTokens.colors.text.primary,
                    }}>
                      {player.totalScore}
                    </div>
                    <div style={{
                      fontSize: designTokens.typography.fontSize.sm,
                      color: designTokens.colors.text.secondary,
                    }}>
                      총 스코어
                    </div>
                  </div>
                </div>

                {/* 홀별 스코어 그리드 */}
                <div style={{
                  display: 'grid',
                  gridTemplateColumns: 'repeat(6, 1fr)',
                  gap: designTokens.spacing.xs,
                }}>
                  {player.holes.slice(0, 6).map((hole) => (
                    <div
                      key={hole.hole}
                      style={{
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                        padding: designTokens.spacing.sm,
                        borderRadius: designTokens.borderRadius.md,
                        backgroundColor: hole.status === 'current' 
                          ? designTokens.colors.primary[50]
                          : hole.status === 'completed'
                          ? designTokens.colors.neutral[50]
                          : 'transparent',
                        border: hole.status === 'current' 
                          ? `2px solid ${designTokens.colors.primary[500]}`
                          : `1px solid ${designTokens.colors.neutral[200]}`,
                      }}
                    >
                      <div style={{
                        fontSize: designTokens.typography.fontSize.xs,
                        fontWeight: designTokens.typography.fontWeight.medium,
                        color: designTokens.colors.text.secondary,
                        marginBottom: designTokens.spacing.xs,
                      }}>
                        {hole.hole}
                      </div>
                      <div style={{
                        fontSize: designTokens.typography.fontSize.sm,
                        fontWeight: designTokens.typography.fontWeight.semibold,
                        color: getScoreColor(hole.score, hole.par),
                      }}>
                        {hole.score === 0 ? '-' : hole.score}
                      </div>
                      <div style={{
                        fontSize: designTokens.typography.fontSize.xs,
                        color: designTokens.colors.text.secondary,
                      }}>
                        {getScoreLabel(hole.score, hole.par)}
                      </div>
                    </div>
                  ))}
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

        {/* 스코어 입력 버튼 */}
        <Button
          variant="primary"
          onClick={() => setActiveTab('score')}
          style={{
            flex: 2,
            padding: `${designTokens.spacing.md} ${designTokens.spacing.lg}`,
            borderRadius: designTokens.borderRadius.lg,
            fontSize: designTokens.typography.fontSize.base,
            fontWeight: designTokens.typography.fontWeight.semibold,
            background: `
              linear-gradient(135deg, 
                ${designTokens.colors.primary[600]} 0%, 
                ${designTokens.colors.primary[700]} 50%,
                ${designTokens.colors.primary[800]} 100%
              )
            `,
            boxShadow: `
              0 6px 16px ${designTokens.colors.primary[600]}30,
              0 2px 4px rgba(0, 0, 0, 0.1),
              inset 0 1px 0 rgba(255, 255, 255, 0.2)
            `,
          }}
        >
          스코어 입력
        </Button>
      </motion.div>
    </div>
  );
};

export default LiveGamePage;