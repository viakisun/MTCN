'use client';

import React, { useState } from 'react';
import { motion } from 'framer-motion';

interface ScoreInputPageProps {
  onBack: () => void;
}

export const ScoreInputPage: React.FC<ScoreInputPageProps> = ({ onBack }) => {
  const [currentHole, setCurrentHole] = useState(4);
  const [currentPlayer, setCurrentPlayer] = useState(0);
  const [scores, setScores] = useState<{ [key: string]: number }>({});
  const [playerTotals, setPlayerTotals] = useState<{ [key: string]: number }>({
    '김민수': 0,
    '박영희': 2,
    '이철수': -1,
    '최지원': 1
  });

  const players = [
    { name: '김민수', initial: '김', color: 'linear-gradient(135deg, #2E5A87, #4A7BA7)' },
    { name: '박영희', initial: '박', color: 'linear-gradient(135deg, #28a745, #20c997)' },
    { name: '이철수', initial: '이', color: 'linear-gradient(135deg, #fd7e14, #e85d04)' },
    { name: '최지원', initial: '최', color: 'linear-gradient(135deg, #6f42c1, #e83e8c)' }
  ];

  const inputScore = (score: number) => {
    const key = `${currentHole}-${players[currentPlayer].name}`;
    setScores(prev => ({
      ...prev,
      [key]: score
    }));
    
    // 다음 플레이어로 이동
    if (currentPlayer < players.length - 1) {
      setCurrentPlayer(currentPlayer + 1);
    } else {
      // 모든 플레이어 입력 완료 시 다음 홀
      setCurrentPlayer(0);
      if (currentHole < 18) {
        setCurrentHole(currentHole + 1);
      }
    }
  };

  const getScoreType = (score: number) => {
    if (score <= currentHole - 2) return 'eagle';
    if (score === currentHole - 1) return 'birdie';
    if (score === currentHole) return 'par';
    if (score === currentHole + 1) return 'bogey';
    if (score === currentHole + 2) return 'double';
    return 'other';
  };

  const getScoreLabel = (score: number) => {
    const par = currentHole;
    if (score <= par - 2) return 'Eagle';
    if (score === par - 1) return 'Birdie';
    if (score === par) return 'Par';
    if (score === par + 1) return 'Bogey';
    if (score === par + 2) return 'Double';
    return '기타';
  };

  const getScoreIcon = (score: number) => {
    const par = currentHole;
    if (score <= par - 2) return '🦅';
    if (score === par - 1) return '🐦';
    if (score === par) return '⭐';
    if (score === par + 1) return '✓';
    if (score === par + 2) return '↗';
    return '⚠';
  };

  const formatTotalScore = (total: number) => {
    if (total === 0) return 'E';
    if (total > 0) return `+${total}`;
    return `${total}`;
  };

  return (
    <motion.div
      initial={{ opacity: 0, x: 300 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -300 }}
      transition={{ duration: 0.3 }}
      className="flex flex-col h-full"
    >
      {/* 헤더 */}
      <div style={{
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'space-between',
        padding: '16px 24px',
        borderBottom: '1px solid #f0f0f0',
        backgroundColor: 'white'
      }}>
        <button
          onClick={onBack}
          style={{
            background: 'none',
            border: 'none',
            fontSize: '20px',
            cursor: 'pointer',
            padding: '8px',
            borderRadius: '8px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center'
          }}
        >
          ←
        </button>
        <div style={{ textAlign: 'center', flex: 1 }}>
          <div style={{ fontSize: '14px', fontWeight: '600', color: '#1a1a1a' }}>
            레이크사이드 • 1/25(토) 14:00 • E
          </div>
        </div>
        <button style={{
          background: 'none',
          border: 'none',
          fontSize: '20px',
          cursor: 'pointer',
          padding: '8px',
          borderRadius: '8px',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center'
        }}>
          📋
        </button>
      </div>

      {/* 콘텐츠 */}
      <div style={{ 
        flex: 1, 
        overflowY: 'auto', 
        padding: '16px',
        backgroundColor: '#F5F7FA'
      }}>
        {/* 플레이어별 현재 스코어 */}
        <div style={{
          display: 'grid',
          gridTemplateColumns: 'repeat(2, 1fr)',
          gap: '12px',
          marginBottom: '16px'
        }}>
          {players.map((player, index) => (
            <div
              key={index}
              style={{
                background: 'white',
                borderRadius: '12px',
                padding: '16px',
                boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
                border: currentPlayer === index ? '2px solid #3B82F6' : '2px solid transparent',
                cursor: 'pointer',
                transition: 'all 0.2s'
              }}
              onClick={() => setCurrentPlayer(index)}
            >
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: '12px'
              }}>
                <div style={{
                  width: '40px',
                  height: '40px',
                  borderRadius: '50%',
                  background: player.color,
                  color: 'white',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: '14px',
                  fontWeight: '600'
                }}>
                  {player.initial}
                </div>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: '14px', fontWeight: '600', marginBottom: '2px' }}>
                    {player.name}
                  </div>
                  <div style={{ fontSize: '16px', fontWeight: '700', color: '#1a1a1a' }}>
                    {formatTotalScore(playerTotals[player.name])}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* 현재 홀 정보 */}
        <div style={{
          background: 'white',
          borderRadius: '12px',
          padding: '20px',
          marginBottom: '16px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <div style={{ fontSize: '14px', fontWeight: '600', color: '#6B7280', marginBottom: '12px' }}>
            현재 홀
          </div>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            marginBottom: '16px'
          }}>
            <button
              onClick={() => setCurrentHole(Math.max(1, currentHole - 1))}
              disabled={currentHole === 1}
              style={{
                background: currentHole === 1 ? '#f3f4f6' : '#3B82F6',
                color: currentHole === 1 ? '#9CA3AF' : 'white',
                border: 'none',
                borderRadius: '8px',
                padding: '8px 12px',
                fontSize: '14px',
                fontWeight: '600',
                cursor: currentHole === 1 ? 'not-allowed' : 'pointer'
              }}
            >
              ←
            </button>
            <div style={{ textAlign: 'center' }}>
              <div style={{ fontSize: '24px', fontWeight: '700', color: '#3B82F6' }}>
                {currentHole}번 홀
              </div>
              <div style={{ fontSize: '14px', color: '#666' }}>
                Par {currentHole}
              </div>
            </div>
            <button
              onClick={() => setCurrentHole(Math.min(18, currentHole + 1))}
              disabled={currentHole === 18}
              style={{
                background: currentHole === 18 ? '#f3f4f6' : '#3B82F6',
                color: currentHole === 18 ? '#9CA3AF' : 'white',
                border: 'none',
                borderRadius: '8px',
                padding: '8px 12px',
                fontSize: '14px',
                fontWeight: '600',
                cursor: currentHole === 18 ? 'not-allowed' : 'pointer'
              }}
            >
              →
            </button>
          </div>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(3, 1fr)',
            gap: '16px',
            textAlign: 'center'
          }}>
            <div>
              <div style={{ fontSize: '12px', color: '#6B7280', marginBottom: '4px' }}>거리</div>
              <div style={{ fontSize: '14px', fontWeight: '600' }}>{currentHole * 20 + 300}y</div>
            </div>
            <div>
              <div style={{ fontSize: '12px', color: '#6B7280', marginBottom: '4px' }}>핸디캡</div>
              <div style={{ fontSize: '14px', fontWeight: '600' }}>{currentHole}</div>
            </div>
            <div>
              <div style={{ fontSize: '12px', color: '#6B7280', marginBottom: '4px' }}>현재 스코어</div>
              <div style={{ fontSize: '14px', fontWeight: '600' }}>E</div>
            </div>
          </div>
        </div>

        {/* 스코어 입력 그리드 */}
        <div style={{
          background: 'white',
          borderRadius: '12px',
          padding: '20px',
          marginBottom: '16px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(2, 1fr)',
            gap: '12px'
          }}>
            {[2, 3, 4, 5, 6, 7].map((score) => {
              const scoreType = getScoreType(score);
              const scoreLabel = getScoreLabel(score);
              const scoreIcon = getScoreIcon(score);
              
              return (
                <button
                  key={score}
                  onClick={() => inputScore(score)}
                  style={{
                    padding: '20px 16px',
                    border: '2px solid #e0e0e0',
                    borderRadius: '12px',
                    background: 'white',
                    cursor: 'pointer',
                    transition: 'all 0.2s',
                    textAlign: 'center',
                    minHeight: '80px',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    justifyContent: 'center',
                    gap: '8px',
                    ...(scoreType === 'eagle' && {
                      borderColor: '#ffd700',
                      background: 'linear-gradient(to bottom, #fffbeb, white)'
                    }),
                    ...(scoreType === 'birdie' && {
                      borderColor: '#4caf50',
                      background: 'linear-gradient(to bottom, #e8f5e9, white)'
                    }),
                    ...(scoreType === 'par' && {
                      borderColor: '#2196f3',
                      background: 'linear-gradient(to bottom, #e3f2fd, white)'
                    }),
                    ...(scoreType === 'bogey' && {
                      borderColor: '#ff9800',
                      background: 'linear-gradient(to bottom, #fff3e0, white)'
                    }),
                    ...(scoreType === 'double' && {
                      borderColor: '#f44336',
                      background: 'linear-gradient(to bottom, #ffebee, white)'
                    }),
                    ...(scoreType === 'other' && {
                      borderColor: '#9e9e9e',
                      background: 'linear-gradient(to bottom, #f5f5f5, white)'
                    })
                  }}
                  onMouseOver={(e) => {
                    e.currentTarget.style.transform = 'translateY(-2px)';
                    e.currentTarget.style.boxShadow = '0 6px 16px rgba(0,0,0,0.12)';
                  }}
                  onMouseOut={(e) => {
                    e.currentTarget.style.transform = 'translateY(0)';
                    e.currentTarget.style.boxShadow = 'none';
                  }}
                >
                  <div style={{ fontSize: '12px' }}>{scoreIcon}</div>
                  <div style={{
                    fontSize: '24px',
                    fontWeight: '700',
                    lineHeight: 1
                  }}>
                    {score === 7 ? '7+' : score}
                  </div>
                  <div style={{
                    fontSize: '12px',
                    fontWeight: '600',
                    color: '#666'
                  }}>
                    {scoreLabel}
                  </div>
                </button>
              );
            })}
          </div>
        </div>

        {/* 하단 액션 버튼들 */}
        <div style={{
          display: 'flex',
          gap: '12px',
          alignItems: 'center'
        }}>
          <button
            style={{
              background: '#f3f4f6',
              border: 'none',
              borderRadius: '12px',
              padding: '12px',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              minWidth: '48px',
              height: '48px'
            }}
          >
            ↶
          </button>
          <button
            onClick={onBack}
            style={{
              flex: 1,
              background: 'linear-gradient(135deg, #10B981, #059669)',
              color: 'white',
              border: 'none',
              borderRadius: '12px',
              padding: '16px',
              fontSize: '16px',
              fontWeight: '700',
              cursor: 'pointer',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              gap: '8px',
              boxShadow: '0 4px 12px rgba(16, 185, 129, 0.3)',
              transition: 'all 0.2s ease'
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.transform = 'translateY(-2px)';
              e.currentTarget.style.boxShadow = '0 6px 16px rgba(16, 185, 129, 0.4)';
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.transform = 'translateY(0)';
              e.currentTarget.style.boxShadow = '0 4px 12px rgba(16, 185, 129, 0.3)';
            }}
          >
            <span>입력 완료 & 다음</span>
            <span>→</span>
          </button>
        </div>
      </div>
    </motion.div>
  );
};

export default ScoreInputPage;
