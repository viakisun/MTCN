import { useEffect, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { PhoneFrame } from '@/components/layout/PhoneFrame';
import WebHeader from '@/components/layout/WebHeader';
import WebBottomNav from '@/components/layout/WebBottomNav';
import { useAppStore } from '@/lib/store';
import { shouldUsePhoneFrame } from '@/utils/environment';
import HomePage from '@/components/pages/HomePage';
import RoundingPage from '@/components/pages/RoundingPage';
import GroupsPage from '@/components/pages/GroupsPage';
import ScorePage from '@/components/pages/ScorePage';
import ProfilePage from '@/components/pages/ProfilePage';

export default function App() {
  const { 
    activeTab, 
    setActiveTab,
    isDemoMode,
    setDemoStep
  } = useAppStore();
  
  const [currentPage, setCurrentPage] = useState<'rounding' | 'detail' | 'live' | 'score'>('rounding');

  // 데모 자동 진행
  useEffect(() => {
    if (!isDemoMode) return;

    const demoSequence = [
      { delay: 2000, action: () => setDemoStep(1) },
      { delay: 5000, action: () => setActiveTab('groups') },
      { delay: 8000, action: () => setDemoStep(2) },
      { delay: 12000, action: () => setActiveTab('rounding') },
      { delay: 15000, action: () => setDemoStep(3) },
    ];

    demoSequence.forEach(({ delay, action }) => {
      setTimeout(action, delay);
    });
  }, [isDemoMode, setActiveTab, setDemoStep]);

  // 배포 환경에서는 iPhone 프레임 없이 직접 렌더링
  if (!shouldUsePhoneFrame) {
    return (
      <div className="min-h-screen bg-gray-50">
        <WebHeader />
        <div 
          className="flex flex-col"
          style={{ 
            paddingTop: '80px', // 헤더 높이만큼 여백
            paddingBottom: '80px', // 하단 네비게이션 높이만큼 여백
            minHeight: '100vh'
          }}
        >
          <AnimatePresence mode="wait">
            <motion.div
              key={activeTab}
              initial={{ opacity: 0, x: 300 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -300 }}
              transition={{ duration: 0.3 }}
              className="flex-1 flex flex-col"
            >
              {activeTab === 'home' && <HomePage />}
              {activeTab === 'rounding' && <RoundingPage />}
              {activeTab === 'groups' && <GroupsPage />}
              {activeTab === 'score' && <ScorePage />}
              {activeTab === 'profile' && <ProfilePage />}
            </motion.div>
          </AnimatePresence>
        </div>
        <WebBottomNav />
      </div>
    );
  }

  // 개발 환경에서는 iPhone 프레임 사용
  return (
    <PhoneFrame activeTab={activeTab} onTabChange={setActiveTab}>
      <div className="flex flex-col h-full relative">
        <AnimatePresence mode="wait">
          <motion.div
            key={activeTab}
            initial={{ opacity: 0, x: 300 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -300 }}
            transition={{ duration: 0.3 }}
            className="flex-1 flex flex-col"
          >
            {activeTab === 'home' && <HomePage />}
            {activeTab === 'rounding' && <RoundingPage />}
            {activeTab === 'groups' && <GroupsPage />}
            {activeTab === 'score' && <ScorePage />}
            {activeTab === 'profile' && <ProfilePage />}
          </motion.div>
        </AnimatePresence>
      </div>
    </PhoneFrame>
  );
}
