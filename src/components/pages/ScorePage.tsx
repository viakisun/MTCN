import React from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useScoreData, useFilteredData } from '@/hooks';
import { ScoreCard, EmptyState, ScoreFilter, PageContainer, PageHeader, CreateActionCard } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';
import type { ScoreFilterOption } from '@/components/ui/ScoreFilter';
import type { ScoreCardData } from '@/components/ui/ScoreCard';

const ScorePage: React.FC = () => {
  const { setActiveTab } = useAppStore();

  // 목업 데이터 초기화
  useMockData();

  // 스코어 데이터 가져오기
  const { scoreRecords } = useScoreData();

  // 필터링 로직
  const {
    filteredItems: filteredScores,
    activeFilter,
    setActiveFilter,
    searchQuery,
    setSearchQuery,
    filterOptions,
    hasFilters
  } = useFilteredData({
    items: scoreRecords,
    filterFn: (score, filterId) => {
      switch (filterId) {
        case 'excellent':
          return score.totalScore <= score.par;
        case 'good':
          return score.totalScore > score.par && score.totalScore <= score.par + 5;
        case 'average':
          return score.totalScore > score.par + 5 && score.totalScore <= score.par + 10;
        case 'poor':
          return score.totalScore > score.par + 10;
        default:
          return true;
      }
    },
    searchFields: (score) => [score.courseName, score.date],
    filterOptions: (items) => [
      { id: 'all', label: '전체', icon: 'filter', count: items.length },
      { id: 'excellent', label: '우수', icon: 'golf-ball', count: items.filter(s => s.totalScore <= s.par).length },
      { id: 'good', label: '양호', icon: 'chart', count: items.filter(s => s.totalScore > s.par && s.totalScore <= s.par + 5).length },
      { id: 'average', label: '보통', icon: 'clock', count: items.filter(s => s.totalScore > s.par + 5 && s.totalScore <= s.par + 10).length },
      { id: 'poor', label: '개선', icon: 'users', count: items.filter(s => s.totalScore > s.par + 10).length },
    ]
  });

  const handleScoreClick = (scoreId: string) => {
    console.log('스코어 상세:', scoreId);
  };

  // 빈 상태 처리
  if (scoreRecords.length === 0) {
    return (
      <PageContainer>
        <EmptyState
          icon="chart"
          title="기록된 스코어가 없습니다"
          description="새로운 라운딩을 완료하여 스코어를 기록해보세요"
          action={{
            label: "라운딩 참가하기",
            onClick: () => setActiveTab('rounding')
          }}
        />
      </PageContainer>
    );
  }

  // 필터링 결과가 없을 때
  if (filteredScores.length === 0) {
    return (
      <PageContainer>
        <PageHeader
          icon="chart"
          title="스코어"
          description="나의 골프 스코어 기록을 확인하세요"
        />

        <ScoreFilter
          activeFilter={activeFilter}
          onFilterChange={setActiveFilter}
          filters={filterOptions as ScoreFilterOption[]}
          searchQuery={searchQuery}
          onSearchChange={setSearchQuery}
        />

        <EmptyState
          icon="search"
          title="검색 결과가 없습니다"
          description={searchQuery ? `"${searchQuery}"에 대한 검색 결과가 없습니다` : "선택한 조건에 맞는 스코어가 없습니다"}
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
        icon="chart"
        title="스코어"
        description="나의 골프 스코어 기록을 확인하세요"
      />

      <ScoreFilter
        activeFilter={activeFilter}
        onFilterChange={setActiveFilter}
        filters={filterOptions as ScoreFilterOption[]}
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      {/* 스코어 목록 */}
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
        {filteredScores.map((score) => {
          const scoreCardData: ScoreCardData = {
            id: score.id,
            courseName: score.courseName,
            date: score.date,
            totalScore: score.totalScore,
            par: score.par,
            birdies: score.birdies,
            eagles: score.eagles,
            pars: score.pars,
            bogeys: score.bogeys,
            doubleBogeys: score.doubleBogeys,
            holes: score.holes || [],
            weather: 'sunny',
            temperature: 22,
            status: score.totalScore <= score.par ? 'excellent' :
                   score.totalScore <= score.par + 5 ? 'good' :
                   score.totalScore <= score.par + 10 ? 'average' : 'poor',
            description: score.totalScore <= score.par ? '파 이하로 완주했습니다!' :
                        score.totalScore <= score.par + 5 ? '좋은 스코어입니다!' :
                        score.totalScore <= score.par + 10 ? '보통 스코어입니다.' : '더 연습이 필요합니다.'
          };

          return (
            <ScoreCard
              key={score.id}
              data={scoreCardData}
              onClick={() => handleScoreClick(score.id)}
            />
          );
        })}
      </motion.div>

      <CreateActionCard
        icon="chart"
        title="새 스코어 입력"
        description="라운딩을 완료하고 새로운 스코어를 기록해보세요"
        onClick={() => setActiveTab('rounding')}
      />
    </PageContainer>
  );
};

export default ScorePage;
