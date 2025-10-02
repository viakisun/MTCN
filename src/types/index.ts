// 공통 타입 정의
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

export interface Rounding {
  id: string;
  courseName: string;
  eventName: string; // 이벤트/대회명 추가
  date: string;
  time: string;
  status: 'upcoming' | 'in-progress' | 'completed';
  greenFee: number;
  weather: string;
  temperature: number;
  players: Player[];
  holes: number; // 홀 수 추가
  description?: string;
  currentHole?: number;
  totalHoles?: number;
  notice?: string; // 주의사항 추가
}

export interface Group {
  id: string;
  name: string;
  description: string;
  school: string;
  graduationYear: string;
  memberCount: number;
  recentActivity: string;
  lastActivityDate: string;
  members: Array<{
    id: string;
    name: string;
    avatar?: string;
  }>;
  status: 'active' | 'inactive' | 'new';
  isJoined: boolean;
  avatar?: string;
  isActive?: boolean;
  lastMessage?: string;
  lastMessageTime?: string;
  unreadCount?: number;
}

export interface ChatMessage {
  id: string;
  senderId: string;
  senderName: string;
  content: string;
  timestamp: string;
  type: 'text' | 'image' | 'system';
}

export interface ScoreRecord {
  id: string;
  courseName: string;
  date: string;
  totalScore: number;
  par: number;
  birdies: number;
  eagles?: number;
  pars?: number;
  bogeys: number;
  doubleBogeys?: number;
  holes?: number[];
}

// UI 관련 타입
export interface BadgeProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'success' | 'warning' | 'danger';
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline' | 'ghost' | 'text';
  size?: 'sm' | 'md' | 'lg';
  onClick?: (e?: React.MouseEvent) => void;
  disabled?: boolean;
  className?: string;
  style?: React.CSSProperties;
}

export interface CardProps {
  children: React.ReactNode;
  variant?: 'default' | 'elevated' | 'outlined' | 'filled';
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
  className?: string;
  onClick?: () => void;
  hover?: boolean;
  style?: React.CSSProperties;
}

export interface AvatarProps {
  name: string;
  avatar?: string;
  size?: 'sm' | 'md' | 'lg';
  className?: string;
}

export interface StatCardProps {
  title: string;
  value: string | number;
  unit?: string;
  className?: string;
}

// 페이지별 데이터 타입
export interface HomePageData {
  upcomingRounding: Rounding | null;
  recentScores: ScoreRecord[];
  groupActivities: any[];
}

export interface RoundingPageData {
  roundings: Rounding[];
  filters: {
    status: string[];
    dateRange: string[];
  };
}

export interface GroupsPageData {
  groups: Group[];
  selectedGroup: Group | null;
  chatMessages: ChatMessage[];
}

export interface ScorePageData {
  scoreRecords: ScoreRecord[];
  statistics: {
    averageScore: number;
    bestScore: number;
    totalRounds: number;
    birdies: number;
    pars: number;
    bogeys: number;
  };
  recentScores: ScoreRecord[];
}

export interface ProfilePageData {
  currentUser: Player | null;
  statistics: {
    averageScore: number;
    bestScore: number;
    handicap: number;
    totalRounds: number;
    joinDate: string;
  };
  menuItems: Array<{
    id: string;
    label: string;
    icon: string;
    onClick: () => void;
  }>;
}
