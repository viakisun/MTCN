import React from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useGroupData, useFilteredData } from '@/hooks';
import { GroupCard, EmptyState, GroupFilter, PageContainer, PageHeader, CreateActionCard } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';
import type { GroupFilterOption } from '@/components/ui/GroupFilter';
import type { GroupCardData } from '@/components/ui/GroupCard';

const GroupsPage: React.FC = () => {
  const { setActiveTab } = useAppStore();

  // 목업 데이터 초기화
  useMockData();

  // 그룹 데이터 가져오기
  const { groups } = useGroupData();

  // 필터링 로직
  const {
    filteredItems: filteredGroups,
    activeFilter,
    setActiveFilter,
    searchQuery,
    setSearchQuery,
    filterOptions,
    hasFilters
  } = useFilteredData({
    items: groups,
    filterFn: (group, filterId) => group.status === filterId,
    searchFields: (group) => [group.name, group.school],
    filterOptions: (items) => [
      { id: 'all', label: '전체', icon: 'filter', count: items.length },
      { id: 'active', label: '활성', icon: 'users', count: items.filter(g => g.status === 'active').length },
      { id: 'inactive', label: '비활성', icon: 'clock', count: items.filter(g => g.status === 'inactive').length },
      { id: 'new', label: '신규', icon: 'golf-ball', count: items.filter(g => g.status === 'new').length },
    ]
  });

  const handleGroupClick = (groupId: string) => {
    console.log('그룹 채팅으로 이동:', groupId);
  };

  // 빈 상태 처리
  if (groups.length === 0) {
    return (
      <PageContainer>
        <EmptyState
          icon="users"
          title="참여 중인 동문회가 없습니다"
          description="새로운 동문회에 참여하거나 직접 만들어보세요"
          action={{
            label: "동문회 만들기",
            onClick: () => console.log('동문회 만들기')
          }}
        />
      </PageContainer>
    );
  }

  // 필터링 결과가 없을 때
  if (filteredGroups.length === 0) {
    return (
      <PageContainer>
        <PageHeader
          icon="users"
          title="동문회"
          description="참여 중인 동문회와 새로운 동문회를 확인하세요"
        />

        <GroupFilter
          activeFilter={activeFilter}
          onFilterChange={setActiveFilter}
          filters={filterOptions as GroupFilterOption[]}
          searchQuery={searchQuery}
          onSearchChange={setSearchQuery}
        />

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
      </PageContainer>
    );
  }

  return (
    <PageContainer>
      <PageHeader
        icon="users"
        title="동문회"
        description="참여 중인 동문회와 새로운 동문회를 확인하세요"
      />

      <GroupFilter
        activeFilter={activeFilter}
        onFilterChange={setActiveFilter}
        filters={filterOptions as GroupFilterOption[]}
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      {/* 동문회 목록 */}
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

      <CreateActionCard
        icon="users"
        title="새 동문회 만들기"
        description="새로운 동문회를 만들어 친구들과 함께 라운딩하세요"
        onClick={() => console.log('새 동문회 만들기')}
      />
    </PageContainer>
  );
};

export default GroupsPage;
