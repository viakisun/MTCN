"use client";

import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import RoundingDetailPage from '@/components/pages/RoundingDetailPage';
import LiveGamePage from '@/components/pages/LiveGamePage';
import ScoreInputPage from '@/components/pages/ScoreInputPage';

interface RoundingPageProps {
  currentPage: 'rounding' | 'detail' | 'live' | 'score';
  setCurrentPage: (page: 'rounding' | 'detail' | 'live' | 'score') => void;
}

const RoundingPage: React.FC<RoundingPageProps> = ({ currentPage, setCurrentPage }) => {
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
    <div 
      className="flex-1 relative overflow-y-auto scroll-container" 
      style={{ background: '#F5F7FA' }}
    >
      {/* 헤더 */}
      <div className="header-bar" style={{ justifyContent: 'center' }}>
        <div className="page-title" style={{
          fontSize: '18px',
          fontWeight: '700',
          color: '#111'
        }}>
          라운딩
        </div>
      </div>

      {/* 메인 콘텐츠 */}
      <div style={{ padding: '16px 24px 120px' }}>
        {/* 내 일정 섹션 */}
        <div style={{ marginBottom: '24px' }}>
          <h2 style={{
            fontSize: '16px',
            fontWeight: '700',
            color: '#111',
            marginBottom: '16px',
            padding: '0 4px'
          }}>
            내 일정
          </h2>
          
          {/* 연세대 골프동문회 카드 */}
          <motion.div
            onClick={() => setCurrentPage('detail')}
            style={{
              background: 'white',
              borderRadius: '16px',
              padding: '20px',
              marginBottom: '12px',
              boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
              cursor: 'pointer',
              border: '1px solid #e5e7eb'
            }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'flex-start',
              marginBottom: '12px'
            }}>
              <div>
                <h3 style={{
                  fontSize: '16px',
                  fontWeight: '700',
                  color: '#1a1a1a',
                  marginBottom: '4px'
                }}>
                  연세대 골프동문회
                </h3>
                <p style={{
                  fontSize: '13px',
                  color: '#666',
                  marginBottom: '8px'
                }}>
                  1/25(토) 14:00 • 레이크사이드 CC
                </p>
              </div>
              <div style={{
                background: '#10B981',
                color: 'white',
                padding: '4px 8px',
                borderRadius: '6px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                진행중
              </div>
            </div>
            
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center'
            }}>
              <div style={{
                display: 'flex',
                gap: '8px',
                alignItems: 'center'
              }}>
                <span style={{
                  fontSize: '12px',
                  color: '#666'
                }}>
                  👥 4명
                </span>
                <span style={{
                  fontSize: '12px',
                  color: '#666'
                }}>
                  💰 50,000원
                </span>
              </div>
              <div style={{ color: '#2E5A87', fontSize: '16px' }}>›</div>
            </div>
          </motion.div>

          {/* 개인 라운딩 카드 */}
          <motion.div
            onClick={() => setCurrentPage('detail')}
            style={{
              background: 'white',
              borderRadius: '16px',
              padding: '20px',
              marginBottom: '12px',
              boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
              cursor: 'pointer',
              border: '1px solid #e5e7eb'
            }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'flex-start',
              marginBottom: '12px'
            }}>
              <div>
                <h3 style={{
                  fontSize: '16px',
                  fontWeight: '700',
                  color: '#1a1a1a',
                  marginBottom: '4px'
                }}>
                  개인 라운딩
                </h3>
                <p style={{
                  fontSize: '13px',
                  color: '#666',
                  marginBottom: '8px'
                }}>
                  1/26(일) 10:00 • 스카이힐 CC
                </p>
              </div>
              <div style={{
                background: '#F59E0B',
                color: 'white',
                padding: '4px 8px',
                borderRadius: '6px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                예정
              </div>
            </div>
            
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center'
            }}>
              <div style={{
                display: 'flex',
                gap: '8px',
                alignItems: 'center'
              }}>
                <span style={{
                  fontSize: '12px',
                  color: '#666'
                }}>
                  👥 2명
                </span>
                <span style={{
                  fontSize: '12px',
                  color: '#666'
                }}>
                  💰 80,000원
                </span>
              </div>
              <div style={{ color: '#2E5A87', fontSize: '16px' }}>›</div>
            </div>
          </motion.div>
        </div>

        {/* 참여 가능한 라운딩 섹션 */}
        <div style={{ marginBottom: '24px' }}>
          <h2 style={{
            fontSize: '16px',
            fontWeight: '700',
            color: '#111',
            marginBottom: '16px',
            padding: '0 4px'
          }}>
            참여 가능한 라운딩
          </h2>
          
          {/* 초대받은 라운딩 카드 */}
          <motion.div
            onClick={() => setCurrentPage('detail')}
            style={{
              background: 'white',
              borderRadius: '16px',
              padding: '20px',
              marginBottom: '12px',
              boxShadow: '0 1px 3px rgba(0,0,0,0.1)',
              cursor: 'pointer',
              border: '1px solid #e5e7eb'
            }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'flex-start',
              marginBottom: '12px'
            }}>
              <div>
                <h3 style={{
                  fontSize: '16px',
                  fontWeight: '700',
                  color: '#1a1a1a',
                  marginBottom: '4px'
                }}>
                  초대받은 라운딩
                </h3>
                <p style={{
                  fontSize: '13px',
                  color: '#666',
                  marginBottom: '8px'
                }}>
                  1/27(월) 15:00 • 골든밸리 CC
                </p>
              </div>
              <div style={{
                background: '#3B82F6',
                color: 'white',
                padding: '4px 8px',
                borderRadius: '6px',
                fontSize: '11px',
                fontWeight: '600'
              }}>
                초대
              </div>
            </div>
            
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center'
            }}>
              <div style={{
                display: 'flex',
                gap: '8px',
                alignItems: 'center'
              }}>
                <span style={{
                  fontSize: '12px',
                  color: '#666'
                }}>
                  👥 3명
                </span>
                <span style={{
                  fontSize: '12px',
                  color: '#666'
                }}>
                  💰 60,000원
                </span>
              </div>
              <div style={{ color: '#2E5A87', fontSize: '16px' }}>›</div>
            </div>
          </motion.div>
        </div>

        {/* 라운딩 만들기 버튼 */}
        <motion.div
          onClick={() => console.log('라운딩 만들기')}
          style={{
            background: 'white',
            borderRadius: '16px',
            padding: '16px',
            border: '2px solid #2E5A87',
            cursor: 'pointer',
            textAlign: 'center',
            boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
          }}
          whileHover={{ backgroundColor: '#f8f9fa', y: -1 }}
          whileTap={{ scale: 0.98 }}
        >
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '8px'
          }}>
            <div style={{ fontSize: '18px', color: '#2E5A87' }}>➕</div>
            <div style={{ fontSize: '16px', fontWeight: '600', color: '#2E5A87' }}>
              라운딩 만들기
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default RoundingPage;
