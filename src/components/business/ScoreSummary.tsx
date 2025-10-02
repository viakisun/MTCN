import React from 'react';
import { motion } from 'framer-motion';
import { Player, ScoreRecord } from '@/types';
import { StatCard, Button } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';

interface ScoreSummaryProps {
  currentUser: Player | null;
  recentScores: ScoreRecord[];
  onViewAllScores?: () => void;
  className?: string;
}

const ScoreSummary: React.FC<ScoreSummaryProps> = ({
  currentUser,
  recentScores,
  onViewAllScores,
  className = ''
}) => {
  const thisMonthRounds = recentScores.filter(score => {
    const scoreDate = new Date(score.date);
    const now = new Date();
    return scoreDate.getMonth() === now.getMonth() && 
           scoreDate.getFullYear() === now.getFullYear();
  }).length;

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.3, duration: 0.5 }}
      className={className}
    >
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: designTokens.spacing.lg
      }}>
        <h2 style={{
          fontSize: designTokens.typography.fontSize['4xl'],
          fontWeight: designTokens.typography.fontWeight.bold,
          color: designTokens.colors.text.primary,
          margin: 0
        }}>
          나의 스코어 요약
        </h2>
        <Button 
          variant="text" 
          onClick={onViewAllScores}
          size="sm"
        >
          전체보기
        </Button>
      </div>

      <div style={{
        display: 'grid',
        gridTemplateColumns: 'repeat(3, 1fr)',
        gap: designTokens.spacing.md
      }}>
        <StatCard 
          title="평균 스코어" 
          value={currentUser?.averageScore || 0} 
          unit="타"
          className="text-center"
        />
        <StatCard 
          title="베스트 스코어" 
          value={currentUser?.bestScore || 0} 
          unit="타"
          className="text-center"
        />
        <StatCard 
          title="이번 달 라운딩" 
          value={thisMonthRounds} 
          unit="회"
          className="text-center"
        />
      </div>

      {/* 최근 성과 표시 */}
      {recentScores.length > 0 && (
        <div style={{
          marginTop: designTokens.spacing.lg,
          padding: designTokens.spacing.md,
          background: '#F9FAFB',
          borderRadius: designTokens.borderRadius.lg,
          textAlign: 'center'
        }}>
          <p style={{
            fontSize: designTokens.typography.fontSize.sm,
            color: designTokens.colors.text.secondary,
            margin: 0
          }}>
            최근 라운딩: {recentScores[0].courseName} ({recentScores[0].totalScore}타)
          </p>
        </div>
      )}
    </motion.div>
  );
};

export default ScoreSummary;
