import { useMemo } from 'react';
import { useAppStore } from '@/lib/store';
import { ScorePageData } from '@/types';

export const useScoreData = (): ScorePageData => {
  const { scoreRecords } = useAppStore();

  const statistics = useMemo(() => {
    if (scoreRecords.length === 0) {
      return {
        averageScore: 0,
        bestScore: 0,
        totalRounds: 0,
        birdies: 0,
        pars: 0,
        bogeys: 0
      };
    }

    const totalScore = scoreRecords.reduce((sum, record) => sum + record.totalScore, 0);
    const averageScore = Math.round(totalScore / scoreRecords.length);
    const bestScore = Math.min(...scoreRecords.map(record => record.totalScore));
    const totalBirdies = scoreRecords.reduce((sum, record) => sum + (record.birdies || 0), 0);
    const totalPars = scoreRecords.reduce((sum, record) => sum + (record.pars || 0), 0);
    const totalBogeys = scoreRecords.reduce((sum, record) => sum + (record.bogeys || 0), 0);

    return {
      averageScore,
      bestScore,
      totalRounds: scoreRecords.length,
      birdies: totalBirdies,
      pars: totalPars,
      bogeys: totalBogeys
    };
  }, [scoreRecords]);

  const recentScores = useMemo(() => {
    return scoreRecords.slice(0, 10); // 최근 10개
  }, [scoreRecords]);

  return {
    scoreRecords,
    statistics,
    recentScores
  };
};
