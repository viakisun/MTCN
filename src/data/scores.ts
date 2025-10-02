import { faker } from '@faker-js/faker';
import { ScoreRecord } from '@/types';

// 골프장 이름 생성
const generateGolfCourseName = (): string => {
  const prefixes = ['스카이', '레이크', '그린', '마운틴', '오션', '파인', '골든', '로얄', '프리미엄', '엘리트'];
  const suffixes = ['골프클럽', '컨트리클럽', '골프장', '리조트', 'CC', '골프센터'];
  
  return `${faker.helpers.arrayElement(prefixes)}${faker.helpers.arrayElement(['72', '힐', '밸리', '뷰', '사이드', '파크'])} ${faker.helpers.arrayElement(suffixes)}`;
};

// 스코어 기록 생성
export const generateScoreRecords = (): ScoreRecord[] => {
  const records: ScoreRecord[] = [];
  
  for (let i = 0; i < 24; i++) {
    const totalScore = faker.number.int({ min: 70, max: 100 });
    const par = 72;
    const birdies = faker.number.int({ min: 0, max: 5 });
    const eagles = faker.number.int({ min: 0, max: 2 });
    const bogeys = faker.number.int({ min: 0, max: 8 });
    const doubleBogeys = faker.number.int({ min: 0, max: 3 });
    
    records.push({
      id: `score-${i + 1}`,
      courseName: generateGolfCourseName(),
      date: faker.date.recent({ days: 365 }).toISOString().split('T')[0],
      totalScore,
      par,
      birdies,
      eagles,
      bogeys,
      doubleBogeys
    });
  }
  
  return records.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
};
