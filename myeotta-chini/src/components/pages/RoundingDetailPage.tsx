'use client';

import React from 'react';
import { motion } from 'framer-motion';

interface RoundingDetailPageProps {
  onBack: () => void;
  onEnterStadium: () => void;
}

export const RoundingDetailPage: React.FC<RoundingDetailPageProps> = ({ 
  onBack, 
  onEnterStadium 
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
          라운딩 상세
        </h1>
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
          ⋮
        </button>
      </div>

      {/* 콘텐츠 */}
      <div style={{ 
        flex: 1, 
        overflowY: 'auto', 
        padding: '24px',
        backgroundColor: '#F5F7FA'
      }}>
        {/* 동문회 배지 */}
        <div style={{
          display: 'inline-flex',
          alignItems: 'center',
          gap: '6px',
          background: 'linear-gradient(135deg, #2E5A87, #4A7BA7)',
          color: 'white',
          padding: '6px 12px',
          borderRadius: '8px',
          fontSize: '12px',
          fontWeight: '700',
          marginBottom: '16px'
        }}>
          <span>🎓</span>
          <span>연세대 골프동문회</span>
        </div>

        {/* 헤더 정보 */}
        <div style={{ marginBottom: '32px' }}>
          <h1 style={{
            fontSize: '24px',
            fontWeight: '700',
            color: '#1a1a1a',
            marginBottom: '12px'
          }}>
            레이크사이드 골프클럽
          </h1>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            gap: '12px',
            marginBottom: '12px'
          }}>
            <div style={{
              background: '#3B82F6',
              color: 'white',
              padding: '4px 12px',
              borderRadius: '12px',
              fontSize: '13px',
              fontWeight: '600'
            }}>
              오늘
            </div>
            <span style={{ fontSize: '14px', color: '#666' }}>
              📅 1월 25일 (토) 14:00
            </span>
          </div>
          <div style={{ fontSize: '14px', color: '#666' }}>
            📍 경기도 가평군 북면 이곡리 234
          </div>
        </div>

        {/* 기본 정보 */}
        <div style={{
          background: 'white',
          borderRadius: '16px',
          padding: '20px',
          marginBottom: '24px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{
            fontSize: '16px',
            fontWeight: '700',
            marginBottom: '16px',
            display: 'flex',
            alignItems: 'center',
            gap: '8px'
          }}>
            <span>ℹ️</span>
            <span>기본 정보</span>
          </h3>
          <div style={{ display: 'grid', gap: '12px' }}>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              padding: '12px 0',
              borderBottom: '1px solid #f0f0f0'
            }}>
              <span style={{ color: '#666', fontSize: '14px' }}>코스</span>
              <span style={{ fontWeight: '600', fontSize: '14px' }}>18홀</span>
            </div>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              padding: '12px 0',
              borderBottom: '1px solid #f0f0f0'
            }}>
              <span style={{ color: '#666', fontSize: '14px' }}>그린피</span>
              <span style={{ fontWeight: '600', fontSize: '14px' }}>120,000원</span>
            </div>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              padding: '12px 0',
              borderBottom: '1px solid #f0f0f0'
            }}>
              <span style={{ color: '#666', fontSize: '14px' }}>날씨</span>
              <span style={{ fontWeight: '600', fontSize: '14px' }}>☀️ 맑음 22°C</span>
            </div>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              padding: '12px 0'
            }}>
              <span style={{ color: '#666', fontSize: '14px' }}>공개 범위</span>
              <span style={{ fontWeight: '600', fontSize: '14px' }}>🎓 동문회 멤버만</span>
            </div>
          </div>
        </div>

        {/* 참가자 정보 */}
        <div style={{
          background: 'white',
          borderRadius: '16px',
          padding: '20px',
          marginBottom: '24px',
          boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
        }}>
          <h3 style={{
            fontSize: '16px',
            fontWeight: '700',
            marginBottom: '16px',
            display: 'flex',
            alignItems: 'center',
            gap: '8px'
          }}>
            <span>👥</span>
            <span>참가자 (4/4)</span>
          </h3>

          <div style={{ display: 'grid', gap: '12px' }}>
            {/* 호스트 */}
            <div style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '12px',
              background: '#f8f9fa',
              borderRadius: '12px'
            }}>
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
                <div style={{ fontSize: '15px', fontWeight: '600', marginBottom: '2px' }}>
                  김민수
                </div>
                <div style={{ fontSize: '12px', color: '#666' }}>
                  평균 89타 • 호스트
                </div>
              </div>
              <div style={{
                background: '#2E5A87',
                color: 'white',
                padding: '4px 8px',
                borderRadius: '6px',
                fontSize: '11px',
                fontWeight: '700'
              }}>
                호스트
              </div>
            </div>

            {/* 참가자들 */}
            {[
              { name: '박영희', avg: '92타', initial: '박', color: 'linear-gradient(135deg, #28a745, #20c997)' },
              { name: '이철수', avg: '85타', initial: '이', color: 'linear-gradient(135deg, #fd7e14, #e85d04)' },
              { name: '최지원', avg: '90타', initial: '최', color: 'linear-gradient(135deg, #6f42c1, #e83e8c)' }
            ].map((player, index) => (
              <div key={index} style={{
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                padding: '12px',
                background: '#f8f9fa',
                borderRadius: '12px'
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
                  <div style={{ fontSize: '15px', fontWeight: '600', marginBottom: '2px' }}>
                    {player.name}
                  </div>
                  <div style={{ fontSize: '12px', color: '#666' }}>
                    평균 {player.avg}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* 경기장 입장 버튼 */}
        <button
          onClick={onEnterStadium}
          style={{
            width: '100%',
            background: 'linear-gradient(135deg, #10B981, #059669)',
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
          <span>⚡</span>
          <span>경기장 입장</span>
        </button>
      </div>
    </motion.div>
  );
};

export default RoundingDetailPage;
