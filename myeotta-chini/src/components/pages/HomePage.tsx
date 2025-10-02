"use client";

import React, { useEffect } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { designTokens } from '@/styles/design-tokens';
import { generateRoundings, generateGroups, generateScoreRecords } from '@/lib/mock-data';

const HomePage: React.FC = () => {
  const { 
    setRoundings, 
    setGroups, 
    setScoreRecords,
    isDemoMode,
    demoStep,
    setDemoStep 
  } = useAppStore();

  // 목업 데이터 초기화
  useEffect(() => {
    setRoundings(generateRoundings());
    setGroups(generateGroups());
    setScoreRecords(generateScoreRecords());
  }, [setRoundings, setGroups, setScoreRecords]);

  const upcomingRounding = generateRoundings()[0];

  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ padding: `${designTokens.spacing['2xl']} ${designTokens.spacing['3xl']} 120px` }}
    >
      {/* 다가오는 라운딩 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing['5xl'] }}
      >
        <motion.div style={{ marginBottom: designTokens.spacing['2xl'] }}>
          <h2 style={{
            fontSize: designTokens.typography.fontSize['4xl'],
            fontWeight: designTokens.typography.fontWeight.bold,
            color: designTokens.colors.text.primary,
          }}>
            🏌️ 김프로님, 라운딩이 곧 시작돼요!
          </h2>
        </motion.div>
        
        {/* 경기 카드 */}
        <motion.div
          className="card-hover"
          style={{
            background: 'white',
            border: '2px solid #2563EB',
            borderRadius: designTokens.borderRadius.lg,
            padding: designTokens.spacing.xl,
            marginBottom: designTokens.spacing.lg,
            boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)',
            cursor: 'pointer',
            transition: 'all 0.3s ease'
          }}
          whileHover={{ 
            scale: 1.02,
            boxShadow: '0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)'
          }}
          whileTap={{ scale: 0.98 }}
        >
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'flex-start',
            marginBottom: designTokens.spacing.md
          }}>
            <div>
              <h3 style={{
                fontSize: designTokens.typography.fontSize.xl,
                fontWeight: designTokens.typography.fontWeight.bold,
                color: designTokens.colors.text.primary,
                marginBottom: designTokens.spacing.xs
              }}>
                {upcomingRounding.courseName}
              </h3>
              <p style={{
                fontSize: designTokens.typography.fontSize.sm,
                color: designTokens.colors.text.secondary,
                marginBottom: designTokens.spacing.sm
              }}>
                {upcomingRounding.date} • {upcomingRounding.time}
              </p>
            </div>
            <div style={{
              background: '#2563EB',
              color: 'white',
              padding: `${designTokens.spacing.xs} ${designTokens.spacing.sm}`,
              borderRadius: designTokens.borderRadius.md,
              fontSize: designTokens.typography.fontSize.xs,
              fontWeight: designTokens.typography.fontWeight.medium
            }}>
              {upcomingRounding.status}
            </div>
          </div>
          
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: designTokens.spacing.md
          }}>
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.sm
            }}>
              <span style={{
                fontSize: designTokens.typography.fontSize.sm,
                color: designTokens.colors.text.secondary
              }}>
                {upcomingRounding.courseName}
              </span>
            </div>
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.xs
            }}>
              <span style={{
                fontSize: designTokens.typography.fontSize.sm,
                color: designTokens.colors.text.secondary
              }}>
                {upcomingRounding.players.length}명
              </span>
            </div>
          </div>
          
          <div style={{
            display: 'flex',
            gap: designTokens.spacing.sm,
            marginBottom: designTokens.spacing.md
          }}>
            {upcomingRounding.players.slice(0, 4).map((participant, index) => (
              <div
                key={index}
                style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '50%',
                  background: participant.avatar ? `url(${participant.avatar})` : '#E5E7EB',
                  backgroundSize: 'cover',
                  backgroundPosition: 'center',
                  border: '2px solid white',
                  boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)'
                }}
                title={participant.name}
              />
            ))}
            {upcomingRounding.players.length > 4 && (
              <div style={{
                width: '32px',
                height: '32px',
                borderRadius: '50%',
                background: '#F3F4F6',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: designTokens.typography.fontSize.xs,
                color: designTokens.colors.text.secondary,
                border: '2px solid white',
                boxShadow: '0 2px 4px rgba(0, 0, 0, 0.1)'
              }}>
                +{upcomingRounding.players.length - 4}
              </div>
            )}
          </div>
          
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center'
          }}>
            <div style={{
              display: 'flex',
              gap: designTokens.spacing.sm
            }}>
              <span style={{
                fontSize: designTokens.typography.fontSize.sm,
                color: designTokens.colors.text.secondary
              }}>
                {upcomingRounding.greenFee.toLocaleString()}원
              </span>
              <span style={{
                fontSize: designTokens.typography.fontSize.sm,
                color: designTokens.colors.text.secondary
              }}>
                🏆 상금 없음
              </span>
            </div>
            <div style={{
              background: '#10B981',
              color: 'white',
              padding: `${designTokens.spacing.xs} ${designTokens.spacing.sm}`,
              borderRadius: designTokens.borderRadius.md,
              fontSize: designTokens.typography.fontSize.xs,
              fontWeight: designTokens.typography.fontWeight.medium
            }}>
              입장하기
            </div>
          </div>
        </motion.div>
      </motion.div>

      {/* 최근 라운딩 기록 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4, duration: 0.5 }}
      >
        <h3 style={{
          fontSize: designTokens.typography.fontSize.xl,
          fontWeight: designTokens.typography.fontWeight.bold,
          color: designTokens.colors.text.primary,
          marginBottom: designTokens.spacing.lg
        }}>
          최근 라운딩 기록
        </h3>
        
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          gap: designTokens.spacing.md
        }}>
          {generateRoundings().slice(1, 4).map((rounding, index) => (
            <motion.div
              key={index}
              className="card-hover"
              style={{
                background: 'white',
                borderRadius: designTokens.borderRadius.lg,
                padding: designTokens.spacing.lg,
                boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)',
                cursor: 'pointer',
                transition: 'all 0.3s ease'
              }}
              whileHover={{ 
                scale: 1.01,
                boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)'
              }}
              whileTap={{ scale: 0.99 }}
            >
              <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'flex-start',
                marginBottom: designTokens.spacing.sm
              }}>
                <div>
                  <h4 style={{
                    fontSize: designTokens.typography.fontSize.base,
                    fontWeight: designTokens.typography.fontWeight.medium,
                    color: designTokens.colors.text.primary,
                    marginBottom: designTokens.spacing.xs
                  }}>
                    {rounding.courseName}
                  </h4>
                  <p style={{
                    fontSize: designTokens.typography.fontSize.sm,
                    color: designTokens.colors.text.secondary
                  }}>
                    {rounding.date} • {rounding.courseName}
                  </p>
                </div>
                <div style={{
                  background: rounding.status === 'completed' ? '#10B981' : '#F59E0B',
                  color: 'white',
                  padding: `${designTokens.spacing.xs} ${designTokens.spacing.sm}`,
                  borderRadius: designTokens.borderRadius.md,
                  fontSize: designTokens.typography.fontSize.xs,
                  fontWeight: designTokens.typography.fontWeight.medium
                }}>
                  {rounding.status}
                </div>
              </div>
              
              <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center'
              }}>
                <div style={{
                  display: 'flex',
                  gap: designTokens.spacing.sm
                }}>
                  <span style={{
                    fontSize: designTokens.typography.fontSize.sm,
                    color: designTokens.colors.text.secondary
                  }}>
                    👥 {rounding.players.length}명
                  </span>
                  <span style={{
                    fontSize: designTokens.typography.fontSize.sm,
                    color: designTokens.colors.text.secondary
                  }}>
                    💰 {rounding.greenFee.toLocaleString()}원
                  </span>
                </div>
                <div style={{
                  fontSize: designTokens.typography.fontSize.sm,
                  color: designTokens.colors.text.secondary
                }}>
                  스코어 없음
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      </motion.div>
    </div>
  );
};

export default HomePage;
