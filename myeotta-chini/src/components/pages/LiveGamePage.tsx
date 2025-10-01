'use client';

import React from 'react';
import { motion } from 'framer-motion';

interface LiveGamePageProps {
  onBack: () => void;
  onScoreInput: () => void;
}

export const LiveGamePage: React.FC<LiveGamePageProps> = ({ 
  onBack, 
  onScoreInput 
}) => {
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
        <h1 style={{
          fontSize: '18px',
          fontWeight: '700',
          color: '#1a1a1a',
          margin: 0
        }}>
          실시간 경기
        </h1>
        <div style={{ width: '44px' }}></div>
      </div>

      {/* 콘텐츠 */}
      <div style={{ 
        flex: 1, 
        overflowY: 'auto', 
        padding: '16px',
        backgroundColor: '#F5F7FA'
      }}>
        {/* 라운딩 정보 */}
        <div style={{
          background: 'white',
          padding: '20px',
          borderRadius: '16px',
          marginBottom: '16px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <div style={{ textAlign: 'center', marginBottom: '12px' }}>
            <div style={{ fontSize: '12px', color: '#6B7280', marginBottom: '4px' }}>
              레이크사이드 골프클럽
            </div>
            <div style={{ fontSize: '20px', fontWeight: '700', color: '#111' }}>
              1월 25일 (토) 14:00
            </div>
          </div>
          <div style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(4, 1fr)',
            gap: '8px',
            textAlign: 'center'
          }}>
            <div>
              <div style={{ fontSize: '10px', color: '#6B7280' }}>참가자</div>
              <div style={{ fontSize: '16px', fontWeight: '700' }}>4명</div>
            </div>
            <div>
              <div style={{ fontSize: '10px', color: '#6B7280' }}>홀</div>
              <div style={{ fontSize: '16px', fontWeight: '700' }}>18홀</div>
            </div>
            <div>
              <div style={{ fontSize: '10px', color: '#6B7280' }}>날씨</div>
              <div style={{ fontSize: '16px', fontWeight: '700' }}>☀️ 22°</div>
            </div>
            <div>
              <div style={{ fontSize: '10px', color: '#6B7280' }}>경기</div>
              <div style={{ fontSize: '16px', fontWeight: '700', color: '#10B981' }}>
                진행중
              </div>
            </div>
          </div>
        </div>

        {/* 실시간 리더보드 */}
        <div style={{
          background: 'white',
          borderRadius: '16px',
          padding: '20px',
          marginBottom: '16px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{
            fontSize: '16px',
            fontWeight: '700',
            marginBottom: '16px',
            display: 'flex',
            alignItems: 'center',
            gap: '8px',
            color: '#111'
          }}>
            <span>🏆</span>
            <span>실시간 리더보드</span>
          </h3>

          <div style={{ display: 'grid', gap: '12px' }}>
            {/* 1위 */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '16px',
              background: 'linear-gradient(135deg, #FEF3C7, #FDE68A)',
              borderRadius: '12px'
            }}>
              <div style={{
                fontSize: '24px',
                fontWeight: '700',
                width: '32px',
                color: '#92400E'
              }}>
                1
              </div>
              <div style={{
                width: '40px',
                height: '40px',
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #fd7e14, #e85d04)',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '14px',
                fontWeight: '600'
              }}>
                이
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '15px', fontWeight: '700', color: '#111' }}>
                  이철수
                </div>
                <div style={{ fontSize: '12px', color: '#78716C' }}>
                  평균 85타
                </div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: '24px', fontWeight: '700', color: '#16A34A' }}>
                  -1
                </div>
                <div style={{ fontSize: '11px', color: '#78716C' }}>
                  언더파
                </div>
              </div>
            </div>

            {/* 2위 */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '14px',
              background: '#F9FAFB',
              border: '1px solid #E5E7EB',
              borderRadius: '12px'
            }}>
              <div style={{
                fontSize: '20px',
                fontWeight: '700',
                width: '32px',
                color: '#6B7280'
              }}>
                2
              </div>
              <div style={{
                width: '40px',
                height: '40px',
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #2E5A87, #4A7BA7)',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '14px',
                fontWeight: '600'
              }}>
                김
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '15px', fontWeight: '600', color: '#111' }}>
                  김민수
                </div>
                <div style={{ fontSize: '12px', color: '#6B7280' }}>
                  평균 89타
                </div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: '20px', fontWeight: '700', color: '#2563EB' }}>
                  E
                </div>
                <div style={{ fontSize: '11px', color: '#6B7280' }}>
                  이븐파
                </div>
              </div>
            </div>

            {/* 3위 */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '14px',
              background: '#F9FAFB',
              border: '1px solid #E5E7EB',
              borderRadius: '12px'
            }}>
              <div style={{
                fontSize: '20px',
                fontWeight: '700',
                width: '32px',
                color: '#6B7280'
              }}>
                3
              </div>
              <div style={{
                width: '40px',
                height: '40px',
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #6f42c1, #e83e8c)',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '14px',
                fontWeight: '600'
              }}>
                최
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '15px', fontWeight: '600', color: '#111' }}>
                  최지원
                </div>
                <div style={{ fontSize: '12px', color: '#6B7280' }}>
                  평균 90타
                </div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: '20px', fontWeight: '700', color: '#F59E0B' }}>
                  +1
                </div>
                <div style={{ fontSize: '11px', color: '#6B7280' }}>
                  오버파
                </div>
              </div>
            </div>

            {/* 4위 */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '14px',
              background: '#F9FAFB',
              border: '1px solid #E5E7EB',
              borderRadius: '12px'
            }}>
              <div style={{
                fontSize: '20px',
                fontWeight: '700',
                width: '32px',
                color: '#6B7280'
              }}>
                4
              </div>
              <div style={{
                width: '40px',
                height: '40px',
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #28a745, #20c997)',
                color: 'white',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '14px',
                fontWeight: '600'
              }}>
                박
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontSize: '15px', fontWeight: '600', color: '#111' }}>
                  박영호
                </div>
                <div style={{ fontSize: '12px', color: '#6B7280' }}>
                  평균 92타
                </div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <div style={{ fontSize: '20px', fontWeight: '700', color: '#F59E0B' }}>
                  +2
                </div>
                <div style={{ fontSize: '11px', color: '#6B7280' }}>
                  오버파
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* 스코어 입력 버튼 */}
        <button
          onClick={onScoreInput}
          style={{
            width: '100%',
            background: 'linear-gradient(135deg, #3B82F6, #2563EB)',
            color: 'white',
            border: 'none',
            borderRadius: '16px',
            padding: '16px',
            fontSize: '16px',
            fontWeight: '700',
            cursor: 'pointer',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px',
            boxShadow: '0 4px 12px rgba(59, 130, 246, 0.3)',
            transition: 'all 0.2s ease'
          }}
          onMouseOver={(e) => {
            e.currentTarget.style.transform = 'translateY(-2px)';
            e.currentTarget.style.boxShadow = '0 6px 16px rgba(59, 130, 246, 0.4)';
          }}
          onMouseOut={(e) => {
            e.currentTarget.style.transform = 'translateY(0)';
            e.currentTarget.style.boxShadow = '0 4px 12px rgba(59, 130, 246, 0.3)';
          }}
        >
          <span>📊</span>
          <span>스코어 입력</span>
        </button>
      </div>
    </motion.div>
  );
};

export default LiveGamePage;
