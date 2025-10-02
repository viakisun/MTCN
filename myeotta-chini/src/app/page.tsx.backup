'use client';

import React, { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { PhoneFrame } from '@/components/layout/PhoneFrame';
import { useAppStore } from '@/lib/store';
import { designTokens } from '@/styles/design-tokens';
import { generateRoundings, generateGroups, generateScoreRecords, currentUser, generatePlayers } from '@/lib/mock-data';
import RoundingDetailPage from '@/components/pages/RoundingDetailPage';
import LiveGamePage from '@/components/pages/LiveGamePage';
import ScoreInputPage from '@/components/pages/ScoreInputPage';

// 홈 페이지 컴포넌트
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
          }}
          whileHover={{ scale: 1.02 }}
          whileTap={{ scale: 0.98 }}
        >
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: designTokens.spacing.lg,
          }}>
            <div>
              <div style={{
                fontSize: designTokens.typography.fontSize.xl,
                fontWeight: designTokens.typography.fontWeight.bold,
                color: '#111',
                marginBottom: designTokens.spacing.xs,
              }}>
                {upcomingRounding.courseName}
              </div>
              <div style={{
                fontSize: designTokens.typography.fontSize.md,
                color: designTokens.colors.text.secondary,
              }}>
                10월 4일 (금) 14:00
              </div>
            </div>
            <div style={{
              background: '#EFF6FF',
              color: '#2563EB',
              padding: `${designTokens.spacing.xs} ${designTokens.spacing.md}`,
              borderRadius: designTokens.borderRadius.md,
              fontSize: designTokens.typography.fontSize.base,
              fontWeight: designTokens.typography.fontWeight.bold,
            }}>
              D-3
            </div>
          </div>
          
          <div style={{
            display: 'flex',
            gap: designTokens.spacing.md,
            marginBottom: designTokens.spacing.lg,
          }}>
            <div style={{
              fontSize: designTokens.typography.fontSize.base,
              color: designTokens.colors.text.secondary,
              background: '#F3F4F6',
              padding: `${designTokens.spacing.sm} 10px`,
              borderRadius: designTokens.spacing.sm,
            }}>
              ⛳ 18홀
            </div>
            <div style={{
              fontSize: designTokens.typography.fontSize.base,
              color: designTokens.colors.text.secondary,
              background: '#F3F4F6',
              padding: `${designTokens.spacing.sm} 10px`,
              borderRadius: designTokens.spacing.sm,
            }}>
              👥 4명
            </div>
            <div style={{
              fontSize: designTokens.typography.fontSize.base,
              color: designTokens.colors.text.secondary,
              background: '#F3F4F6',
              padding: `${designTokens.spacing.sm} 10px`,
              borderRadius: designTokens.spacing.sm,
            }}>
              ☀️ 맑음 22°C
            </div>
          </div>
          
          <motion.button
            className="button-tap"
            style={{
              width: '100%',
              height: '44px',
              padding: 0,
              background: 'white',
              border: `1px solid ${designTokens.colors.border.light}`,
              borderRadius: designTokens.borderRadius.md,
              fontSize: designTokens.typography.fontSize.lg,
              fontWeight: designTokens.typography.fontWeight.medium,
              color: '#111',
              cursor: 'pointer',
              fontFamily: 'inherit',
            }}
            whileHover={{ backgroundColor: '#F9FAFB' }}
            whileTap={{ scale: 0.95 }}
          >
            상세보기
          </motion.button>
          
          {/* 입장 가능 시간 안내 */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 1 }}
            style={{
              background: 'linear-gradient(135deg, #FEF3C7, #FDE68A)',
              border: '1px solid #F59E0B',
              borderRadius: designTokens.borderRadius.md,
              padding: '10px 12px',
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.md,
              marginTop: designTokens.spacing.lg,
            }}
          >
            <span style={{ fontSize: designTokens.typography.fontSize.xl, flexShrink: 0 }}>
              ⏰
            </span>
            <span style={{
              fontSize: designTokens.typography.fontSize.base,
              color: '#92400E',
              lineHeight: designTokens.typography.lineHeight.normal,
              fontWeight: designTokens.typography.fontWeight.medium,
            }}>
              경기장 입장은 경기 당일 오전 8시부터 가능해요
            </span>
          </motion.div>
        </motion.div>
      </motion.div>
      
      {/* 나의 스코어 요약 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing['3xl'] }}
      >
        <div style={{ marginBottom: designTokens.spacing.lg }}>
          <h2 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.medium,
            color: designTokens.colors.text.primary,
          }}>
            나의 스코어 요약
          </h2>
        </div>
        
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(3, 1fr)',
          gap: designTokens.spacing.lg,
        }}>
          {[
            { label: '평균 스코어', value: currentUser.averageScore, color: '#2563EB' },
            { label: '베스트', value: currentUser.bestScore, color: '#2563EB' },
            { label: '이번달', value: '3회', color: '#111' },
          ].map((item, index) => (
            <motion.div
              key={index}
              className="card-hover"
              style={{
                textAlign: 'center',
                padding: `${designTokens.spacing.md} 10px`,
                cursor: 'pointer',
                background: 'white',
                border: `1px solid ${designTokens.colors.border.light}`,
                borderRadius: designTokens.borderRadius.lg,
              }}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <div style={{
                fontSize: designTokens.typography.fontSize.sm,
                color: designTokens.colors.text.secondary,
                marginBottom: designTokens.spacing.sm,
              }}>
                {item.label}
              </div>
              <div style={{
                fontSize: designTokens.typography.fontSize['3xl'],
                fontWeight: designTokens.typography.fontWeight.bold,
                color: item.color,
                lineHeight: 1,
              }}>
                {item.value}
              </div>
            </motion.div>
          ))}
        </div>
      </motion.div>
      
      {/* 동문회 활동 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.6, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing['3xl'] }}
      >
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          marginBottom: designTokens.spacing.lg,
        }}>
          <h2 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.medium,
            color: designTokens.colors.text.primary,
          }}>
            동문회 활동
          </h2>
          <motion.button
            className="button-tap"
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.xs,
              fontSize: designTokens.typography.fontSize.md,
              color: '#2563EB',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              fontWeight: designTokens.typography.fontWeight.medium,
              fontFamily: 'inherit',
              padding: designTokens.spacing.xs,
            }}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <span>더보기</span>
            <span style={{ fontSize: designTokens.typography.fontSize.xl }}>▶</span>
          </motion.button>
        </div>
        
        {/* 활동 카드들 */}
        {[
          {
            avatar: '박',
            name: '박영호님이 베스트 스코어 달성! 🎉',
            detail: '78타 · 레이크사이드 CC · 2시간 전',
            likes: 12,
            comments: 5,
            gradient: 'linear-gradient(135deg, #16A34A, #15803D)',
          },
          {
            avatar: '⛳',
            name: '신규 라운딩 2건 등록됨',
            detail: '연세대 골프동문회 · 30분 전',
            likes: 8,
            comments: 3,
            gradient: 'linear-gradient(135deg, #2563EB, #1D4ED8)',
          },
        ].map((activity, index) => (
          <motion.div
            key={index}
            className="card-hover"
            style={{
              background: 'white',
              border: `1px solid ${designTokens.colors.border.light}`,
              borderRadius: designTokens.borderRadius.lg,
              padding: designTokens.spacing.lg,
              marginBottom: designTokens.spacing.md,
            }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <div style={{
              display: 'flex',
              alignItems: 'flex-start',
              gap: designTokens.spacing.lg,
            }}>
              <div style={{
                width: '40px',
                height: '40px',
                borderRadius: designTokens.borderRadius.full,
                background: activity.gradient,
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontWeight: designTokens.typography.fontWeight.bold,
                fontSize: activity.avatar === '⛳' ? designTokens.typography.fontSize['3xl'] : designTokens.typography.fontSize.xl,
                flexShrink: 0,
              }}>
                {activity.avatar}
              </div>
              <div style={{ flex: 1, minWidth: 0 }}>
                <div style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'flex-start',
                  gap: designTokens.spacing.md,
                  marginBottom: designTokens.spacing.xs,
                }}>
                  <div style={{
                    fontSize: designTokens.typography.fontSize.lg,
                    fontWeight: designTokens.typography.fontWeight.medium,
                    color: '#111',
                    lineHeight: designTokens.typography.lineHeight.normal,
                  }}>
                    {activity.name}
                  </div>
                </div>
                <div style={{
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center',
                  gap: designTokens.spacing.lg,
                }}>
                  <div style={{
                    fontSize: designTokens.typography.fontSize.base,
                    color: designTokens.colors.text.secondary,
                    lineHeight: designTokens.typography.lineHeight.normal,
                  }}>
                    {activity.detail}
        </div>
                  <div style={{
                    display: 'flex',
                    gap: designTokens.spacing.lg,
                    flexShrink: 0,
                  }}>
                    <motion.button
                      className="button-tap"
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: '3px',
                        background: 'none',
                        border: 'none',
                        color: designTokens.colors.text.secondary,
                        fontSize: designTokens.typography.fontSize.base,
                        cursor: 'pointer',
                        fontFamily: 'inherit',
                        padding: 0,
                        transition: 'all 0.2s',
                      }}
                      whileHover={{ color: '#2563EB' }}
                      whileTap={{ scale: 0.95 }}
                    >
                      <span>👍</span>
                      <span>{activity.likes}</span>
                    </motion.button>
                    <motion.button
                      className="button-tap"
                      style={{
                        display: 'flex',
                        alignItems: 'center',
                        gap: '3px',
                        background: 'none',
                        border: 'none',
                        color: designTokens.colors.text.secondary,
                        fontSize: designTokens.typography.fontSize.base,
                        cursor: 'pointer',
                        fontFamily: 'inherit',
                        padding: 0,
                        transition: 'all 0.2s',
                      }}
                      whileHover={{ color: '#2563EB' }}
                      whileTap={{ scale: 0.95 }}
                    >
                      <span>💬</span>
                      <span>{activity.comments}</span>
                    </motion.button>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>
        ))}
      </motion.div>
    </div>
  );
};

// 라운딩 페이지 컴포넌트 - HTML과 정확히 동일하게 구현
const RoundingPage: React.FC<{ 
  currentPage: 'rounding' | 'detail' | 'live' | 'score';
  setCurrentPage: (page: 'rounding' | 'detail' | 'live' | 'score') => void;
}> = ({ currentPage, setCurrentPage }) => {
  const { setActiveTab, spectatorMode, setSpectatorMode } = useAppStore();

  if (currentPage === 'detail') {
    return (
      <RoundingDetailPage 
        onBack={() => setCurrentPage('rounding')}
        onEnterStadium={() => setCurrentPage('live')}
      />
    );
  }

  if (currentPage === 'live') {
    return (
      <LiveGamePage 
        onBack={() => setCurrentPage('detail')}
        onScoreInput={() => setCurrentPage('score')}
      />
    );
  }

  if (currentPage === 'score') {
    return (
      <ScoreInputPage 
        onBack={() => setCurrentPage('live')}
      />
    );
  }

  return (
    <div className="flex-1 relative overflow-y-auto scroll-container" style={{ background: '#F5F7FA' }}>
      {/* 라운딩 페이지 헤더 */}
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: '16px 24px 12px',
        background: 'transparent'
      }}>
        <motion.button
          onClick={() => setActiveTab('home')}
          style={{
            background: 'none',
            border: 'none',
            fontSize: '20px',
            cursor: 'pointer',
            padding: '8px',
            borderRadius: '8px'
          }}
          whileHover={{ backgroundColor: '#F3F4F6' }}
          whileTap={{ scale: 0.95 }}
        >
          ←
        </motion.button>
        <div style={{
          fontSize: '18px',
          fontWeight: '700',
          color: '#111'
        }}>
          라운딩
        </div>
        <motion.button
          onClick={() => setSpectatorMode(!spectatorMode)}
          style={{
            background: spectatorMode ? '#2563EB' : '#F3F4F6',
            color: spectatorMode ? 'white' : '#6B7280',
            border: 'none',
            fontSize: '12px',
            fontWeight: '600',
            cursor: 'pointer',
            padding: '6px 12px',
            borderRadius: '12px',
            fontFamily: 'inherit'
          }}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
        >
          {spectatorMode ? '👥 관중모드' : '👤 일반모드'}
        </motion.button>
      </div>
      
      <div style={{ padding: '0 24px 120px' }}>
        {/* 라운딩 페이지 내용이 여기에 구현됩니다 */}
        
        {/* 섹션 1: 내 일정 */}
        <div style={{ marginBottom: '32px' }}>
          {/* 내 일정 섹션 헤더 */}
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: '16px',
            padding: '8px 4px',
            backgroundColor: 'transparent',
            width: '100%',
            minHeight: '40px'
          }}>
            <h2 style={{
              fontSize: '18px',
              fontWeight: '700',
              color: '#1a1a1a',
              margin: 0,
              padding: 0,
              lineHeight: '1.2',
              display: 'block',
              visibility: 'visible'
            }}>
              📅 내 일정
            </h2>
            <button style={{
              fontSize: '12px',
              color: '#6B7280',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              fontWeight: '600',
              fontFamily: 'inherit',
              padding: '4px 8px',
              borderRadius: '4px',
              transition: 'background-color 0.2s'
            }}>
              전체보기 →
            </button>
          </div>
          
          {/* 라운딩 카드들이 여기에 구현됩니다 */}
          
          {/* 첫 번째 라운딩 카드 - 연세대 골프동문회 */}
          <div 
            onClick={() => setCurrentPage('detail')}
            style={{
            background: 'white',
            borderRadius: '16px',
            padding: '16px',
            marginBottom: '6px',
            boxShadow: '0 1px 12px rgba(0,0,0,0.04)',
            border: '1px solid rgba(0,0,0,0.06)',
            borderBottom: '1px solid #F3F4F6',
            transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
            cursor: 'pointer'
          }}>
            {/* 동문회 태그 */}
            <div style={{
              display: 'inline-flex',
              alignItems: 'center',
              gap: '6px',
              background: 'linear-gradient(135deg, #3B82F6, #2563EB)',
              color: 'white',
              padding: '4px 10px',
              borderRadius: '6px',
              fontSize: '11px',
              fontWeight: '700',
              marginBottom: '12px'
            }}>
              <span>🎓</span>
              <span>연세대 골프동문회</span>
            </div>
            
            {/* 라운딩 헤더 */}
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'flex-start',
              marginBottom: '12px'
            }}>
              <div>
                <div style={{
                  fontSize: '16px',
                  fontWeight: '700',
                  color: '#111',
                  marginBottom: '4px'
                }}>
                  레이크사이드 골프클럽
                </div>
                <div style={{
                  fontSize: '13px',
                  color: '#6B7280',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '4px'
                }}>
                  📅 1월 25일 (토) 14:00
                </div>
              </div>
              <div style={{
                background: '#3B82F6',
                color: 'white',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                오늘
              </div>
            </div>
            
            {/* 라운딩 정보 */}
            <div style={{
              display: 'flex',
              gap: '8px',
              marginBottom: '16px',
              flexWrap: 'wrap'
            }}>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                ⛳ 18홀
              </div>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                ☀️ 맑음 22°C
              </div>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                💰 120,000원
              </div>
            </div>
            
            {/* 참가자 정보 */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px'
            }}>
              <div style={{ display: 'flex', gap: '-4px' }}>
                <div style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '50%',
                  background: 'linear-gradient(135deg, #2E5A87, #4A7BA7)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: 'white',
                  fontWeight: 'bold',
                  fontSize: '12px',
                  border: '2px solid white',
                  marginLeft: '-4px'
                }}>김</div>
                <div style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '50%',
                  background: 'linear-gradient(135deg, #28a745, #20c997)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: 'white',
                  fontWeight: 'bold',
                  fontSize: '12px',
                  border: '2px solid white',
                  marginLeft: '-4px'
                }}>박</div>
                <div style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '50%',
                  background: 'linear-gradient(135deg, #fd7e14, #e85d04)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: 'white',
                  fontWeight: 'bold',
                  fontSize: '12px',
                  border: '2px solid white',
                  marginLeft: '-4px'
                }}>이</div>
                <div style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '50%',
                  background: 'linear-gradient(135deg, #6f42c1, #e83e8c)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: 'white',
                  fontWeight: 'bold',
                  fontSize: '12px',
                  border: '2px solid white',
                  marginLeft: '-4px'
                }}>최</div>
              </div>
              <span style={{
                fontSize: '12px',
                color: '#6B7280',
                fontWeight: '600'
              }}>
                4명 참가
              </span>
            </div>
          </div>
          
          {/* 두 번째 라운딩 카드 - 개인 라운딩 */}
          <div 
            onClick={() => setCurrentPage('detail')}
            style={{
            background: 'white',
            borderRadius: '16px',
            padding: '16px',
            marginBottom: '6px',
            boxShadow: '0 1px 12px rgba(0,0,0,0.04)',
            border: '1px solid rgba(0,0,0,0.06)',
            borderBottom: '1px solid #F3F4F6',
            transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
            cursor: 'pointer'
          }}>
            {/* 개인 라운딩 태그 */}
            <div style={{
              display: 'inline-flex',
              alignItems: 'center',
              gap: '6px',
              background: '#9CA3AF',
              color: 'white',
              padding: '4px 10px',
              borderRadius: '6px',
              fontSize: '11px',
              fontWeight: '700',
              marginBottom: '12px'
            }}>
              <span>👤</span>
              <span>개인 라운딩</span>
            </div>
            
            {/* 라운딩 헤더 */}
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'flex-start',
              marginBottom: '12px'
            }}>
              <div>
                <div style={{
                  fontSize: '16px',
                  fontWeight: '700',
                  color: '#111',
                  marginBottom: '4px'
                }}>
                  스카이힐 컨트리클럽
                </div>
                <div style={{
                  fontSize: '13px',
                  color: '#6B7280',
                  display: 'flex',
                  alignItems: 'center',
                  gap: '4px'
                }}>
                  📅 2월 3일 (일) 09:00
                </div>
              </div>
              <div style={{
                background: '#3B82F6',
                color: 'white',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                D-12
              </div>
            </div>
            
            {/* 라운딩 정보 */}
            <div style={{
              display: 'flex',
              gap: '8px',
              marginBottom: '16px',
              flexWrap: 'wrap'
            }}>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                ⛳ 18홀
              </div>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                🌤️ 구름 15°C
              </div>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                💰 140,000원
              </div>
            </div>
            
            {/* 참가자 정보 */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '8px'
            }}>
              <div style={{ display: 'flex', gap: '-4px' }}>
                <div style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '50%',
                  background: 'linear-gradient(135deg, #2E5A87, #4A7BA7)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: 'white',
                  fontWeight: 'bold',
                  fontSize: '12px',
                  border: '2px solid white',
                  marginLeft: '-4px'
                }}>김</div>
                <div style={{
                  width: '32px',
                  height: '32px',
                  borderRadius: '50%',
                  background: 'linear-gradient(135deg, #28a745, #20c997)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  color: 'white',
                  fontWeight: 'bold',
                  fontSize: '12px',
                  border: '2px solid white',
                  marginLeft: '-4px'
                }}>박</div>
              </div>
              <span style={{
                fontSize: '12px',
                color: '#6B7280',
                fontWeight: '600'
              }}>
                2명 참가 • 2명 대기
              </span>
            </div>
          </div>
        </div>
        
        {/* 라운딩 만들기 버튼 */}
        <button style={{
          width: '100%',
          height: '40px',
          background: 'white',
          border: '1.5px solid #D1D5DB',
          borderRadius: '10px',
          cursor: 'pointer',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '8px',
          fontSize: '14px',
          fontWeight: '600',
          color: '#374151',
          marginBottom: '32px',
          transition: 'all 0.2s ease'
        }}>
          <span style={{ fontSize: '16px' }}>+</span>
          <span>라운딩 만들기</span>
        </button>
        
        {/* 섹션 2: 참여 가능한 라운딩 */}
        <div style={{ marginBottom: '32px' }}>
          {/* 참여 가능한 라운딩 섹션 헤더 */}
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: '16px',
            padding: '0 4px'
          }}>
            <h2 style={{
              fontSize: '18px',
              fontWeight: '700',
              color: '#1a1a1a',
              margin: 0,
              padding: 0
            }}>
              🧭 참여 가능한 라운딩
            </h2>
            <button style={{
              fontSize: '12px',
              color: '#6B7280',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              fontWeight: '600',
              fontFamily: 'inherit',
              padding: '4px 0'
            }}>
              더보기 →
            </button>
          </div>
          
          {/* 초대받은 라운딩 카드가 여기에 구현됩니다 */}
          
          {/* 초대받은 라운딩 카드 - 파인밸리 골프클럽 */}
          <div 
            onClick={() => setCurrentPage('detail')}
            style={{
            background: 'white',
            borderRadius: '16px',
            padding: '16px',
            marginBottom: '6px',
            boxShadow: '0 1px 12px rgba(0,0,0,0.04)',
            border: '2px solid #2E5A87',
            borderBottom: '1px solid #F3F4F6',
            transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
            cursor: 'pointer'
          }}>
            {/* 초대받음 태그들 */}
            <div style={{
              display: 'flex',
              gap: '8px',
              marginBottom: '12px',
              flexWrap: 'wrap'
            }}>
              <div style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                background: '#2E5A87',
                color: 'white',
                padding: '4px 10px',
                borderRadius: '6px',
                fontSize: '11px',
                fontWeight: '700'
              }}>
                <span>💌</span>
                <span>초대받음</span>
              </div>
              <div style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '6px',
                background: 'linear-gradient(135deg, #fd7e14, #e85d04)',
                color: 'white',
                padding: '4px 10px',
                borderRadius: '6px',
                fontSize: '11px',
                fontWeight: '700'
              }}>
                <span>🦁</span>
                <span>라이온스 골프모임</span>
              </div>
            </div>
            
            {/* 라운딩 헤더 */}
            <div style={{
              marginBottom: '12px'
            }}>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#111',
                marginBottom: '4px'
              }}>
                파인밸리 골프클럽
              </div>
              <div style={{
                fontSize: '13px',
                color: '#6B7280',
                display: 'flex',
                alignItems: 'center',
                gap: '4px'
              }}>
                📅 2월 8일 (토) 10:30
              </div>
            </div>
            
            {/* 라운딩 정보 */}
            <div style={{
              display: 'flex',
              gap: '8px',
              marginBottom: '16px',
              flexWrap: 'wrap'
            }}>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                ⛳ 18홀
              </div>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                ☀️ 맑음 20°C
              </div>
              <div style={{
                background: '#F3F4F6',
                color: '#374151',
                padding: '4px 8px',
                borderRadius: '12px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                💰 135,000원
              </div>
            </div>
            
            {/* 초대자 정보 */}
            <div style={{
              marginBottom: '16px'
            }}>
              <div style={{
                fontSize: '12px',
                color: '#666',
                marginBottom: '8px'
              }}>
                <strong>박영희</strong>님이 초대했습니다
              </div>
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px'
              }}>
                <div style={{ display: 'flex', gap: '-4px' }}>
                  <div style={{
                    width: '32px',
                    height: '32px',
                    borderRadius: '50%',
                    background: 'linear-gradient(135deg, #28a745, #20c997)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: 'white',
                    fontWeight: 'bold',
                    fontSize: '12px',
                    border: '2px solid white',
                    marginLeft: '-4px'
                  }}>박</div>
                  <div style={{
                    width: '32px',
                    height: '32px',
                    borderRadius: '50%',
                    background: 'linear-gradient(135deg, #fd7e14, #e85d04)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: 'white',
                    fontWeight: 'bold',
                    fontSize: '12px',
                    border: '2px solid white',
                    marginLeft: '-4px'
                  }}>이</div>
                  <div style={{
                    width: '32px',
                    height: '32px',
                    borderRadius: '50%',
                    background: 'linear-gradient(135deg, #6f42c1, #e83e8c)',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    color: 'white',
                    fontWeight: 'bold',
                    fontSize: '12px',
                    border: '2px solid white',
                    marginLeft: '-4px'
                  }}>최</div>
                </div>
                <span style={{
                  fontSize: '12px',
                  color: '#6B7280',
                  fontWeight: '600'
                }}>
                  3명 확정 • 1자리 남음
                </span>
              </div>
            </div>
            
            {/* 액션 버튼들 */}
            <div style={{
              display: 'grid',
              gridTemplateColumns: '1fr 1fr',
              gap: '8px'
            }}>
              <button style={{
                background: 'white',
                border: '1px solid #E5E7EB',
                borderRadius: '12px',
                padding: '12px',
                fontSize: '14px',
                fontWeight: '600',
                color: '#374151',
                cursor: 'pointer',
                transition: 'all 0.2s ease'
              }}>
                거절
              </button>
              <button style={{
                background: '#2563EB',
                border: 'none',
                borderRadius: '12px',
                padding: '12px',
                fontSize: '14px',
                fontWeight: '600',
                color: 'white',
                cursor: 'pointer',
                transition: 'all 0.2s ease'
              }}>
                참가하기
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};
// 동문회 페이지 컴포넌트 - HTML과 정확히 동일하게 구현
const GroupsPage: React.FC = () => {
  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ padding: '16px 24px 120px', background: '#F5F7FA' }}
    >
      {/* 내가 가입한 동문회 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '16px',
        marginBottom: '16px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
      }}>
        <h3 style={{
          fontSize: '16px',
          fontWeight: '700',
          color: '#111',
          marginBottom: '12px'
        }}>
          내가 가입한 동문회
        </h3>
        
        {/* 서울대 경영대 골프회 */}
        <motion.div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            padding: '16px',
            border: '1px solid #e5e7eb',
            borderRadius: '12px',
            marginBottom: '12px',
            background: '#fafafa',
            cursor: 'pointer'
          }}
          whileHover={{ backgroundColor: '#f0f0f0' }}
          whileTap={{ scale: 0.98 }}
        >
          <div style={{
            width: '50px',
            height: '50px',
            borderRadius: '12px',
            background: '#2E5A87',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '18px',
            flexShrink: 0
          }}>
            🎓
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              fontSize: '16px',
              fontWeight: '700',
              color: '#1a1a1a',
              marginBottom: '4px',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap'
            }}>
              서울대 경영대 골프회
            </div>
            <div style={{
              fontSize: '13px',
              color: '#666',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
              marginBottom: '2px'
            }}>
              347명 • 활성 그룹
            </div>
            <div style={{
              fontSize: '12px',
              color: '#999'
            }}>
              새로운 소식 3개
            </div>
        </div>
          <div style={{ color: '#2E5A87', fontSize: '18px' }}>›</div>
        </motion.div>

        {/* 강남 직장인 골프 모임 */}
        <motion.div
          style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            padding: '16px',
            border: '1px solid #e5e7eb',
            borderRadius: '12px',
            background: '#fafafa',
            cursor: 'pointer'
          }}
          whileHover={{ backgroundColor: '#f0f0f0' }}
          whileTap={{ scale: 0.98 }}
        >
          <div style={{
            width: '50px',
            height: '50px',
            borderRadius: '12px',
            background: '#6c757d',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '18px',
            flexShrink: 0
          }}>
            🏢
          </div>
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              fontSize: '16px',
              fontWeight: '700',
              color: '#1a1a1a',
              marginBottom: '4px',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap'
            }}>
              강남 직장인 골프 모임
            </div>
            <div style={{
              fontSize: '13px',
              color: '#666',
              overflow: 'hidden',
              textOverflow: 'ellipsis',
              whiteSpace: 'nowrap',
              marginBottom: '2px'
            }}>
              124명 • 지역 그룹
            </div>
            <div style={{
              fontSize: '12px',
              color: '#999'
            }}>
              새로운 소식 1개
            </div>
          </div>
          <div style={{ color: '#2E5A87', fontSize: '18px' }}>›</div>
        </motion.div>
      </div>

      {/* 동문회 찾아보기 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '16px',
        marginBottom: '16px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
      }}>
        <h3 style={{
          marginBottom: '16px',
          fontSize: '16px',
          fontWeight: '700',
          color: '#111'
        }}>
          동문회 찾아보기
        </h3>
        
        {/* 검색창 */}
        <div style={{
          display: 'flex',
          gap: '8px',
          marginBottom: '16px'
        }}>
          <input
            type="text"
            placeholder="동문회명 또는 키워드 검색"
            style={{
              flex: 1,
              padding: '12px',
              border: '1px solid #e5e7eb',
              borderRadius: '8px',
              fontSize: '14px',
              fontFamily: 'inherit'
            }}
          />
          <motion.button
            style={{
              background: '#2E5A87',
              color: 'white',
              border: 'none',
              padding: '12px 16px',
              borderRadius: '8px',
              fontSize: '13px',
              fontWeight: '600',
              cursor: 'pointer',
              fontFamily: 'inherit'
            }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            검색
          </motion.button>
        </div>
        
        {/* 카테고리 필터 */}
        <div style={{
          display: 'flex',
          gap: '8px',
          flexWrap: 'wrap'
        }}>
          {['학교별', '직장인', '지역별', '초보자'].map((category) => (
            <motion.button
              key={category}
              style={{
                background: '#f8f9fa',
                border: '1px solid #e5e7eb',
                padding: '8px 12px',
                borderRadius: '6px',
                fontSize: '12px',
                color: '#666',
                cursor: 'pointer',
                fontFamily: 'inherit'
              }}
              whileHover={{ backgroundColor: '#e9ecef' }}
              whileTap={{ scale: 0.95 }}
            >
              #{category}
            </motion.button>
          ))}
        </div>
      </div>

      {/* 새 동문회 만들기 버튼 */}
      <motion.div
        style={{
          background: 'white',
          border: '2px solid #2E5A87',
          borderRadius: '16px',
          padding: '12px',
          cursor: 'pointer',
          marginTop: '-4px'
        }}
        whileHover={{ backgroundColor: '#f8f9fa', y: -1 }}
        whileTap={{ scale: 0.98 }}
      >
        <div style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: '10px'
        }}>
          <div style={{
            fontSize: '18px',
            color: '#2E5A87'
          }}>
            ➕
          </div>
          <div style={{
            fontSize: '16px',
            fontWeight: '600',
            color: '#2E5A87'
          }}>
            새 동문회 만들기
          </div>
        </div>
      </motion.div>
    </div>
  );
};

// 스코어 페이지 컴포넌트 - HTML과 정확히 동일하게 구현
const ScorePage: React.FC = () => {
  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ padding: '16px 24px 120px', background: '#F5F7FA' }}
    >
      {/* 기간 필터 */}
      <div style={{
        display: 'flex',
        gap: '8px',
        marginBottom: '20px',
        overflowX: 'auto'
      }}>
        {['전체', '이번 달', '최근 3개월', '올해'].map((filter, index) => (
          <motion.button
            key={filter}
            style={{
              background: index === 0 ? '#2563EB' : '#F3F4F6',
              color: index === 0 ? 'white' : '#6B7280',
              border: 'none',
              padding: '8px 16px',
              borderRadius: '20px',
              fontSize: '13px',
              fontWeight: '600',
              cursor: 'pointer',
              fontFamily: 'inherit',
              whiteSpace: 'nowrap'
            }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            {filter}
          </motion.button>
        ))}
      </div>
      
      {/* 스코어 통계 요약 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '20px',
        marginBottom: '24px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
      }}>
        <div style={{
          fontSize: '14px',
          fontWeight: '600',
          color: '#6B7280',
          marginBottom: '16px'
        }}>
          📈 나의 스코어 통계
        </div>
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(3, 1fr)',
          gap: '16px'
        }}>
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontSize: '11px',
              color: '#6B7280',
              marginBottom: '4px'
            }}>
              평균 스코어
            </div>
            <div style={{
              fontSize: '20px',
              fontWeight: '700',
              color: '#2563EB'
            }}>
              92
            </div>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontSize: '11px',
              color: '#6B7280',
              marginBottom: '4px'
            }}>
              베스트 스코어
            </div>
            <div style={{
              fontSize: '20px',
              fontWeight: '700',
              color: '#16A34A'
            }}>
              85
            </div>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontSize: '11px',
              color: '#6B7280',
              marginBottom: '4px'
            }}>
              라운딩 횟수
            </div>
            <div style={{
              fontSize: '20px',
              fontWeight: '700',
              color: '#111'
            }}>
              24
            </div>
          </div>
        </div>
      </div>
      
      {/* AI 맞춤 분석 */}
      <div style={{ marginBottom: '24px' }}>
        <div style={{
          fontSize: '14px',
          fontWeight: '600',
          color: '#111',
          marginBottom: '12px'
        }}>
          🤖 AI 맞춤 분석
        </div>
        
        <div style={{
          background: 'white',
          borderRadius: '16px',
          padding: '16px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '10px',
            marginBottom: '12px'
          }}>
            <div style={{
              width: '36px',
              height: '36px',
              background: 'linear-gradient(135deg, #2563EB, #1E40AF)',
              borderRadius: '10px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '18px',
              flexShrink: 0
            }}>
              🎯
            </div>
            <div>
              <div style={{
                fontSize: '14px',
                fontWeight: '700',
                color: '#111',
                marginBottom: '2px'
              }}>
                개선 포인트 발견!
              </div>
              <div style={{
                fontSize: '12px',
                color: '#6B7280'
              }}>
                드라이버 정확도 향상 필요
              </div>
            </div>
          </div>
          
          <div style={{
            background: '#F9FAFB',
            padding: '10px 12px',
            borderRadius: '8px',
            marginBottom: '10px'
          }}>
            <div style={{
              fontSize: '11px',
              fontWeight: '600',
              color: '#6B7280',
              marginBottom: '6px'
            }}>
              📊 이번 달 개선 현황
            </div>
            <div style={{
              fontSize: '11px',
              color: '#111',
              lineHeight: 1.6
            }}>
              • 평균 스코어: <strong style={{ color: '#16A34A' }}>89타</strong> (전월 대비 -2타 향상)<br/>
              • 다음 목표: <strong style={{ color: '#2563EB' }}>85타</strong> 달성 (4타 단축)<br/>
              • 집중 개선: 드라이버 정확도, 퍼팅, 웨지샷
            </div>
          </div>
          
          <motion.button
            style={{
              width: '100%',
              background: '#F3F4F6',
              border: 'none',
              padding: '10px',
              borderRadius: '8px',
              fontSize: '12px',
              fontWeight: '600',
              color: '#6B7280',
              cursor: 'pointer',
              fontFamily: 'inherit',
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center'
            }}
            whileHover={{ backgroundColor: '#E5E7EB' }}
            whileTap={{ scale: 0.98 }}
          >
            <span>상세 분석 보기</span>
            <span>▼</span>
          </motion.button>
        </div>
      </div>
      
      {/* 최근 라운딩 */}
      <div>
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          marginBottom: '16px'
        }}>
          <h2 style={{
            fontSize: '18px',
            fontWeight: '700',
            color: '#1a1a1a'
          }}>
            🌏 최근 라운딩
          </h2>
          <motion.button
            style={{
              fontSize: '13px',
              color: '#2563EB',
              background: 'none',
              border: 'none',
              cursor: 'pointer',
              fontWeight: '600',
              fontFamily: 'inherit'
            }}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            전체보기 →
          </motion.button>
        </div>
        
        {/* 스코어 카드 1 */}
        <motion.div
          style={{
            background: 'white',
            borderRadius: '16px',
            padding: '16px',
            marginBottom: '12px',
            boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
          }}
          whileHover={{ scale: 1.01 }}
          whileTap={{ scale: 0.99 }}
        >
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: '12px'
          }}>
            <div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#111',
                marginBottom: '4px'
              }}>
                레이크사이드 골프클럽
              </div>
              <div style={{
                fontSize: '13px',
                color: '#6B7280'
              }}>
                2025년 1월 25일 (토)
              </div>
            </div>
            <div style={{
              background: '#EFF6FF',
              color: '#2563EB',
              padding: '6px 12px',
              borderRadius: '12px',
              fontSize: '14px',
              fontWeight: '700'
            }}>
              E
            </div>
          </div>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(4, 1fr)',
            gap: '12px'
          }}>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                총 타수
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700'
              }}>
                72
              </div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                파
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#2563EB'
              }}>
                14
              </div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                버디
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#16A34A'
              }}>
                3
              </div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                보기
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#F59E0B'
              }}>
                1
              </div>
            </div>
          </div>
        </motion.div>
        
        {/* 스코어 카드 2 */}
        <motion.div
          style={{
            background: 'white',
            borderRadius: '16px',
            padding: '16px',
            marginBottom: '12px',
            boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
          }}
          whileHover={{ scale: 1.01 }}
          whileTap={{ scale: 0.99 }}
        >
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: '12px'
          }}>
            <div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#111',
                marginBottom: '4px'
              }}>
                스카이힐 컨트리클럽
              </div>
              <div style={{
                fontSize: '13px',
                color: '#6B7280'
              }}>
                2025년 1월 18일 (토)
              </div>
            </div>
            <div style={{
              background: '#FEF3C7',
              color: '#92400E',
              padding: '6px 12px',
              borderRadius: '12px',
              fontSize: '14px',
              fontWeight: '700'
            }}>
              +3
            </div>
          </div>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(4, 1fr)',
            gap: '12px'
          }}>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                총 타수
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700'
              }}>
                87
              </div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                파
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#2563EB'
              }}>
                10
              </div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                버디
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#16A34A'
              }}>
                1
              </div>
            </div>
            <div style={{ textAlign: 'center' }}>
              <div style={{
                fontSize: '11px',
                color: '#6B7280',
                marginBottom: '4px'
              }}>
                보기
              </div>
              <div style={{
                fontSize: '16px',
                fontWeight: '700',
                color: '#F59E0B'
              }}>
                7
              </div>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

// 프로필 페이지 컴포넌트
const ProfilePage: React.FC = () => {
  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ padding: '16px 24px 120px', background: '#F5F7FA' }}
    >
      {/* 프로필 헤더 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '24px',
        marginBottom: '20px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
        textAlign: 'center'
      }}>
        <div style={{
          width: '80px',
          height: '80px',
          borderRadius: '50%',
          background: 'linear-gradient(135deg, #2563EB, #1E40AF)',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '32px',
          fontWeight: 'bold',
          color: 'white',
          margin: '0 auto 16px'
        }}>
          김
        </div>
        <h2 style={{
          fontSize: '20px',
          fontWeight: '700',
          color: '#111',
          marginBottom: '8px'
        }}>
          김프로
        </h2>
        <p style={{
          fontSize: '14px',
          color: '#6B7280',
          marginBottom: '16px'
        }}>
          골프 핸디캡 12 • 서울대 경영대
        </p>
        <div style={{
          display: 'flex',
          justifyContent: 'center',
          gap: '16px'
        }}>
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontSize: '18px',
              fontWeight: '700',
              color: '#2563EB'
            }}>
              24
            </div>
            <div style={{
              fontSize: '12px',
              color: '#6B7280'
            }}>
              라운딩
            </div>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontSize: '18px',
              fontWeight: '700',
              color: '#16A34A'
            }}>
              85
            </div>
            <div style={{
              fontSize: '12px',
              color: '#6B7280'
            }}>
              베스트
            </div>
          </div>
          <div style={{ textAlign: 'center' }}>
            <div style={{
              fontSize: '18px',
              fontWeight: '700',
              color: '#111'
            }}>
              92
            </div>
            <div style={{
              fontSize: '12px',
              color: '#6B7280'
            }}>
              평균
            </div>
          </div>
        </div>
      </div>

      {/* 설정 메뉴 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        marginBottom: '20px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
        overflow: 'hidden'
      }}>
        <div style={{
          fontSize: '16px',
          fontWeight: '700',
          color: '#111',
          padding: '16px 20px',
          borderBottom: '1px solid #F3F4F6'
        }}>
          설정
        </div>
        
        {[
          { icon: '👤', title: '개인정보 수정', subtitle: '이름, 핸디캡, 프로필 사진' },
          { icon: '🔔', title: '알림 설정', subtitle: '라운딩 알림, 채팅 알림' },
          { icon: '🔒', title: '개인정보 보호', subtitle: '프라이버시 설정' },
          { icon: '🎯', title: '골프 목표', subtitle: '목표 스코어, 연습 계획' },
        ].map((item, index) => (
          <motion.div
            key={index}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '16px',
              padding: '16px 20px',
              borderBottom: index < 3 ? '1px solid #F3F4F6' : 'none',
              cursor: 'pointer'
            }}
            whileHover={{ backgroundColor: '#F9FAFB' }}
            whileTap={{ scale: 0.98 }}
          >
            <div style={{
              fontSize: '20px',
              width: '24px',
              textAlign: 'center'
            }}>
              {item.icon}
            </div>
            <div style={{ flex: 1 }}>
              <div style={{
                fontSize: '16px',
                fontWeight: '600',
                color: '#111',
                marginBottom: '2px'
              }}>
                {item.title}
              </div>
              <div style={{
                fontSize: '13px',
                color: '#6B7280'
              }}>
                {item.subtitle}
              </div>
            </div>
            <div style={{
              color: '#9CA3AF',
              fontSize: '16px'
            }}>
              ›
            </div>
          </motion.div>
        ))}
      </div>

      {/* 골프 통계 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '20px',
        marginBottom: '20px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
      }}>
        <h3 style={{
          fontSize: '16px',
          fontWeight: '700',
          color: '#111',
          marginBottom: '16px'
        }}>
          📊 골프 통계
        </h3>
        
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(2, 1fr)',
          gap: '16px'
        }}>
          <div style={{
            background: '#F0F9FF',
            borderRadius: '12px',
            padding: '16px',
            textAlign: 'center'
          }}>
            <div style={{
              fontSize: '24px',
              fontWeight: '700',
              color: '#2563EB',
              marginBottom: '4px'
            }}>
              12
            </div>
            <div style={{
              fontSize: '12px',
              color: '#6B7280'
            }}>
              핸디캡
            </div>
          </div>
          
          <div style={{
            background: '#F0FDF4',
            borderRadius: '12px',
            padding: '16px',
            textAlign: 'center'
          }}>
            <div style={{
              fontSize: '24px',
              fontWeight: '700',
              color: '#16A34A',
              marginBottom: '4px'
            }}>
              3
            </div>
            <div style={{
              fontSize: '12px',
              color: '#6B7280'
            }}>
              이번달 라운딩
            </div>
          </div>
          
          <div style={{
            background: '#FEF3C7',
            borderRadius: '12px',
            padding: '16px',
            textAlign: 'center'
          }}>
            <div style={{
              fontSize: '24px',
              fontWeight: '700',
              color: '#D97706',
              marginBottom: '4px'
            }}>
              7
            </div>
            <div style={{
              fontSize: '12px',
              color: '#6B7280'
            }}>
              연속 라운딩
            </div>
          </div>
          
          <div style={{
            background: '#F3E8FF',
            borderRadius: '12px',
            padding: '16px',
            textAlign: 'center'
          }}>
            <div style={{
              fontSize: '24px',
              fontWeight: '700',
              color: '#7C3AED',
              marginBottom: '4px'
            }}>
              2
            </div>
            <div style={{
              fontSize: '12px',
              color: '#6B7280'
            }}>
              가입 동문회
            </div>
          </div>
        </div>
      </div>

      {/* 앱 정보 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '20px',
        marginBottom: '20px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
      }}>
        <h3 style={{
          fontSize: '16px',
          fontWeight: '700',
          color: '#111',
          marginBottom: '16px'
        }}>
          ℹ️ 앱 정보
        </h3>
        
        {[
          { title: '버전', value: '1.0.0' },
          { title: '개발사', value: '몇타치니' },
          { title: '문의하기', value: 'support@myeotta.com' },
        ].map((item, index) => (
          <div
            key={index}
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              padding: '12px 0',
              borderBottom: index < 2 ? '1px solid #F3F4F6' : 'none'
            }}
          >
            <div style={{
              fontSize: '14px',
              color: '#6B7280'
            }}>
              {item.title}
            </div>
            <div style={{
              fontSize: '14px',
              fontWeight: '600',
              color: '#111'
            }}>
              {item.value}
            </div>
          </div>
        ))}
      </div>

      {/* 로그아웃 버튼 */}
      <motion.button
        style={{
          width: '100%',
          background: '#FEF2F2',
          border: '1px solid #FECACA',
          borderRadius: '16px',
          padding: '16px',
          fontSize: '16px',
          fontWeight: '600',
          color: '#DC2626',
          cursor: 'pointer',
          fontFamily: 'inherit',
          marginBottom: '20px'
        }}
        whileHover={{ backgroundColor: '#FEE2E2' }}
        whileTap={{ scale: 0.98 }}
      >
        로그아웃
      </motion.button>
    </div>
  );
};

// 메인 앱 컴포넌트
export default function App() {
  const { 
    activeTab, 
    setActiveTab,
    isDemoMode,
    demoStep,
    setDemoStep
  } = useAppStore();
  
  const [currentPage, setCurrentPage] = useState<'rounding' | 'detail' | 'live' | 'score'>('rounding');

  // 데모 자동 진행
  useEffect(() => {
    if (!isDemoMode) return;

    const demoSequence = [
      { delay: 2000, action: () => setDemoStep(1) },
      { delay: 5000, action: () => setActiveTab('groups') },
      { delay: 8000, action: () => setDemoStep(2) },
      { delay: 12000, action: () => setActiveTab('rounding') },
      { delay: 15000, action: () => setDemoStep(3) },
    ];

    demoSequence.forEach(({ delay, action }) => {
      setTimeout(action, delay);
    });
  }, [isDemoMode, setActiveTab, setDemoStep]);

  return (
    <PhoneFrame activeTab={activeTab} onTabChange={setActiveTab}>
      <div className="flex flex-col h-full relative">
        
        <AnimatePresence mode="wait">
          {activeTab === 'home' && (
            <motion.div
              key="home"
              initial={{ opacity: 0, x: -300 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 300 }}
              transition={{ duration: 0.3 }}
              className="flex-1"
            >
              <HomePage />
            </motion.div>
          )}
          
          {activeTab === 'rounding' && (
            <motion.div
              key="rounding"
              initial={{ opacity: 0, x: 300 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -300 }}
              transition={{ duration: 0.3 }}
              className="flex-1 flex flex-col"
            >
              {/* 라운딩 페이지 헤더 - 간격 조정 */}
              <RoundingPage 
                currentPage={currentPage}
                setCurrentPage={setCurrentPage}
              />
            </motion.div>
          )}
          
          {activeTab === 'groups' && (
            <motion.div
              key="groups"
              initial={{ opacity: 0, y: 300 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -300 }}
              transition={{ duration: 0.3 }}
              className="flex-1 flex flex-col"
            >
              {/* 동문회 페이지 헤더 */}
              <div style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                padding: '16px 24px 12px',
                background: 'transparent'
              }}>
                <div style={{
                  fontSize: '18px',
                  fontWeight: '700',
                  color: '#111'
                }}>
                  동문회
                </div>
              </div>
              <GroupsPage />
            </motion.div>
          )}
          
          {activeTab === 'score' && (
            <motion.div
              key="score"
              initial={{ opacity: 0, y: 300 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -300 }}
              transition={{ duration: 0.3 }}
              className="flex-1 flex flex-col"
            >
              {/* 스코어 페이지 헤더 */}
              <div style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                padding: '16px 24px 12px',
                background: 'transparent'
              }}>
                <div style={{ width: '44px' }}></div>
                <div style={{
                  fontSize: '18px',
                  fontWeight: '700',
                  color: '#111'
                }}>
                  스코어 기록
                </div>
                <motion.button
                  style={{
                    background: 'none',
                    border: 'none',
                    fontSize: '20px',
                    cursor: 'pointer',
                    padding: '8px',
                    borderRadius: '8px'
                  }}
                  whileHover={{ backgroundColor: '#F3F4F6' }}
                  whileTap={{ scale: 0.95 }}
                >
                  🔍
                </motion.button>
              </div>
              <ScorePage />
            </motion.div>
          )}
          
          {activeTab === 'profile' && (
            <motion.div
              key="profile"
              initial={{ opacity: 0, y: 300 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -300 }}
              transition={{ duration: 0.3 }}
              className="flex-1 flex flex-col"
            >
              {/* 프로필 페이지 헤더 */}
              <div style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                padding: '16px 24px 12px',
                background: 'transparent'
              }}>
                <div style={{
                  fontSize: '18px',
                  fontWeight: '700',
                  color: '#111'
                }}>
                  프로필
                </div>
              </div>
              <ProfilePage />
            </motion.div>
          )}
        </AnimatePresence>
      </div>
    </PhoneFrame>
  );
}