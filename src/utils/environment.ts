// 환경 감지 유틸리티
export const isProduction = import.meta.env.PROD;
export const isDevelopment = import.meta.env.DEV;
export const isGitHubPages = typeof window !== 'undefined' && window.location.hostname === 'viakisun.github.io';

// 배포 환경에서는 iPhone 프레임을 사용하지 않음
export const shouldUsePhoneFrame = isDevelopment && !isGitHubPages;
