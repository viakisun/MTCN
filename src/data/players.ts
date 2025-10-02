import { faker } from '@faker-js/faker';
import { Player } from '@/types';

// 안정적인 아바타 URL 생성 함수
const generateStableAvatar = (seed?: string): string => {
  // 다양한 안정적인 아바타 서비스 사용
  const avatarServices = [
    `https://api.dicebear.com/7.x/avataaars/svg?seed=${seed || faker.string.alphanumeric(8)}`,
    `https://api.dicebear.com/7.x/personas/svg?seed=${seed || faker.string.alphanumeric(8)}`,
    `https://api.dicebear.com/7.x/initials/svg?seed=${seed || faker.string.alphanumeric(8)}`,
    `https://ui-avatars.com/api/?name=${encodeURIComponent(seed || faker.string.alphanumeric(8))}&background=random&color=fff&size=128`,
    `https://robohash.org/${seed || faker.string.alphanumeric(8)}?set=set1&size=128x128`,
    `https://robohash.org/${seed || faker.string.alphanumeric(8)}?set=set2&size=128x128`,
    `https://robohash.org/${seed || faker.string.alphanumeric(8)}?set=set3&size=128x128`,
  ];
  
  return faker.helpers.arrayElement(avatarServices);
};

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
      avatar: generateStableAvatar(name), // 안정적인 아바타 URL 사용
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

// 현재 사용자 정보
export const currentUser: Player = {
  id: 'current-user',
  name: '김철수',
  firstName: '철수',
  lastName: '김',
  averageScore: 92,
  bestScore: 85,
  handicap: 18,
  avatar: generateStableAvatar('김철수'), // 안정적인 아바타 URL 사용
  currentHole: 1,
  currentScore: 0,
  position: { x: 0, y: 0 },
  isPlaying: false
};
