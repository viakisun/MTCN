import { faker } from '@faker-js/faker';
import { Rounding, Player } from '@/types';
import { generatePlayers } from './players';

// 골프장 이름 생성
const generateGolfCourseName = (): string => {
  const prefixes = ['스카이', '레이크', '그린', '마운틴', '오션', '파인', '골든', '로얄', '프리미엄', '엘리트'];
  const suffixes = ['골프클럽', '컨트리클럽', '골프장', '리조트', 'CC', '골프센터'];
  
  return `${faker.helpers.arrayElement(prefixes)}${faker.helpers.arrayElement(['72', '힐', '밸리', '뷰', '사이드', '파크'])} ${faker.helpers.arrayElement(suffixes)}`;
};

// 라운딩 생성
export const generateRoundings = (): Rounding[] => {
  const players = generatePlayers(4);
  
  return [
    {
      id: 'round-1',
      courseName: '레이크사이드 골프클럽',
      eventName: '94 전주여고동창회 가을 라운딩',
      date: '2025-01-28',
      time: '14:00',
      players,
      status: 'upcoming',
      weather: 'sunny',
      temperature: 22,
      greenFee: 120000,
      holes: 18,
      description: '94 전주여고동창회 가을 라운딩 - 18홀',
      notice: '경기장 입장은 경기 당일 오전 8시부터 가능해요'
    },
    {
      id: 'round-2',
      courseName: '스카이72 골프클럽',
      eventName: '서울대학교 89학번 동문회 정기 라운딩',
      date: '2025-01-29',
      time: '07:00',
      players: generatePlayers(16), // 4개 조
      status: 'in-progress',
      weather: 'cloudy',
      temperature: 18,
      greenFee: 150000,
      holes: 18,
      description: '서울대학교 89학번 동문회 정기 라운딩 - 18홀'
    },
    {
      id: 'round-3',
      courseName: '그린힐 컨트리클럽',
      eventName: '부산대학교 92학번 동문회 봄 라운딩',
      date: '2025-01-25',
      time: '10:00',
      players: generatePlayers(8),
      status: 'completed',
      weather: 'sunny',
      temperature: 25,
      greenFee: 100000,
      holes: 18,
      description: '부산대학교 92학번 동문회 봄 라운딩'
    },
    {
      id: 'round-4',
      courseName: '오션힐 골프클럽',
      eventName: '연세대학교 95학번 동문회 여름 라운딩',
      date: '2025-02-05',
      time: '08:30',
      players: generatePlayers(12),
      status: 'upcoming',
      weather: 'sunny',
      temperature: 28,
      greenFee: 180000,
      holes: 18,
      description: '연세대학교 95학번 동문회 여름 라운딩',
      notice: '조기 출발로 오전 7시까지 집합'
    },
    {
      id: 'round-5',
      courseName: '골든밸리 컨트리클럽',
      eventName: '고려대학교 88학번 동문회 가을 대회',
      date: '2025-02-12',
      time: '09:00',
      players: generatePlayers(20),
      status: 'upcoming',
      weather: 'cloudy',
      temperature: 20,
      greenFee: 200000,
      holes: 18,
      description: '고려대학교 88학번 동문회 가을 대회',
      notice: '대회 참가비 별도 (15만원)'
    },
    {
      id: 'round-6',
      courseName: '마운틴뷰 골프장',
      eventName: '이화여자대학교 90학번 동문회 겨울 라운딩',
      date: '2025-01-20',
      time: '11:00',
      players: generatePlayers(6),
      status: 'completed',
      weather: 'rainy',
      temperature: 15,
      greenFee: 90000,
      holes: 18,
      description: '이화여자대학교 90학번 동문회 겨울 라운딩'
    }
  ];
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
