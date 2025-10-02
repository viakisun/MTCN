import { useMemo } from 'react';
import { useAppStore } from '@/lib/store';
import { dateUtils } from '@/utils';
import { HomePageData } from '@/types';

export const useHomeData = (): HomePageData => {
  const { roundings, scoreRecords } = useAppStore();

  const upcomingRounding = useMemo(() => {
    return roundings.find(rounding => rounding.status === 'upcoming') || null;
  }, [roundings]);

  const recentScores = useMemo(() => {
    return scoreRecords.slice(0, 3);
  }, [scoreRecords]);

  const groupActivities = useMemo(() => {
    // 실제로는 그룹 활동 데이터를 가져와야 함
    return [
      {
        id: 'activity-1',
        type: 'score',
        user: '박영호',
        message: '베스트 스코어 달성! 🎉',
        details: '78타 · 레이크사이드 CC · 2시간 전',
        likes: 12,
        comments: 5
      },
      {
        id: 'activity-2',
        type: 'rounding',
        user: '연세대 골프동문회',
        message: '신규 라운딩 2건 등록됨',
        details: '연세대 골프동문회 · 30분 전',
        likes: 8,
        comments: 3
      }
    ];
  }, []);

  return {
    upcomingRounding,
    recentScores,
    groupActivities
  };
};
