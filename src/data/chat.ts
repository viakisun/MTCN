import { faker } from '@faker-js/faker';
import { ChatMessage } from '@/types';
import { generatePlayers } from './players';

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
      type: isCheer ? 'text' : 'text'
    });
  }
  
  return messages.sort((a, b) => new Date(a.timestamp).getTime() - new Date(b.timestamp).getTime());
};
