'use client';

import React, { useState } from 'react';
import { motion } from 'framer-motion';

interface GroupsMainPageProps {
  onBack: () => void;
  onGroupChat: () => void;
  onCreateGroup: () => void;
}

export const GroupsMainPage: React.FC<GroupsMainPageProps> = ({ 
  onBack, 
  onGroupChat, 
  onCreateGroup 
}) => {
  const [searchQuery, setSearchQuery] = useState('');

  return (
    <motion.div
      initial={{ opacity: 0, x: 300 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -300 }}
      transition={{ duration: 0.3 }}
      className="flex flex-col h-full"
    >
      {/* 콘텐츠 영역 - golf-groups.html의 content-area와 동일 */}
      <div style={{ 
        padding: '16px 24px', 
        paddingBottom: 'calc(80px + env(safe-area-inset-bottom))', 
        overflowY: 'auto',
        backgroundColor: '#F5F7FA'
      }}>
        {/* 내가 가입한 동문회 - golf-groups.html의 card와 동일 */}
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
            color: '#1a1a1a',
            marginBottom: '16px'
          }}>
            내가 가입한 동문회
          </h3>
          
          {/* 서울대 경영대 골프회 - golf-groups.html과 동일 */}
          <div
            onClick={onGroupChat}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '16px',
              border: '1px solid #e5e7eb',
              borderRadius: '12px',
              marginBottom: '12px',
              background: '#fafafa',
              cursor: 'pointer',
              transition: 'all 0.2s'
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.background = '#f0f0f0';
              e.currentTarget.style.transform = 'translateY(-1px)';
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.background = '#fafafa';
              e.currentTarget.style.transform = 'translateY(0)';
            }}
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
              <div style={{ fontSize: '12px', color: '#999' }}>
                새로운 소식 3개
              </div>
            </div>
            <div style={{ color: '#2E5A87', fontSize: '18px' }}>›</div>
          </div>

          {/* 강남 직장인 골프 모임 - golf-groups.html과 동일 */}
          <div
            onClick={onGroupChat}
            style={{
              display: 'flex',
              alignItems: 'center',
              gap: '12px',
              padding: '16px',
              border: '1px solid #e5e7eb',
              borderRadius: '12px',
              background: '#fafafa',
              cursor: 'pointer',
              transition: 'all 0.2s'
            }}
            onMouseOver={(e) => {
              e.currentTarget.style.background = '#f0f0f0';
              e.currentTarget.style.transform = 'translateY(-1px)';
            }}
            onMouseOut={(e) => {
              e.currentTarget.style.background = '#fafafa';
              e.currentTarget.style.transform = 'translateY(0)';
            }}
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
              <div style={{ fontSize: '12px', color: '#999' }}>
                새로운 소식 1개
              </div>
            </div>
            <div style={{ color: '#2E5A87', fontSize: '18px' }}>›</div>
          </div>
        </div>

        {/* 동문회 찾아보기 - golf-groups.html과 동일 */}
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
            color: '#1a1a1a'
          }}>
            동문회 찾아보기
          </h3>
          
          {/* 검색창 - golf-groups.html과 동일 */}
          <div style={{
            display: 'flex',
            gap: '8px',
            marginBottom: '16px'
          }}>
            <input
              type="text"
              placeholder="동문회명 또는 키워드 검색"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              style={{
                flex: 1,
                padding: '12px',
                border: '1px solid #e5e7eb',
                borderRadius: '8px',
                fontSize: '14px',
                outline: 'none'
              }}
            />
            <button
              onClick={() => console.log('검색:', searchQuery)}
              style={{
                background: '#2E5A87',
                color: 'white',
                border: 'none',
                padding: '12px 16px',
                borderRadius: '8px',
                fontSize: '13px',
                fontWeight: '600',
                cursor: 'pointer'
              }}
            >
              검색
            </button>
          </div>
          
          {/* 카테고리 필터 - golf-groups.html과 동일 */}
          <div style={{
            display: 'flex',
            gap: '8px',
            flexWrap: 'wrap'
          }}>
            <button
              onClick={() => console.log('학교별 필터')}
              style={{
                background: '#f8f9fa',
                border: '1px solid #e5e7eb',
                padding: '8px 12px',
                borderRadius: '6px',
                fontSize: '12px',
                color: '#666',
                cursor: 'pointer'
              }}
            >
              #학교별
            </button>
            <button
              onClick={() => console.log('직장인 필터')}
              style={{
                background: '#f8f9fa',
                border: '1px solid #e5e7eb',
                padding: '8px 12px',
                borderRadius: '6px',
                fontSize: '12px',
                color: '#666',
                cursor: 'pointer'
              }}
            >
              #직장인
            </button>
            <button
              onClick={() => console.log('지역별 필터')}
              style={{
                background: '#f8f9fa',
                border: '1px solid #e5e7eb',
                padding: '8px 12px',
                borderRadius: '6px',
                fontSize: '12px',
                color: '#666',
                cursor: 'pointer'
              }}
            >
              #지역별
            </button>
            <button
              onClick={() => console.log('초보자 필터')}
              style={{
                background: '#f8f9fa',
                border: '1px solid #e5e7eb',
                padding: '8px 12px',
                borderRadius: '6px',
                fontSize: '12px',
                color: '#666',
                cursor: 'pointer'
              }}
            >
              #초보자
            </button>
          </div>
        </div>

        {/* 새 동문회 만들기 버튼 - golf-groups.html과 동일 */}
        <div
          onClick={onCreateGroup}
          style={{
            background: 'white',
            borderRadius: '16px',
            padding: '12px',
            border: '2px solid #2E5A87',
            cursor: 'pointer',
            transition: 'all 0.2s',
            marginTop: '-4px',
            boxShadow: '0 1px 3px rgba(0,0,0,0.1)'
          }}
          onMouseOver={(e) => {
            e.currentTarget.style.background = '#f8f9fa';
            e.currentTarget.style.transform = 'translateY(-1px)';
          }}
          onMouseOut={(e) => {
            e.currentTarget.style.background = 'white';
            e.currentTarget.style.transform = 'translateY(0)';
          }}
        >
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: '10px'
          }}>
            <div style={{ fontSize: '18px', color: '#2E5A87' }}>➕</div>
            <div style={{ fontSize: '16px', fontWeight: '600', color: '#2E5A87' }}>
              새 동문회 만들기
            </div>
          </div>
        </div>
      </div>
    </motion.div>
  );
};

export default GroupsMainPage;
