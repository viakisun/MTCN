import { Group } from '@/types';

// 안정적인 아바타 URL 생성 함수
const generateStableAvatar = (seed?: string): string => {
  const avatarServices = [
    `https://api.dicebear.com/7.x/avataaars/svg?seed=${seed || 'default'}`,
    `https://api.dicebear.com/7.x/personas/svg?seed=${seed || 'default'}`,
    `https://api.dicebear.com/7.x/initials/svg?seed=${seed || 'default'}`,
    `https://ui-avatars.com/api/?name=${encodeURIComponent(seed || 'User')}&background=random&color=fff&size=128`,
    `https://robohash.org/${seed || 'default'}?set=set1&size=128x128`,
  ];
  
  return avatarServices[Math.floor(Math.random() * avatarServices.length)];
};

// 그룹 생성
export const generateGroups = (): Group[] => {
  return [
    {
      id: 'group-1',
      name: '서울대 경영 85',
      description: '서울대학교 경영학과 85학번 동문회',
      school: '서울대학교',
      graduationYear: '85',
      memberCount: 1000,
      recentActivity: '내일 라운딩 참가하시는 분들 확인해주세요!',
      lastActivityDate: '2시간 전',
      members: [
        { id: 'member-1', name: '김회장', avatar: generateStableAvatar('김회장') },
        { id: 'member-2', name: '이부회장', avatar: generateStableAvatar('이부회장') },
        { id: 'member-3', name: '박총무', avatar: generateStableAvatar('박총무') },
        { id: 'member-4', name: '최회원', avatar: generateStableAvatar('최회원') }
      ],
      status: 'active',
      isJoined: true,
      avatar: '🏫'
    },
    {
      id: 'group-2',
      name: '연세대 골프동문회',
      description: '연세대학교 골프 동문회',
      school: '연세대학교',
      graduationYear: '90',
      memberCount: 500,
      recentActivity: '신규 라운딩 2건 등록됨',
      lastActivityDate: '30분 전',
      members: [
        { id: 'member-5', name: '정회장', avatar: generateStableAvatar('정회장') },
        { id: 'member-6', name: '강부회장', avatar: generateStableAvatar('강부회장') },
        { id: 'member-7', name: '윤총무', avatar: generateStableAvatar('윤총무') }
      ],
      status: 'active',
      isJoined: true,
      avatar: '🎓'
    },
    {
      id: 'group-3',
      name: '고려대 골프클럽',
      description: '고려대학교 골프클럽',
      school: '고려대학교',
      graduationYear: '88',
      memberCount: 300,
      recentActivity: '다음 주 정기 라운딩 안내',
      lastActivityDate: '1일 전',
      members: [
        { id: 'member-8', name: '조회장', avatar: generateStableAvatar('조회장') },
        { id: 'member-9', name: '한부회장', avatar: generateStableAvatar('한부회장') }
      ],
      status: 'inactive',
      isJoined: false,
      avatar: '🏛️'
    },
    {
      id: 'group-4',
      name: '삼성전자 골프동호회',
      description: '삼성전자 직원 골프 동호회',
      school: '삼성전자',
      graduationYear: '00',
      memberCount: 200,
      recentActivity: '신입사원 환영 라운딩',
      lastActivityDate: '3일 전',
      members: [
        { id: 'member-10', name: '임회장', avatar: generateStableAvatar('임회장') },
        { id: 'member-11', name: '서부회장', avatar: generateStableAvatar('서부회장') },
        { id: 'member-12', name: '노총무', avatar: generateStableAvatar('노총무') },
        { id: 'member-13', name: '백회원', avatar: generateStableAvatar('백회원') }
      ],
      status: 'active',
      isJoined: true,
      avatar: '🏢'
    },
    {
      id: 'group-5',
      name: '강남 골프클럽',
      description: '강남 지역 골프클럽',
      school: '강남구',
      graduationYear: '15',
      memberCount: 150,
      recentActivity: '주말 라운딩 모집',
      lastActivityDate: '5일 전',
      members: [
        { id: 'member-14', name: '송회장', avatar: generateStableAvatar('송회장') },
        { id: 'member-15', name: '유부회장', avatar: generateStableAvatar('유부회장') }
      ],
      status: 'new',
      isJoined: false,
      avatar: '🏌️'
    }
  ];
};
