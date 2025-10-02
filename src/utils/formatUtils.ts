export const formatUtils = {
  formatNumber: (num: number): string => {
    return num.toLocaleString('ko-KR');
  },

  formatPrice: (price: number): string => {
    return `${price.toLocaleString('ko-KR')}원`;
  },

  formatScore: (score: number, par: number): string => {
    const diff = score - par;
    if (diff === 0) return 'E';
    if (diff < 0) return `${diff}`;
    return `+${diff}`;
  },

  formatHandicap: (handicap: number): string => {
    return `HCP ${handicap}`;
  },

  formatDate: (dateString: string): string => {
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  },

  getInitials: (name: string): string => {
    return name.charAt(0);
  },

  truncateText: (text: string, maxLength: number): string => {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  }
};
