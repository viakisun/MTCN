// 모든 데이터 생성 함수들을 통합하여 export
export { generatePlayers, currentUser } from './players';
export { generateRoundings, golfCourseMap } from './roundings';
export { generateGroups } from './groups';
export { generateScoreRecords } from './scores';
export { generateChatMessages } from './chat';

// 타입들도 함께 export
export type {
  Player,
  Rounding,
  Group,
  ChatMessage,
  ScoreRecord,
  HomePageData,
  RoundingPageData,
  GroupsPageData,
  ScorePageData,
  ProfilePageData
} from '@/types';
