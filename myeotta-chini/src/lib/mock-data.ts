import { faker } from '@faker-js/faker';

// 한국어 로케일 설정 (최신 버전에서는 자동으로 한국어 지원)
// faker는 기본적으로 영어를 사용하므로 한국어 이름은 수동으로 생성

export interface Player {
  id: string;
  name: string;
  firstName: string;
  lastName: string;
  averageScore: number;
  bestScore: number;
  handicap: number;
  avatar: string;
  currentHole?: number;
  currentScore?: number;
  position?: { x: number; y: number };
  isPlaying?: boolean;
}

export interface Group {
  id: string;
  name: string;
  description: string;
  memberCount: number;
  isActive: boolean;
  lastMessage?: string;
  lastMessageTime?: string;
  unreadCount?: number;
}

export interface Rounding {
  id: string;
  courseName: string;
  date: string;
  time: string;
  players: Player[];
  status: 'upcoming' | 'in-progress' | 'completed';
  weather: string;
  temperature: number;
  greenFee: number;
  currentHole?: number;
  totalHoles: number;
}

export interface ChatMessage {
  id: string;
  senderId: string;
  senderName: string;
  content: string;
  timestamp: string;
  type: 'text' | 'emoji' | 'cheer';
}

export interface ScoreRecord {
  id: string;
  courseName: string;
  date: string;
  totalScore: number;
  par: number;
  birdies: number;
  pars: number;
  bogeys: number;
  holes: number[];
}

// 한국 이름 생성 함수
const generateKoreanName = (): { firstName: string; lastName: string } => {
  const lastNames = ['김', '이', '박', '최', '정', '강', '조', '윤', '장', '임', '한', '오', '서', '신', '권', '황', '안', '송', '전', '고'];
  const firstNames = [
    '철수', '영희', '민수', '지영', '현우', '수진', '동현', '미영', '준호', '은지',
    '성민', '혜진', '재현', '지현', '민호', '예진', '태현', '지은', '준영', '서연',
    '현수', '지민', '동욱', '유진', '성호', '민정', '재욱', '지혜', '태호', '서영'
  ];
  
  return {
    lastName: faker.helpers.arrayElement(lastNames),
    firstName: faker.helpers.arrayElement(firstNames)
  };
};

// 골프장 이름 생성
const generateGolfCourseName = (): string => {
  const prefixes = ['스카이', '레이크', '그린', '마운틴', '오션', '파인', '골든', '로얄', '프리미엄', '엘리트'];
  const suffixes = ['골프클럽', '컨트리클럽', '골프장', '리조트', 'CC', '골프센터'];
  
  return `${faker.helpers.arrayElement(prefixes)}${faker.helpers.arrayElement(['72', '힐', '밸리', '뷰', '사이드', '파크'])} ${faker.helpers.arrayElement(suffixes)}`;
};

// 플레이어 생성
export const generatePlayers = (count: number): Player[] => {
  return Array.from({ length: count }, (_, index) => {
    const { firstName, lastName } = generateKoreanName();
    const name = `${lastName}${firstName}`;
    
    return {
      id: `player-${index + 1}`,
      name,
      firstName,
      lastName,
      averageScore: faker.number.int({ min: 75, max: 110 }),
      bestScore: faker.number.int({ min: 70, max: 95 }),
      handicap: faker.number.int({ min: 5, max: 25 }),
      avatar: lastName,
      currentHole: faker.number.int({ min: 1, max: 18 }),
      currentScore: faker.number.int({ min: 70, max: 100 }),
      position: {
        x: faker.number.float({ min: 0, max: 100 }),
        y: faker.number.float({ min: 0, max: 100 })
      },
      isPlaying: faker.datatype.boolean()
    };
  });
};

// 그룹 생성
export const generateGroups = (): Group[] => {
  const groups = [
    {
      id: 'group-1',
      name: '서울대 경영 85',
      description: '서울대학교 경영학과 85학번 동문회',
      memberCount: 1000,
      isActive: true,
      lastMessage: '내일 라운딩 참가하시는 분들 확인해주세요!',
      lastMessageTime: '2시간 전',
      unreadCount: 3
    },
    {
      id: 'group-2',
      name: '연세대 골프동문회',
      description: '연세대학교 골프 동문회',
      memberCount: 500,
      isActive: true,
      lastMessage: '신규 라운딩 2건 등록됨',
      lastMessageTime: '30분 전',
      unreadCount: 1
    },
    {
      id: 'group-3',
      name: '고려대 골프클럽',
      description: '고려대학교 골프클럽',
      memberCount: 300,
      isActive: false,
      lastMessage: '다음 주 정기 라운딩 안내',
      lastMessageTime: '1일 전',
      unreadCount: 0
    }
  ];
  
  return groups;
};

// 라운딩 생성
export const generateRoundings = (): Rounding[] => {
  const players = generatePlayers(4);
  
  return [
    {
      id: 'round-1',
      courseName: '레이크사이드 골프클럽',
      date: '2025-01-28',
      time: '14:00',
      players,
      status: 'upcoming',
      weather: '☀️ 맑음',
      temperature: 22,
      greenFee: 120000,
      totalHoles: 18
    },
    {
      id: 'round-2',
      courseName: '스카이72 골프클럽',
      date: '2025-01-29',
      time: '07:00',
      players: generatePlayers(16), // 4개 조
      status: 'in-progress',
      weather: '⛅ 흐림',
      temperature: 18,
      greenFee: 150000,
      currentHole: 5,
      totalHoles: 18
    }
  ];
};

// 채팅 메시지 생성
export const generateChatMessages = (): ChatMessage[] => {
  const players = generatePlayers(10);
  const messages: ChatMessage[] = [];
  
  const cheerMessages = [
    '화이팅! 💪',
    '좋은 샷! 👏',
    '버디 기원! 🍀',
    '파 세이브! 🎯',
    '이글 기원! 🦅',
    '멋진 샷! ⭐',
    '파워 샷! 💥',
    '정확한 샷! 🎪'
  ];
  
  for (let i = 0; i < 20; i++) {
    const player = faker.helpers.arrayElement(players);
    const isCheer = faker.datatype.boolean({ probability: 0.3 });
    
    messages.push({
      id: `msg-${i + 1}`,
      senderId: player.id,
      senderName: player.name,
      content: isCheer 
        ? faker.helpers.arrayElement(cheerMessages)
        : faker.lorem.sentence({ min: 3, max: 8 }),
      timestamp: faker.date.recent({ days: 1 }).toISOString(),
      type: isCheer ? 'cheer' : 'text'
    });
  }
  
  return messages.sort((a, b) => new Date(a.timestamp).getTime() - new Date(b.timestamp).getTime());
};

// 스코어 기록 생성
export const generateScoreRecords = (): ScoreRecord[] => {
  const records: ScoreRecord[] = [];
  
  for (let i = 0; i < 24; i++) {
    const totalScore = faker.number.int({ min: 70, max: 100 });
    const par = 72;
    const birdies = faker.number.int({ min: 0, max: 5 });
    const pars = faker.number.int({ min: 8, max: 15 });
    const bogeys = faker.number.int({ min: 0, max: 8 });
    
    // 홀별 스코어 생성 (18홀)
    const holes = Array.from({ length: 18 }, () => faker.number.int({ min: 3, max: 7 }));
    
    records.push({
      id: `score-${i + 1}`,
      courseName: generateGolfCourseName(),
      date: faker.date.recent({ days: 365 }).toISOString().split('T')[0],
      totalScore,
      par,
      birdies,
      pars,
      bogeys,
      holes
    });
  }
  
  return records.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
};

// 현재 사용자 정보
export const currentUser: Player = {
  id: 'current-user',
  name: '김철수',
  firstName: '철수',
  lastName: '김',
  averageScore: 92,
  bestScore: 85,
  handicap: 18,
  avatar: '김',
  isPlaying: true
};

// 골프장 지도 데이터 (스카이72 골프장)
export const golfCourseMap = {
  id: 'sky72',
  name: '스카이72 골프클럽',
  holes: Array.from({ length: 18 }, (_, index) => ({
    id: index + 1,
    par: [4, 3, 5, 4, 3, 4, 5, 3, 4, 4, 3, 5, 4, 4, 3, 5, 3, 4][index],
    position: {
      x: faker.number.float({ min: 10, max: 90 }),
      y: faker.number.float({ min: 10, max: 90 })
    },
    teeBox: {
      x: faker.number.float({ min: 10, max: 90 }),
      y: faker.number.float({ min: 10, max: 90 })
    },
    green: {
      x: faker.number.float({ min: 10, max: 90 }),
      y: faker.number.float({ min: 10, max: 90 })
    }
  }))
};

