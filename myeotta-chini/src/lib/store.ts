import { create } from 'zustand';
import { Player, Group, Rounding, ChatMessage, ScoreRecord } from './mock-data';

interface AppState {
  // 현재 활성 탭
  activeTab: string;
  setActiveTab: (tab: string) => void;
  
  // 플레이어 데이터
  players: Player[];
  setPlayers: (players: Player[]) => void;
  updatePlayerPosition: (playerId: string, position: { x: number; y: number }) => void;
  updatePlayerScore: (playerId: string, score: number) => void;
  
  // 그룹 데이터
  groups: Group[];
  setGroups: (groups: Group[]) => void;
  
  // 라운딩 데이터
  roundings: Rounding[];
  setRoundings: (roundings: Rounding[]) => void;
  currentRounding: Rounding | null;
  setCurrentRounding: (rounding: Rounding | null) => void;
  
  // 채팅 데이터
  messages: ChatMessage[];
  setMessages: (messages: ChatMessage[]) => void;
  addMessage: (message: ChatMessage) => void;
  
  // 스코어 데이터
  scoreRecords: ScoreRecord[];
  setScoreRecords: (records: ScoreRecord[]) => void;
  
  // 게임 상태
  isGameActive: boolean;
  setIsGameActive: (active: boolean) => void;
  currentHole: number;
  setCurrentHole: (hole: number) => void;
  
  // 관중 모드
  spectatorMode: boolean;
  setSpectatorMode: (mode: boolean) => void;
  
  // 데모 상태
  isDemoMode: boolean;
  setIsDemoMode: (mode: boolean) => void;
  demoStep: number;
  setDemoStep: (step: number) => void;
}

export const useAppStore = create<AppState>((set, get) => ({
  // 현재 활성 탭
  activeTab: 'home',
  setActiveTab: (tab) => set({ activeTab: tab }),
  
  // 플레이어 데이터
  players: [],
  setPlayers: (players) => set({ players }),
  updatePlayerPosition: (playerId, position) => set((state) => ({
    players: state.players.map(player => 
      player.id === playerId ? { ...player, position } : player
    )
  })),
  updatePlayerScore: (playerId, score) => set((state) => ({
    players: state.players.map(player => 
      player.id === playerId ? { ...player, currentScore: score } : player
    )
  })),
  
  // 그룹 데이터
  groups: [],
  setGroups: (groups) => set({ groups }),
  
  // 라운딩 데이터
  roundings: [],
  setRoundings: (roundings) => set({ roundings }),
  currentRounding: null,
  setCurrentRounding: (rounding) => set({ currentRounding: rounding }),
  
  // 채팅 데이터
  messages: [],
  setMessages: (messages) => set({ messages }),
  addMessage: (message) => set((state) => ({
    messages: [...state.messages, message]
  })),
  
  // 스코어 데이터
  scoreRecords: [],
  setScoreRecords: (records) => set({ scoreRecords: records }),
  
  // 게임 상태
  isGameActive: false,
  setIsGameActive: (active) => set({ isGameActive: active }),
  currentHole: 1,
  setCurrentHole: (hole) => set({ currentHole: hole }),
  
  // 관중 모드
  spectatorMode: false,
  setSpectatorMode: (mode) => set({ spectatorMode: mode }),
  
  // 데모 상태
  isDemoMode: true,
  setIsDemoMode: (mode) => set({ isDemoMode: mode }),
  demoStep: 0,
  setDemoStep: (step) => set({ demoStep: step }),
}));


