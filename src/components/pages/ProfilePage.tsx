import React, { useState, useMemo } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useProfileData } from '@/hooks';
import { ProfileStatCard, ProfileMenuItem, EmptyState } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import type { ProfileStatCardData } from '@/components/ui/ProfileStatCard';
import type { ProfileMenuItemData } from '@/components/ui/ProfileMenuItem';

const ProfilePage: React.FC = () => {
  const { setActiveTab } = useAppStore();
  
  // 목업 데이터 초기화
  useMockData();
  
  // 프로필 데이터 가져오기
  const { currentUser, statistics, menuItems } = useProfileData();

  // 통계 카드 데이터 생성
  const statCards: ProfileStatCardData[] = useMemo(() => [
    {
      id: 'average-score',
      title: '평균 스코어',
      value: statistics.averageScore,
      unit: '타',
      icon: 'chart',
      color: designTokens.colors.primary[500],
      description: '최근 라운딩 평균',
      trend: 'down',
      trendValue: '-2타'
    },
    {
      id: 'best-score',
      title: '베스트 스코어',
      value: statistics.bestScore,
      unit: '타',
      icon: 'trophy',
      color: designTokens.colors.success[500],
      description: '최고 기록',
      trend: 'stable',
      trendValue: '유지'
    },
    {
      id: 'handicap',
      title: '핸디캡',
      value: statistics.handicap,
      unit: '',
      icon: 'golf-ball',
      color: designTokens.colors.warning[500],
      description: '현재 핸디캡',
      trend: 'up',
      trendValue: '+1.2'
    },
    {
      id: 'total-rounds',
      title: '총 라운딩',
      value: statistics.totalRounds,
      unit: '회',
      icon: 'calendar',
      color: designTokens.colors.info[500],
      description: '완주한 라운딩',
      trend: 'up',
      trendValue: '+3회'
    }
  ], [statistics]);

  // 메뉴 아이템 데이터 생성
  const menuItemsData: ProfileMenuItemData[] = useMemo(() => [
    {
      id: 'edit-profile',
      label: '프로필 편집',
      icon: 'user',
      description: '개인정보 및 프로필 사진 변경',
      color: designTokens.colors.primary[500]
    },
    {
      id: 'settings',
      label: '설정',
      icon: 'golf-ball',
      description: '앱 설정 및 알림 관리',
      color: designTokens.colors.neutral[500]
    },
    {
      id: 'achievements',
      label: '업적',
      icon: 'trophy',
      description: '골프 업적 및 뱃지 확인',
      color: designTokens.colors.warning[500],
      badge: '5'
    },
    {
      id: 'friends',
      label: '친구',
      icon: 'users',
      description: '골프 친구 목록 및 초대',
      color: designTokens.colors.info[500],
      badge: '12'
    },
    {
      id: 'help',
      label: '도움말',
      icon: 'golf-club',
      description: 'FAQ 및 고객지원',
      color: designTokens.colors.neutral[600]
    },
    {
      id: 'about',
      label: '앱 정보',
      icon: 'flag',
      description: '버전 정보 및 라이선스',
      color: designTokens.colors.neutral[500]
    }
  ], []);

  const handleStatClick = (statId: string) => {
    console.log('통계 클릭:', statId);
  };

  const handleMenuClick = (menuId: string) => {
    console.log('메뉴 클릭:', menuId);
  };

  if (!currentUser) {
    return (
      <div 
        className="flex-1 overflow-y-auto scroll-container"
        style={{ 
          padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
          backgroundColor: designTokens.colors.background.light
        }}
      >
        <EmptyState
          icon="user"
          title="사용자 정보를 찾을 수 없습니다"
          description="로그인 후 프로필을 확인하세요"
          action={{
            label: "로그인하기",
            onClick: () => console.log('로그인')
          }}
        />
      </div>
    );
  }

  return (
    <div 
      className="flex-1 overflow-y-auto scroll-container"
      style={{ 
        padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
        backgroundColor: designTokens.colors.background.light
      }}
    >
      {/* 헤더 - 라운딩 페이지와 일관된 스타일 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
          {getIconComponent('profile', { size: 24, color: designTokens.colors.primary[600] })}
          <h1 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0
          }}>
            프로필
          </h1>
        </div>
        <p style={{
          fontSize: designTokens.typography.fontSize.sm,
          color: designTokens.colors.text.secondary,
          margin: 0
        }}>
          나의 골프 프로필과 통계를 확인하세요
        </p>
      </motion.div>

      {/* 사용자 정보 카드 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <div
          style={{
            background: `
              linear-gradient(135deg, 
                rgba(255, 255, 255, 0.98) 0%, 
                rgba(250, 250, 250, 0.95) 100%
              )
            `,
            backdropFilter: 'blur(20px)',
            borderRadius: designTokens.golf.card.borderRadius,
            border: `1px solid rgba(0, 0, 0, 0.08)`,
            boxShadow: `
              0 8px 24px rgba(0, 0, 0, 0.12),
              0 4px 8px rgba(0, 0, 0, 0.08),
              inset 0 1px 0 rgba(255, 255, 255, 0.1)
            `,
            padding: designTokens.golf.card.padding.lg,
            position: 'relative',
            overflow: 'hidden',
            textAlign: 'center',
          }}
        >
          {/* 배경 패턴 */}
          <div style={{
            position: 'absolute',
            top: designTokens.spacing.lg,
            right: designTokens.spacing.xl,
            opacity: 0.1,
            pointerEvents: 'none',
            transform: 'rotate(15deg)'
          }}>
            {getIconComponent('user', { size: 60, color: designTokens.colors.primary[300] })}
          </div>

          <div style={{ position: 'relative', zIndex: 1 }}>
            {/* 프로필 사진 */}
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.3, duration: 0.3 }}
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                width: '80px',
                height: '80px',
                borderRadius: designTokens.borderRadius.full,
                background: `
                  linear-gradient(135deg, 
                    ${designTokens.colors.primary[500]} 0%, 
                    ${designTokens.colors.primary[600]} 50%,
                    ${designTokens.colors.primary[700]} 100%
                  )
                `,
                margin: '0 auto',
                marginBottom: designTokens.spacing.md,
                boxShadow: `
                  0 8px 16px ${designTokens.colors.primary[500]}40,
                  0 4px 8px rgba(0, 0, 0, 0.1),
                  inset 0 1px 0 rgba(255, 255, 255, 0.2)
                `,
              }}
            >
              {getIconComponent('user', { size: 40, color: designTokens.colors.neutral[0] })}
            </motion.div>

            {/* 사용자 이름 */}
            <h2 style={{
              fontSize: designTokens.typography.fontSize.xl,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0,
              marginBottom: designTokens.spacing.xs,
            }}>
              {currentUser.name}
            </h2>

            {/* 가입일 */}
            <p style={{
              fontSize: designTokens.typography.fontSize.sm,
              color: designTokens.colors.text.secondary,
              margin: 0,
              lineHeight: designTokens.typography.lineHeight.relaxed,
            }}>
              {statistics.joinDate} 가입
            </p>
          </div>
        </div>
      </motion.div>

      {/* 통계 카드 그리드 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3, duration: 0.5 }}
        style={{ 
          display: 'grid',
          gridTemplateColumns: 'repeat(2, 1fr)',
          gap: designTokens.spacing.md,
          marginBottom: designTokens.spacing.lg
        }}
      >
        {statCards.map((stat, index) => (
          <ProfileStatCard
            key={stat.id}
            data={stat}
            onClick={() => handleStatClick(stat.id)}
          />
        ))}
      </motion.div>

      {/* 메뉴 섹션 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <h3 style={{
          fontSize: designTokens.typography.fontSize.lg,
          fontWeight: designTokens.typography.fontWeight.semibold,
          color: designTokens.colors.text.primary,
          marginBottom: designTokens.spacing.md,
        }}>
          설정 및 도구
        </h3>
        
        <div style={{ 
          display: 'flex', 
          flexDirection: 'column', 
          gap: designTokens.spacing.md 
        }}>
          {menuItemsData.map((menuItem, index) => (
            <ProfileMenuItem
              key={menuItem.id}
              data={menuItem}
              onClick={() => handleMenuClick(menuItem.id)}
            />
          ))}
        </div>
      </motion.div>

      {/* 로그아웃 버튼 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.5, duration: 0.5 }}
        style={{ marginTop: designTokens.spacing['3xl'] }}
      >
        <motion.div 
          style={{
            background: `
              linear-gradient(135deg, 
                rgba(255, 255, 255, 0.98) 0%, 
                rgba(250, 250, 250, 0.95) 100%
              )
            `,
            backdropFilter: 'blur(20px)',
            borderRadius: designTokens.golf.card.borderRadius,
            border: `1px solid rgba(0, 0, 0, 0.08)`,
            boxShadow: `
              0 8px 24px rgba(0, 0, 0, 0.12),
              0 4px 8px rgba(0, 0, 0, 0.08),
              inset 0 1px 0 rgba(255, 255, 255, 0.1)
            `,
            padding: designTokens.golf.card.padding.lg,
            position: 'relative',
            overflow: 'hidden',
            cursor: 'pointer',
            textAlign: 'center',
          }}
          whileHover={{ 
            y: -4,
            scale: 1.02,
            boxShadow: `
              0 12px 32px rgba(0, 0, 0, 0.16),
              0 6px 12px rgba(0, 0, 0, 0.12),
              inset 0 1px 0 rgba(255, 255, 255, 0.15)
            `,
            transition: { duration: 0.3, ease: "easeOut" }
          }}
          whileTap={{ 
            scale: 0.98,
            transition: { duration: 0.1 }
          }}
          onClick={() => console.log('로그아웃')}
        >
          {/* 배경 패턴 */}
          <div style={{
            position: 'absolute',
            top: designTokens.spacing.lg,
            right: designTokens.spacing.xl,
            opacity: 0.1,
            pointerEvents: 'none',
            transform: 'rotate(15deg)'
          }}>
            {getIconComponent('golf-club', { size: 60, color: designTokens.colors.error[500] })}
          </div>

          <div style={{ position: 'relative', zIndex: 1 }}>
            {/* 아이콘 */}
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.2, duration: 0.3 }}
              style={{
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                width: '64px',
                height: '64px',
                borderRadius: designTokens.borderRadius.full,
                background: `
                  linear-gradient(135deg, 
                    ${designTokens.colors.error[500]} 0%, 
                    ${designTokens.colors.error[600]} 50%,
                    ${designTokens.colors.error[700]} 100%
                  )
                `,
                margin: '0 auto',
                marginBottom: designTokens.spacing.lg,
                boxShadow: `
                  0 8px 16px ${designTokens.colors.error[500]}40,
                  0 4px 8px rgba(0, 0, 0, 0.1),
                  inset 0 1px 0 rgba(255, 255, 255, 0.2)
                `,
              }}
            >
              {getIconComponent('golf-club', { size: 32, color: designTokens.colors.neutral[0] })}
            </motion.div>

            {/* 제목 */}
            <h3 style={{
              fontSize: designTokens.typography.fontSize.xl,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0,
              marginBottom: designTokens.spacing.sm,
            }}>
              로그아웃
            </h3>

            {/* 설명 */}
            <p style={{
              fontSize: designTokens.typography.fontSize.sm,
              color: designTokens.colors.text.secondary,
              margin: 0,
              lineHeight: designTokens.typography.lineHeight.relaxed,
            }}>
              계정에서 로그아웃합니다
            </p>
          </div>
        </motion.div>
      </motion.div>
    </div>
  );
};

export default ProfilePage;