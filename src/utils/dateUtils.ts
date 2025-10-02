export const dateUtils = {
  // D-Day 계산
  calculateDDay: (targetDate: string): number => {
    const today = new Date();
    today.setHours(0, 0, 0, 0); // 오늘 날짜의 시작 시간으로 설정

    const target = new Date(targetDate);
    target.setHours(0, 0, 0, 0); // 목표 날짜의 시작 시간으로 설정

    const diffTime = target.getTime() - today.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    return diffDays;
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

  // 시간 포맷팅
  formatTime: (timeString: string): string => {
    return timeString;
  },

  // 상대 시간 계산
  getRelativeTime: (dateString: string): string => {
    const now = new Date();
    const target = new Date(dateString);
    const diffMs = now.getTime() - target.getTime();
    const diffMins = Math.floor(diffMs / (1000 * 60));
    const diffHours = Math.floor(diffMs / (1000 * 60 * 60));
    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24));

    if (diffMins < 60) return `${diffMins}분 전`;
    if (diffHours < 24) return `${diffHours}시간 전`;
    if (diffDays < 7) return `${diffDays}일 전`;
    return dateUtils.formatDate(dateString);
  },

  // 날짜 비교
  isToday: (dateString: string): boolean => {
    const today = new Date();
    const target = new Date(dateString);
    return today.toDateString() === target.toDateString();
  },

  // 날짜가 과거인지 확인
  isPast: (dateString: string): boolean => {
    const today = new Date();
    const target = new Date(dateString);
    return target < today;
  },

  // 날짜가 미래인지 확인
  isFuture: (dateString: string): boolean => {
    const today = new Date();
    const target = new Date(dateString);
    return target > today;
  },

  // 날짜 범위 확인
  isInRange: (dateString: string, startDate: string, endDate: string): boolean => {
    const date = new Date(dateString);
    const start = new Date(startDate);
    const end = new Date(endDate);
    return date >= start && date <= end;
  },

  // 월별 날짜 그룹화
  groupByMonth: (dates: string[]): Record<string, string[]> => {
    return dates.reduce((groups, date) => {
      const month = new Date(date).toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: 'long'
      });
      if (!groups[month]) {
        groups[month] = [];
      }
      groups[month].push(date);
      return groups;
    }, {} as Record<string, string[]>);
  },

  // 주별 날짜 그룹화
  groupByWeek: (dates: string[]): Record<string, string[]> => {
    return dates.reduce((groups, date) => {
      const weekStart = new Date(date);
      weekStart.setDate(weekStart.getDate() - weekStart.getDay());
      const weekKey = weekStart.toLocaleDateString('ko-KR');
      
      if (!groups[weekKey]) {
        groups[weekKey] = [];
      }
      groups[weekKey].push(date);
      return groups;
    }, {} as Record<string, string[]>);
  }
};
