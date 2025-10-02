import React, { useState, useMemo } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useScoreData } from '@/hooks';
import { ScoreCard, EmptyState, ScoreFilter } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import type { ScoreFilterOption } from '@/components/ui/ScoreFilter';
import type { ScoreCardData } from '@/components/ui/ScoreCard';

const ScorePage: React.FC = () => {
  const { setActiveTab } = useAppStore();
  
  // 목업 데이터 초기화
  useMockData();
  
  // 스코어 데이터 가져오기
  const { scoreRecords } = useScoreData();

  // 필터링 상태
  const [activeFilter, setActiveFilter] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  // 필터 옵션 생성
  const filterOptions: ScoreFilterOption[] = useMemo(() => {
    const allCount = scoreRecords.length;
    const excellentCount = scoreRecords.filter(s => s.totalScore <= s.par).length;
    const goodCount = scoreRecords.filter(s => s.totalScore > s.par && s.totalScore <= s.par + 5).length;
    const averageCount = scoreRecords.filter(s => s.totalScore > s.par + 5 && s.totalScore <= s.par + 10).length;
    const poorCount = scoreRecords.filter(s => s.totalScore > s.par + 10).length;

    return [
      { id: 'all', label: '전체', icon: 'filter', count: allCount },
      { id: 'excellent', label: '우수', icon: 'golf-ball', count: excellentCount },
      { id: 'good', label: '양호', icon: 'chart', count: goodCount },
      { id: 'average', label: '보통', icon: 'clock', count: averageCount },
      { id: 'poor', label: '개선', icon: 'users', count: poorCount },
    ];
  }, [scoreRecords]);

  // 필터링된 스코어 데이터
  const filteredScores = useMemo(() => {
    let filtered = scoreRecords;

    // 상태별 필터링
    if (activeFilter !== 'all') {
      filtered = filtered.filter(score => {
        switch (activeFilter) {
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
      });
    }

    // 검색어 필터링
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(score => 
        score.courseName.toLowerCase().includes(query) ||
        score.date.toLowerCase().includes(query)
      );
    }

    return filtered;
  }, [scoreRecords, activeFilter, searchQuery]);

  const handleScoreClick = (scoreId: string) => {
    // 스코어 상세 페이지로 이동
    console.log('스코어 상세:', scoreId);
  };

  // 빈 상태 처리
  if (scoreRecords.length === 0) {
    return (
      <div 
        className="flex-1 overflow-y-auto scroll-container"
        style={{ 
          padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
          backgroundColor: designTokens.colors.background.light
        }}
      >
        <EmptyState
          icon="chart"
          title="기록된 스코어가 없습니다"
          description="새로운 라운딩을 완료하여 스코어를 기록해보세요"
          action={{
            label: "라운딩 참가하기",
            onClick: () => setActiveTab('rounding')
          }}
        />
      </div>
    );
  }

  // 필터링 결과가 없을 때
  if (filteredScores.length === 0) {
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
            {getIconComponent('chart', { size: 24, color: designTokens.colors.primary[600] })}
            <h1 style={{
              fontSize: designTokens.typography.fontSize.xl,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0
            }}>
              스코어
            </h1>
          </div>
          <p style={{
            fontSize: designTokens.typography.fontSize.sm,
            color: designTokens.colors.text.secondary,
            margin: 0
          }}>
            나의 골프 스코어 기록을 확인하세요
          </p>
        </motion.div>

        {/* 필터링 시스템 */}
        <ScoreFilter
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
          description={searchQuery ? `"${searchQuery}"에 대한 검색 결과가 없습니다` : "선택한 조건에 맞는 스코어가 없습니다"}
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
          {getIconComponent('chart', { size: 24, color: designTokens.colors.primary[600] })}
          <h1 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0
          }}>
            스코어
          </h1>
        </div>
        <p style={{
          fontSize: designTokens.typography.fontSize.sm,
          color: designTokens.colors.text.secondary,
          margin: 0
        }}>
          나의 골프 스코어 기록을 확인하세요
        </p>
      </motion.div>

      {/* 필터링 시스템 */}
      <ScoreFilter
        activeFilter={activeFilter}
        onFilterChange={setActiveFilter}
        filters={filterOptions}
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      {/* 스코어 목록 - 최적화된 간격 */}
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
            weather: 'sunny', // 기본값
            temperature: 22, // 기본값
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

      {/* 새 스코어 입력 버튼 - 홈페이지와 일관된 디자인 */}
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
          onClick={() => setActiveTab('rounding')}
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
            {getIconComponent('chart', { size: 60, color: designTokens.colors.primary[300] })}
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
              {getIconComponent('chart', { size: 32, color: designTokens.colors.neutral[0] })}
            </motion.div>

            {/* 제목 */}
            <h3 style={{
              fontSize: designTokens.typography.fontSize.xl,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0,
              marginBottom: designTokens.spacing.sm,
            }}>
              새 스코어 입력
            </h3>

            {/* 설명 */}
            <p style={{
              fontSize: designTokens.typography.fontSize.sm,
              color: designTokens.colors.text.secondary,
              margin: 0,
              lineHeight: designTokens.typography.lineHeight.relaxed,
            }}>
              라운딩을 완료하고 새로운 스코어를 기록해보세요
            </p>
          </div>
        </motion.div>
      </motion.div>
    </div>
  );
};

export default ScorePage;