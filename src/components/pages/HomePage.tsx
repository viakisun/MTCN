import React from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useHomeData } from '@/hooks';
import { designTokens } from '@/styles/design-tokens';
import { Card, Badge, Avatar, Button } from '@/components/ui';
import { RoundingCard, RoundingCardData } from '@/components/ui/RoundingCard';
import { getIconComponent } from '@/components/icons/GolfIcons';

const HomePage: React.FC = () => {
  const { setActiveTab } = useAppStore();
  
  useMockData();
  
  const { upcomingRounding, recentScores, groupActivities } = useHomeData();

  if (!upcomingRounding) {
    return (
      <div style={{ 
        flex: 1, 
        display: 'flex', 
        alignItems: 'center', 
        justifyContent: 'center',
        backgroundColor: designTokens.colors.background.light
      }}>
        <div style={{ textAlign: 'center' }}>
          <div style={{ 
            color: designTokens.colors.text.secondary, 
            fontSize: designTokens.typography.fontSize.lg 
          }}>
            데이터를 불러오는 중...
          </div>
        </div>
      </div>
    );
  }

  const calculateDDay = (dateString: string) => {
    const today = new Date();
    const targetDate = new Date(dateString);
    const diffTime = targetDate.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
  };

  const dDay = calculateDDay(upcomingRounding.date);

  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ 
        padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
        backgroundColor: designTokens.colors.background.light
      }}
    >
      {/* Welcome Section */}
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
            fontWeight: designTokens.typography.fontWeight.bold,
            color: designTokens.colors.text.primary,
            margin: 0
          }}>
            김프로님, 라운딩이 곧 시작돼요!
          </h1>
        </div>
      </motion.div>

      {/* Primary Card - Upcoming Rounding */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <RoundingCard
          data={{
            id: upcomingRounding.id,
            courseName: upcomingRounding.courseName,
            eventName: upcomingRounding.eventName,
            date: upcomingRounding.date,
            time: upcomingRounding.time,
            status: 'upcoming' as const,
            players: upcomingRounding.players,
            weather: upcomingRounding.weather as 'sunny' | 'cloudy' | 'rainy' | 'windy',
            temperature: upcomingRounding.temperature,
            greenFee: upcomingRounding.greenFee,
            holes: upcomingRounding.holes,
            dDay: dDay,
            notice: upcomingRounding.notice
          }}
          onClick={() => setActiveTab('rounding')}
        />
      </motion.div>

      {/* Secondary Cards - Score Summary */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing['4xl'] }}
      >
        <h3 style={{
          fontSize: designTokens.typography.fontSize.xl,
          fontWeight: designTokens.typography.fontWeight.semibold,
          color: designTokens.colors.text.primary,
          marginBottom: designTokens.spacing.lg
        }}>
          최근 스코어
        </h3>
        <div style={{ display: 'flex', gap: designTokens.spacing.md }}>
          {recentScores.slice(0, 2).map((score, index) => (
            <Card key={score.id} variant="elevated" className="flex-1">
              <div style={{ textAlign: 'center' }}>
                <div style={{
                  fontSize: designTokens.typography.fontSize['2xl'],
                  fontWeight: designTokens.typography.fontWeight.bold,
                  color: designTokens.colors.primary[600],
                  marginBottom: designTokens.spacing.xs
                }}>
                  {score.totalScore}
                </div>
                <div style={{
                  fontSize: designTokens.typography.fontSize.sm,
                  color: designTokens.colors.text.secondary
                }}>
                  {score.courseName}
                </div>
                <div style={{
                  fontSize: designTokens.typography.fontSize.xs,
                  color: designTokens.colors.text.tertiary
                }}>
                  {score.date}
                </div>
              </div>
            </Card>
          ))}
        </div>
      </motion.div>

      {/* Tertiary Cards - Group Activity */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4, duration: 0.5 }}
      >
        <h3 style={{
          fontSize: designTokens.typography.fontSize.xl,
          fontWeight: designTokens.typography.fontWeight.semibold,
          color: designTokens.colors.text.primary,
          marginBottom: designTokens.spacing.lg
        }}>
          동문회 활동
        </h3>
        <div style={{ display: 'flex', gap: designTokens.spacing.md }}>
          {groupActivities.slice(0, 2).map((activity, index) => (
            <Card key={activity.id} variant="elevated" className="flex-1">
              <div style={{ textAlign: 'center' }}>
                <div style={{
                  fontSize: designTokens.typography.fontSize.lg,
                  fontWeight: designTokens.typography.fontWeight.semibold,
                  color: designTokens.colors.text.primary,
                  marginBottom: designTokens.spacing.xs
                }}>
                  {activity.groupName}
                </div>
                <div style={{
                  fontSize: designTokens.typography.fontSize.sm,
                  color: designTokens.colors.text.secondary
                }}>
                  {activity.memberCount}명
                </div>
              </div>
            </Card>
          ))}
        </div>
      </motion.div>
    </div>
  );
};

export default HomePage;