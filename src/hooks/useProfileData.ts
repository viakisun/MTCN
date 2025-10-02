import { useMemo } from 'react';
import { useAppStore } from '@/lib/store';
import { ProfilePageData } from '@/types';
import { currentUser } from '@/data/players';

export const useProfileData = (): ProfilePageData => {
  const { players, scoreRecords } = useAppStore();

  // currentUser는 별도로 정의된 사용자 정보 사용
  const user = useMemo(() => {
    return currentUser;
  }, []);

  const statistics = useMemo(() => {
    if (!user || scoreRecords.length === 0) {
      return {
        averageScore: user?.averageScore || 0,
        bestScore: user?.bestScore || 0,
        handicap: user?.handicap || 0,
        totalRounds: 0,
        joinDate: '2024-01-01'
      };
    }

    const totalScore = scoreRecords.reduce((sum, record) => sum + record.totalScore, 0);
    const averageScore = Math.round(totalScore / scoreRecords.length);
    const bestScore = Math.min(...scoreRecords.map(record => record.totalScore));

    return {
      averageScore,
      bestScore,
      handicap: user.handicap,
      totalRounds: scoreRecords.length,
      joinDate: '2024-01-01' // 실제로는 사용자 가입일을 가져와야 함
    };
  }, [user, scoreRecords]);

  const menuItems = useMemo(() => [
    { id: 'settings', label: '설정', icon: '⚙️', onClick: () => console.log('설정') },
    { id: 'notifications', label: '알림 설정', icon: '🔔', onClick: () => console.log('알림 설정') },
    { id: 'privacy', label: '개인정보 보호', icon: '🔒', onClick: () => console.log('개인정보 보호') },
    { id: 'help', label: '도움말', icon: '❓', onClick: () => console.log('도움말') },
    { id: 'about', label: '앱 정보', icon: 'ℹ️', onClick: () => console.log('앱 정보') },
    { id: 'logout', label: '로그아웃', icon: '🚪', onClick: () => console.log('로그아웃') }
  ], []);

  return {
    currentUser: user,
    statistics,
    menuItems
  };
};
