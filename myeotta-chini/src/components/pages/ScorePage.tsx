"use client";

import React from 'react';

const ScorePage: React.FC = () => {
  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ padding: '16px 24px 120px', background: '#F5F7FA' }}
    >
      {/* 스코어 페이지 내용 */}
      <div style={{
        background: 'white',
        borderRadius: '16px',
        padding: '20px',
        marginBottom: '16px',
        boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
      }}>
        <h2 style={{
          fontSize: '18px',
          fontWeight: '700',
          color: '#1a1a1a',
          marginBottom: '16px'
        }}>
          스코어 관리
        </h2>
        <p style={{
          fontSize: '14px',
          color: '#666',
          lineHeight: '1.5'
        }}>
          스코어 페이지 구현 예정
        </p>
      </div>
    </div>
  );
};

export default ScorePage;
