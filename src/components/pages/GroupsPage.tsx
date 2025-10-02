import React, { useState, useMemo } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useGroupData } from '@/hooks';
import { GroupCard, EmptyState, GroupFilter } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import type { GroupFilterOption } from '@/components/ui/GroupFilter';
import type { GroupCardData } from '@/components/ui/GroupCard';

const GroupsPage: React.FC = () => {
  const { setActiveTab } = useAppStore();
  
  // 목업 데이터 초기화
  useMockData();
  
  // 그룹 데이터 가져오기
  const { groups } = useGroupData();

  // 필터링 상태
  const [activeFilter, setActiveFilter] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  // 필터 옵션 생성
  const filterOptions: GroupFilterOption[] = useMemo(() => {
    const allCount = groups.length;
    const activeCount = groups.filter(g => g.status === 'active').length;
    const inactiveCount = groups.filter(g => g.status === 'inactive').length;
    const newCount = groups.filter(g => g.status === 'new').length;

    return [
      { id: 'all', label: '전체', icon: 'filter', count: allCount },
      { id: 'active', label: '활성', icon: 'users', count: activeCount },
      { id: 'inactive', label: '비활성', icon: 'clock', count: inactiveCount },
      { id: 'new', label: '신규', icon: 'golf-ball', count: newCount },
    ];
  }, [groups]);

  // 필터링된 그룹 데이터
  const filteredGroups = useMemo(() => {
    let filtered = groups;

    // 상태별 필터링
    if (activeFilter !== 'all') {
      filtered = filtered.filter(group => group.status === activeFilter);
    }

    // 검색어 필터링
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(group => 
        group.name.toLowerCase().includes(query) ||
        group.school.toLowerCase().includes(query)
      );
    }

    return filtered;
  }, [groups, activeFilter, searchQuery]);

  const handleGroupClick = (groupId: string) => {
    // 그룹 채팅 페이지로 이동
    console.log('그룹 채팅으로 이동:', groupId);
  };

  const handleJoinClick = (groupId: string) => {
    // 참가 신청 페이지로 이동
    console.log('참가 신청:', groupId);
  };

  // 빈 상태 처리
  if (groups.length === 0) {
    return (
      <div 
        className="flex-1 overflow-y-auto scroll-container"
        style={{ 
          padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
          backgroundColor: designTokens.colors.background.light
        }}
      >
        <EmptyState
          icon="users"
          title="참여 중인 동문회가 없습니다"
          description="새로운 동문회에 참여하거나 직접 만들어보세요"
          action={{
            label: "동문회 만들기",
            onClick: () => console.log('동문회 만들기')
          }}
        />
      </div>
    );
  }

  // 필터링 결과가 없을 때
  if (filteredGroups.length === 0) {
    return (
      <div 
        className="flex-1 overflow-y-auto scroll-container"
        style={{ 
          padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
          backgroundColor: designTokens.colors.background.light
        }}
      >
        {/* 헤더 */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1, duration: 0.5 }}
          style={{ marginBottom: designTokens.spacing.lg }}
        >
          <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
            {getIconComponent('users', { size: 24, color: designTokens.colors.primary[600] })}
            <h1 style={{
              fontSize: designTokens.typography.fontSize.xl,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0
            }}>
              동문회
            </h1>
          </div>
          <p style={{
            fontSize: designTokens.typography.fontSize.sm,
            color: designTokens.colors.text.secondary,
            margin: 0
          }}>
            참여 중인 동문회와 새로운 동문회를 확인하세요
          </p>
        </motion.div>

        {/* 필터링 시스템 */}
        <GroupFilter
          activeFilter={activeFilter}
          onFilterChange={setActiveFilter}
          filters={filterOptions}
          searchQuery={searchQuery}
          onSearchChange={setSearchQuery}
        />

        {/* 빈 상태 */}
        <EmptyState
          icon="search"
          title="검색 결과가 없습니다"
          description={searchQuery ? `"${searchQuery}"에 대한 검색 결과가 없습니다` : "선택한 조건에 맞는 동문회가 없습니다"}
          action={{
            label: "필터 초기화",
            onClick: () => {
              setActiveFilter('all');
              setSearchQuery('');
            }
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
          {getIconComponent('users', { size: 24, color: designTokens.colors.primary[600] })}
          <h1 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0
          }}>
            동문회
          </h1>
        </div>
        <p style={{
          fontSize: designTokens.typography.fontSize.sm,
          color: designTokens.colors.text.secondary,
          margin: 0
        }}>
          참여 중인 동문회와 새로운 동문회를 확인하세요
        </p>
      </motion.div>

      {/* 필터링 시스템 */}
      <GroupFilter
        activeFilter={activeFilter}
        onFilterChange={setActiveFilter}
        filters={filterOptions}
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      {/* 동문회 목록 - 최적화된 간격 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4, duration: 0.5 }}
        style={{ 
          display: 'flex', 
          flexDirection: 'column', 
          gap: designTokens.spacing.lg,
          marginBottom: designTokens.spacing['2xl']
        }}
      >
        {filteredGroups.map((group) => {
          const groupCardData: GroupCardData = {
            id: group.id,
            name: group.name,
            school: group.school,
            graduationYear: group.graduationYear,
            memberCount: group.memberCount,
            recentActivity: group.recentActivity,
            lastActivityDate: group.lastActivityDate,
            members: group.members,
            status: group.status,
            description: group.description
          };

          return (
            <GroupCard
              key={group.id}
              data={groupCardData}
              onClick={() => handleGroupClick(group.id)}
            />
          );
        })}
      </motion.div>

      {/* 새 동문회 만들기 버튼 - 홈페이지와 일관된 디자인 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.6, duration: 0.5 }}
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
          onClick={() => console.log('새 동문회 만들기')}
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
            {getIconComponent('users', { size: 60, color: designTokens.colors.primary[300] })}
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
                    ${designTokens.colors.primary[500]} 0%, 
                    ${designTokens.colors.primary[600]} 50%,
                    ${designTokens.colors.primary[700]} 100%
                  )
                `,
                margin: '0 auto',
                marginBottom: designTokens.spacing.lg,
                boxShadow: `
                  0 8px 16px ${designTokens.colors.primary[500]}40,
                  0 4px 8px rgba(0, 0, 0, 0.1),
                  inset 0 1px 0 rgba(255, 255, 255, 0.2)
                `,
              }}
            >
              {getIconComponent('users', { size: 32, color: designTokens.colors.neutral[0] })}
            </motion.div>

            {/* 제목 */}
            <h3 style={{
              fontSize: designTokens.typography.fontSize.xl,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0,
              marginBottom: designTokens.spacing.sm,
            }}>
              새 동문회 만들기
            </h3>

            {/* 설명 */}
            <p style={{
              fontSize: designTokens.typography.fontSize.sm,
              color: designTokens.colors.text.secondary,
              margin: 0,
              lineHeight: designTokens.typography.lineHeight.relaxed,
            }}>
              새로운 동문회를 만들어 친구들과 함께 라운딩하세요
            </p>
          </div>
        </motion.div>
      </motion.div>
    </div>
  );
};

export default GroupsPage;