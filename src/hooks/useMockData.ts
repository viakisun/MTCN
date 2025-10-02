import { useEffect } from 'react';
import { useAppStore } from '@/lib/store';
import { 
  generateRoundings, 
  generateGroups, 
  generateScoreRecords,
  generateChatMessages 
} from '@/data';

export const useMockData = () => {
  const { 
    setRoundings, 
    setGroups, 
    setScoreRecords,
    setChatMessages
  } = useAppStore();

  useEffect(() => {
    // 목업 데이터 초기화
    setRoundings(generateRoundings());
    setGroups(generateGroups());
    setScoreRecords(generateScoreRecords());
    setChatMessages(generateChatMessages());
  }, [setRoundings, setGroups, setScoreRecords, setChatMessages]);

  return {
    // 데이터가 초기화되었는지 확인하는 플래그
    isInitialized: true
  };
};
