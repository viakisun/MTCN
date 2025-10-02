// 날짜 관련 유틸리티
export const dateUtils = {
  // D-Day 계산
  calculateDDay: (targetDate: string): number => {
    const today = new Date();
    const target = new Date(targetDate);
    const diffTime = target.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
    return diffDays;
  },

  // 날짜 포맷팅
  formatDate: (date: string): string => {
    const d = new Date(date);
    return d.toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  },

  // 시간 포맷팅
  formatTime: (time: string): string => {
    return time;
  },

  // 상대 시간 계산
  getRelativeTime: (date: string): string => {
    const now = new Date();
    const target = new Date(date);
    const diffMs = now.getTime() - target.getTime();
    const diffMins = Math.floor(diffMs / (1000 * 60));
    const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

    if (diffMins < 60) return `${diffMins}분 전`;
    if (diffHours < 24) return `${diffHours}시간 전`;
    if (diffDays < 7) return `${diffDays}일 전`;
    return dateUtils.formatDate(date);
  },
};

// 포맷팅 유틸리티
export const formatUtils = {
  // 숫자 천 단위 콤마
  formatNumber: (num: number): string => {
    return num.toLocaleString('ko-KR');
  },

  // 가격 포맷팅
  formatPrice: (price: number): string => {
    return `${price.toLocaleString('ko-KR')}원`;
  },

  // 스코어 포맷팅
  formatScore: (score: number, par: number): string => {
    const diff = score - par;
    if (diff === 0) return 'E';
    if (diff > 0) return `+${diff}`;
    return `${diff}`;
  },

  // 핸디캡 포맷팅
  formatHandicap: (handicap: number): string => {
    return `HCP ${handicap}`;
  },

  // 이름 이니셜 추출
  getInitials: (name: string): string => {
    return name.charAt(0).toUpperCase();
  },

  // 텍스트 자르기
  truncateText: (text: string, maxLength: number): string => {
    if (text.length <= maxLength) return text;
    return `${text.slice(0, maxLength)}...`;
  },

  // 날짜 포맷팅
  formatDate: (dateString: string): string => {
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  },
};

// 배열 유틸리티
export const arrayUtils = {
  // 배열 섞기
  shuffle: <T>(array: T[]): T[] => {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    return shuffled;
  },

  // 배열 그룹화
  groupBy: <T, K extends string | number>(
    array: T[],
    key: (item: T) => K
  ): Record<K, T[]> => {
    return array.reduce((groups, item) => {
      const groupKey = key(item);
      if (!groups[groupKey]) {
        groups[groupKey] = [];
      }
      groups[groupKey].push(item);
      return groups;
    }, {} as Record<K, T[]>);
  },

  // 배열 정렬
  sortBy: <T>(array: T[], key: keyof T, direction: 'asc' | 'desc' = 'asc'): T[] => {
    return [...array].sort((a, b) => {
      const aVal = a[key];
      const bVal = b[key];
      
      if (aVal < bVal) return direction === 'asc' ? -1 : 1;
      if (aVal > bVal) return direction === 'asc' ? 1 : -1;
      return 0;
    });
  },
};

// 객체 유틸리티
export const objectUtils = {
  // 깊은 복사
  deepClone: <T>(obj: T): T => {
    return JSON.parse(JSON.stringify(obj));
  },

  // 객체 병합
  merge: <T extends Record<string, any>>(target: T, source: Partial<T>): T => {
    return { ...target, ...source };
  },

  // 빈 값 체크
  isEmpty: (value: any): boolean => {
    if (value === null || value === undefined) return true;
    if (typeof value === 'string') return value.trim() === '';
    if (Array.isArray(value)) return value.length === 0;
    if (typeof value === 'object') return Object.keys(value).length === 0;
    return false;
  },
};

// 검증 유틸리티
export const validationUtils = {
  // 이메일 검증
  isValidEmail: (email: string): boolean => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
  },

  // 전화번호 검증
  isValidPhone: (phone: string): boolean => {
    const phoneRegex = /^01[0-9]-?[0-9]{4}-?[0-9]{4}$/;
    return phoneRegex.test(phone);
  },

  // 숫자 검증
  isValidNumber: (value: string): boolean => {
    return !isNaN(Number(value)) && isFinite(Number(value));
  },
};
