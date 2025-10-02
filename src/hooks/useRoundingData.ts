import { useMemo } from 'react';
import { useAppStore } from '@/lib/store';
import { RoundingPageData } from '@/types';

export const useRoundingData = (): RoundingPageData => {
  const { roundings } = useAppStore();

  const filters = useMemo(() => ({
    status: ['upcoming', 'in-progress', 'completed'],
    dateRange: ['today', 'week', 'month', 'all']
  }), []);

  return {
    roundings,
    filters
  };
};
