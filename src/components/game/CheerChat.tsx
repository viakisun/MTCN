'use client';

import React, { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';

interface CheerMessage {
  id: string;
  playerName: string;
  message: string;
  type: 'cheer' | 'birdie' | 'eagle' | 'par';
  timestamp: Date;
}

const cheerMessages = [
  '화이팅! 💪',
  '좋은 샷! 👏',
  '버디 기원! 🍀',
  '파 세이브! 🎯',
  '이글 기원! 🦅',
  '멋진 샷! ⭐',
  '파워 샷! 💥',
  '정확한 샷! 🎪',
  '완벽한 퍼팅! 🎯',
  '드라이버 멋져! 🚀',
];

const playerNames = ['김철수', '박영호', '이민수', '최지훈', '정수진', '한미영'];

export const CheerChat: React.FC = () => {
  const [messages, setMessages] = useState<CheerMessage[]>([]);

  useEffect(() => {
    const interval = setInterval(() => {
      const newMessage: CheerMessage = {
        id: Date.now().toString(),
        playerName: playerNames[Math.floor(Math.random() * playerNames.length)],
        message: cheerMessages[Math.floor(Math.random() * cheerMessages.length)],
        type: ['cheer', 'birdie', 'eagle', 'par'][Math.floor(Math.random() * 4)] as any,
        timestamp: new Date(),
      };

      setMessages(prev => [...prev.slice(-4), newMessage]); // 최대 5개 메시지 유지
    }, 3000);

    return () => clearInterval(interval);
  }, []);

  const getMessageColor = (type: string) => {
    switch (type) {
      case 'birdie':
        return '#16A34A';
      case 'eagle':
        return '#DC2626';
      case 'par':
        return '#2563EB';
      default:
        return '#6B7280';
    }
  };

  return (
    <div className="absolute bottom-20 left-4 right-4 z-30 pointer-events-none">
      <AnimatePresence>
        {messages.map((message, index) => (
          <motion.div
            key={message.id}
            initial={{ 
              opacity: 0, 
              x: -100, 
              scale: 0.8 
            }}
            animate={{ 
              opacity: 1, 
              x: 0, 
              scale: 1 
            }}
            exit={{ 
              opacity: 0, 
              x: 100, 
              scale: 0.8 
            }}
            transition={{ 
              duration: 0.5,
              delay: index * 0.1 
            }}
            className="mb-2"
            style={{
              transform: `translateY(${index * -60}px)`,
            }}
          >
            <div
              className="bg-white rounded-full px-4 py-2 shadow-lg"
              style={{
                border: `1px solid ${designTokens.colors.border.light}`,
                maxWidth: '80%',
                marginLeft: 'auto',
              }}
            >
              <div className="flex items-center gap-2">
                <span 
                  className="text-xs font-semibold"
                  style={{ color: getMessageColor(message.type) }}
                >
                  {message.playerName}
                </span>
                <span className="text-sm">{message.message}</span>
              </div>
            </div>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
};

export default CheerChat;


