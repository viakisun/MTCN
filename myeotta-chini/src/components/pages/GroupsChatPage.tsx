'use client';

import React, { useState } from 'react';
import { motion } from 'framer-motion';

interface GroupsChatPageProps {
  onBack: () => void;
  onJoinRound: () => void;
  onCreateRound: () => void;
  onShowReport: () => void;
}

export const GroupsChatPage: React.FC<GroupsChatPageProps> = ({ 
  onBack, 
  onJoinRound,
  onCreateRound,
  onShowReport
}) => {
  const [message, setMessage] = useState('');
  const [showHamburgerMenu, setShowHamburgerMenu] = useState(false);

  const chatMessages = [
    {
      id: 1,
      name: '김회장',
      initial: '김',
      color: '#2E5A87',
      isAdmin: true,
      time: '14:25',
      message: `2월 정기 라운딩 오픈했습니다! 🎉

📅 2월 15일 (토) 07:00
🌏 레이크사이드 골프클럽
💰 참가비: 145,000원

새로운 AI 팀 배정 시스템으로 더욱 균형잡힌 경기를 즐겨보세요!`,
      reactions: [
        { emoji: '👍', count: 5 },
        { emoji: '🎉', count: 3 }
      ]
    },
    {
      id: 2,
      name: '박영호',
      initial: '박',
      color: '#28a745',
      isAdmin: false,
      time: '14:28',
      message: '벌써 신청 완료! AI 팀 배정 진짜 궁금하네요 🤖',
      reactions: [
        { emoji: '👍', count: 3 }
      ]
    },
    {
      id: 3,
      name: '이민수',
      initial: '이',
      color: '#fd7e14',
      isAdmin: false,
      time: '14:30',
      message: '저도 신청했어요! 레이크사이드 정말 좋죠 ⛳',
      reactions: [
        { emoji: '👍', count: 2 }
      ]
    },
    {
      id: 4,
      name: '정우영',
      initial: '정',
      color: '#6f42c1',
      isAdmin: false,
      time: '14:32',
      message: 'AI가 어떻게 팀을 배정하는 거예요? 실력 기반인가요? 🤔',
      reactions: [
        { emoji: '👍', count: 1 }
      ]
    },
    {
      id: 5,
      name: '김회장',
      initial: '김',
      color: '#2E5A87',
      isAdmin: true,
      time: '14:34',
      message: '@정우영 실력 + 친분도 + 과거 함께한 횟수 등을 종합해서 가장 재미있게 플레이할 수 있는 조합으로 배정해줘요! 📊',
      reactions: [
        { emoji: '👍', count: 4 }
      ]
    },
    {
      id: 6,
      name: '최지수',
      initial: '최',
      color: '#e85d04',
      isAdmin: false,
      time: '14:36',
      message: '어제 연습장에서 새 드라이버 테스트! 거리가 20야드 늘었어요 🚀',
      reactions: []
    }
  ];

  const sendMessage = () => {
    if (message.trim()) {
      console.log('메시지 전송:', message);
      setMessage('');
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0, x: 300 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -300 }}
      transition={{ duration: 0.3 }}
      className="flex flex-col h-full"
    >
      {/* 채팅 헤더 - golf-groups.html의 chat-header와 동일 */}
      <div style={{
        backgroundColor: 'white',
        borderBottom: '1px solid #f0f0f0'
      }}>
        {/* 헤더 바 - golf-groups.html의 header-bar와 동일 */}
        <div style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
          padding: '16px 24px'
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
            서울대 경영대 골프회
          </h1>
          <button
            onClick={() => setShowHamburgerMenu(true)}
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
            ≡
          </button>
        </div>
      </div>

      {/* 채팅 메시지 영역 - golf-groups.html의 chat-body와 동일 */}
      <div style={{ 
        flex: 1, 
        overflowY: 'auto', 
        padding: '16px',
        backgroundColor: '#F5F7FA'
      }}>
        {/* 고정 공지 메시지 - golf-groups.html의 pinned-message와 동일 */}
        <div style={{
          background: 'linear-gradient(135deg, #fff3cd, #ffeaa7)',
          border: '1px solid #ffeaa7',
          borderRadius: '12px',
          padding: '16px',
          marginBottom: '20px',
          position: 'relative'
        }}>
          <div style={{
            position: 'absolute',
            top: '8px',
            left: '8px',
            fontSize: '12px'
          }}>
            📌
          </div>
          <div style={{
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            marginBottom: '8px',
            marginLeft: '20px'
          }}>
            <div style={{
              fontWeight: '700',
              color: '#856404',
              fontSize: '15px'
            }}>
              2월 정기 라운딩
            </div>
            <div style={{
              background: '#28a745',
              color: 'white',
              padding: '2px 8px',
              borderRadius: '12px',
              fontSize: '10px',
              fontWeight: '600'
            }}>
              모집중
            </div>
          </div>
          <div style={{
            display: 'flex',
            gap: '16px',
            alignItems: 'center',
            marginBottom: '10px',
            marginLeft: '20px'
          }}>
            <div>
              <div style={{
                fontSize: '13px',
                fontWeight: '600',
                color: '#2E5A87'
              }}>
                2/15 (토) 07:00
              </div>
              <div style={{ fontSize: '12px', color: '#666' }}>
                레이크사이드 CC
              </div>
            </div>
            <div>
              <div style={{
                fontSize: '13px',
                fontWeight: '600',
                color: '#dc3545'
              }}>
                ₩145,000
              </div>
              <div style={{ fontSize: '12px', color: '#666' }}>
                16/24명
              </div>
            </div>
            <div style={{ flex: 1 }}>
              <button
                onClick={onJoinRound}
                style={{
                  background: 'linear-gradient(135deg, #2E5A87, #4A7BA7)',
                  color: 'white',
                  border: 'none',
                  padding: '8px 16px',
                  borderRadius: '20px',
                  fontSize: '13px',
                  fontWeight: '600',
                  width: '100%',
                  cursor: 'pointer',
                  transition: 'all 0.2s'
                }}
              >
                참가신청
              </button>
            </div>
          </div>
        </div>

        {/* 시간 구분선 - golf-groups.html과 동일 */}
        <div style={{ textAlign: 'center', margin: '20px 0' }}>
          <span style={{
            background: '#e9ecef',
            color: '#6c757d',
            padding: '4px 12px',
            borderRadius: '12px',
            fontSize: '12px'
          }}>
            오늘
          </span>
        </div>

        {/* 채팅 메시지들 - golf-groups.html의 chat-message와 동일 */}
        {chatMessages.map((msg) => (
          <div key={msg.id} style={{
            display: 'flex',
            gap: '12px',
            marginBottom: '16px'
          }}>
            <div style={{
              width: '40px',
              height: '40px',
              borderRadius: '50%',
              background: msg.color,
              color: 'white',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '14px',
              fontWeight: '600',
              flexShrink: 0
            }}>
              {msg.initial}
            </div>
            <div style={{ flex: 1 }}>
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: '8px',
                marginBottom: '4px'
              }}>
                <span style={{
                  fontSize: '14px',
                  fontWeight: '600',
                  color: '#1a1a1a'
                }}>
                  {msg.name}
                </span>
                {msg.isAdmin && (
                  <span style={{
                    background: '#2E5A87',
                    color: 'white',
                    padding: '2px 6px',
                    borderRadius: '8px',
                    fontSize: '10px',
                    fontWeight: '600'
                  }}>
                    관리자
                  </span>
                )}
                <span style={{
                  fontSize: '12px',
                  color: '#999'
                }}>
                  {msg.time}
                </span>
              </div>
              <div style={{
                background: msg.isAdmin ? '#e3f2fd' : 'white',
                borderRadius: '12px',
                padding: '12px',
                fontSize: '14px',
                lineHeight: '1.4',
                marginBottom: '8px',
                boxShadow: '0 1px 2px rgba(0,0,0,0.1)'
              }}>
                {msg.message}
              </div>
              <div style={{
                display: 'flex',
                gap: '8px',
                alignItems: 'center'
              }}>
                {msg.reactions.map((reaction, index) => (
                  <button
                    key={index}
                    style={{
                      background: '#f8f9fa',
                      border: '1px solid #e5e7eb',
                      borderRadius: '12px',
                      padding: '4px 8px',
                      fontSize: '12px',
                      cursor: 'pointer',
                      transition: 'all 0.2s'
                    }}
                    onMouseOver={(e) => {
                      e.currentTarget.style.background = '#e9ecef';
                    }}
                    onMouseOut={(e) => {
                      e.currentTarget.style.background = '#f8f9fa';
                    }}
                  >
                    {reaction.emoji} {reaction.count}
                  </button>
                ))}
                <button style={{
                  background: 'none',
                  border: 'none',
                  fontSize: '12px',
                  color: '#666',
                  cursor: 'pointer',
                  padding: '4px 8px'
                }}>
                  답장
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* 하단 입력 영역 - golf-groups.html의 chat-input-area와 동일 */}
      <div style={{
        padding: '16px',
        backgroundColor: 'white',
        borderTop: '1px solid #f0f0f0'
      }}>
        <div style={{
          display: 'flex',
          alignItems: 'flex-end',
          gap: '8px'
        }}>
          <button style={{
            background: '#f8f9fa',
            border: '1px solid #e5e7eb',
            borderRadius: '8px',
            width: '40px',
            height: '40px',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '18px',
            cursor: 'pointer'
          }}>
            +
          </button>
          <textarea
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            placeholder="메시지를 입력하세요..."
            style={{
              flex: 1,
              padding: '12px',
              border: '1px solid #e5e7eb',
              borderRadius: '8px',
              fontSize: '14px',
              outline: 'none',
              resize: 'none',
              minHeight: '40px',
              maxHeight: '120px'
            }}
            rows={1}
          />
          <button
            onClick={sendMessage}
            style={{
              background: '#2E5A87',
              color: 'white',
              border: 'none',
              borderRadius: '8px',
              width: '40px',
              height: '40px',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              fontSize: '16px',
              cursor: 'pointer'
            }}
          >
            ➤
          </button>
        </div>
      </div>

      {/* 햄버거 메뉴 오버레이 - golf-groups.html의 hamburger-panel과 동일 */}
      {showHamburgerMenu && (
        <div
          style={{
            position: 'fixed',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            background: 'rgba(0,0,0,0.5)',
            zIndex: 1000
          }}
          onClick={() => setShowHamburgerMenu(false)}
        >
          <div
            style={{
              position: 'absolute',
              top: 0,
              right: 0,
              width: '280px',
              height: '100%',
              background: 'white',
              boxShadow: '-4px 0 20px rgba(0,0,0,0.15)',
              padding: '20px'
            }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* 메뉴 헤더 - golf-groups.html과 동일 */}
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              marginBottom: '24px'
            }}>
              <div>
                <div style={{ fontSize: '18px', fontWeight: '700' }}>메뉴</div>
                <div style={{ fontSize: '13px', color: '#666', marginTop: '2px' }}>
                  서울대 경영대 골프회
                </div>
              </div>
              <button
                onClick={() => setShowHamburgerMenu(false)}
                style={{
                  background: 'none',
                  border: 'none',
                  fontSize: '20px',
                  color: '#666',
                  cursor: 'pointer'
                }}
              >
                ×
              </button>
            </div>

            {/* 빠른 액션 - golf-groups.html과 동일 */}
            <div style={{ marginBottom: '24px' }}>
              <h3 style={{
                fontSize: '14px',
                fontWeight: '600',
                color: '#666',
                marginBottom: '12px'
              }}>
                빠른 액션
              </h3>
              <div
                onClick={() => { onShowReport(); setShowHamburgerMenu(false); }}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '12px',
                  padding: '12px',
                  borderRadius: '8px',
                  cursor: 'pointer',
                  transition: 'background-color 0.2s'
                }}
                onMouseOver={(e) => {
                  e.currentTarget.style.background = '#f8f9fa';
                }}
                onMouseOut={(e) => {
                  e.currentTarget.style.background = 'transparent';
                }}
              >
                <div style={{ fontSize: '20px' }}>📊</div>
                <div style={{ flex: 1, fontSize: '14px', fontWeight: '500' }}>
                  라운딩 리포트
                </div>
                <div style={{
                  background: '#dc3545',
                  color: 'white',
                  padding: '2px 6px',
                  borderRadius: '8px',
                  fontSize: '10px',
                  fontWeight: '600'
                }}>
                  새 2
                </div>
              </div>
            </div>

            {/* 관리 기능 - golf-groups.html과 동일 */}
            <div style={{ marginBottom: '24px' }}>
              <h3 style={{
                fontSize: '14px',
                fontWeight: '600',
                color: '#666',
                marginBottom: '12px'
              }}>
                관리 기능
              </h3>
              <div
                onClick={() => { onCreateRound(); setShowHamburgerMenu(false); }}
                style={{
                  display: 'flex',
                  alignItems: 'center',
                  gap: '12px',
                  padding: '12px',
                  borderRadius: '8px',
                  cursor: 'pointer',
                  transition: 'background-color 0.2s'
                }}
                onMouseOver={(e) => {
                  e.currentTarget.style.background = '#f8f9fa';
                }}
                onMouseOut={(e) => {
                  e.currentTarget.style.background = 'transparent';
                }}
              >
                <div style={{ fontSize: '20px' }}>🎯</div>
                <div style={{ fontSize: '14px', fontWeight: '500' }}>
                  라운딩 생성하기
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </motion.div>
  );
};

export default GroupsChatPage;
