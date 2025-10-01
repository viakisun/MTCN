'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { BottomNav } from './BottomNav';
import { StatusBar } from './StatusBar';

interface PhoneFrameProps {
  children: React.ReactNode;
  className?: string;
  activeTab?: string;
  onTabChange?: (tabId: string) => void;
}

export const PhoneFrame: React.FC<PhoneFrameProps> = ({ 
  children, 
  className = '', 
  activeTab = 'rounding',
  onTabChange = () => {}
}) => {
  return (
    <div className="flex justify-center items-center min-h-screen bg-gray-100 p-8">
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.5, ease: 'easeOut' }}
        className="relative"
        style={{
          width: designTokens.phone.width,
          height: designTokens.phone.height,
        }}
      >
        {/* iPhone 프레임 */}
        <div
          className="absolute inset-0 bg-black rounded-full shadow-2xl"
          style={{
            borderRadius: designTokens.borderRadius.phone,
            boxShadow: designTokens.shadows.xl,
          }}
        />
        
        {/* Dynamic Island */}
        <div
          className="absolute bg-black rounded-full z-10"
          style={{
            width: designTokens.phone.notch.width,
            height: designTokens.phone.notch.height,
            top: designTokens.phone.notch.top,
            left: '50%',
            transform: 'translateX(-50%)',
          }}
        />
        
        {/* 화면 영역 */}
        <div
          className={`relative bg-white ${className}`}
          style={{
            width: '100%',
            height: '100%',
            borderRadius: designTokens.borderRadius.phone,
            margin: '0',
            padding: '0',
            position: 'relative',
            overflow: 'hidden',
            display: 'flex',
            flexDirection: 'column'
          }}
        >
          {/* 상단 상태바 */}
          <StatusBar />
          
          {/* 메인 콘텐츠 영역 */}
          <div 
            className="flex-1 overflow-y-auto scroll-container"
            style={{
              padding: 0
            }}
          >
            {children}
          </div>
          
          {/* 하단 네비게이션 */}
          <BottomNav activeTab={activeTab} onTabChange={onTabChange} />
        </div>
        
        {/* 홈 인디케이터 */}
        <div
          className="absolute bottom-2 left-1/2 transform -translate-x-1/2 bg-gray-800 rounded-full"
          style={{
            width: '134px',
            height: '5px',
          }}
        />
      </motion.div>
    </div>
  );
};

export default PhoneFrame;
