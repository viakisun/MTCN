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
        
        {/* iPhone 16 Pro Dynamic Island */}
        <div
          className="absolute bg-black z-10"
          style={{
            width: designTokens.phone.notch.width,
            height: designTokens.phone.notch.height,
            top: '11px',
            left: '50%',
            transform: 'translateX(-50%)',
            borderRadius: designTokens.phone.notch.borderRadius,
          }}
        />
        
        {/* iPhone 16 Pro 화면 영역 */}
        <div
          className={`relative bg-white ${className}`}
          style={{
            width: '100%',
            height: '100%',
            borderRadius: designTokens.borderRadius.phone,
            margin: '0',
            paddingTop: '44px', // Status Bar 높이만큼만
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
              paddingBottom: '88px', // 네비게이션 바 높이만큼 하단 패딩
              padding: 0
            }}
          >
            {children}
          </div>
          
          {/* 하단 네비게이션 - 절대 위치로 고정 */}
          <div
            style={{
              position: 'absolute',
              bottom: '0',
              left: '0',
              right: '0',
              zIndex: 50,
            }}
          >
            <BottomNav activeTab={activeTab} onTabChange={onTabChange} />
          </div>
        </div>
        
        {/* 홈 인디케이터 */}
        <div
          style={{
            position: 'absolute',
            bottom: '8px',
            left: '50%',
            transform: 'translateX(-50%)',
            width: '134px',
            height: '5px',
            backgroundColor: designTokens.colors.neutral[800],
            borderRadius: '2.5px',
            zIndex: 60,
          }}
        />
      </motion.div>
    </div>
  );
};

export default PhoneFrame;
