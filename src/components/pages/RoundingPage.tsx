import React, { useState, useMemo } from 'react';
import { motion } from 'framer-motion';
import { useAppStore } from '@/lib/store';
import { useMockData, useRoundingData } from '@/hooks';
import { RoundingCard, EmptyState, RoundingFilter } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import { dateUtils } from '@/utils';
import type { FilterOption } from '@/components/ui/RoundingFilter';
import RoundingDetailPage from './RoundingDetailPage';

const RoundingPage: React.FC = () => {
  const { setActiveTab } = useAppStore();
  
  // 목업 데이터 초기화
  useMockData();
  
  // 라운딩 데이터 가져오기
  const { roundings } = useRoundingData();

  // 필터링 상태
  const [activeFilter, setActiveFilter] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  
  // 상세 페이지 상태
  const [showDetail, setShowDetail] = useState(false);
  const [selectedRoundingId, setSelectedRoundingId] = useState<string | null>(null);

  // 필터 옵션 생성
  const filterOptions: FilterOption[] = useMemo(() => {
    const allCount = roundings.length;
    const upcomingCount = roundings.filter(r => r.status === 'upcoming').length;
    const inProgressCount = roundings.filter(r => r.status === 'in-progress').length;
    const completedCount = roundings.filter(r => r.status === 'completed').length;

    return [
      { id: 'all', label: '전체', icon: 'filter', count: allCount },
      { id: 'upcoming', label: '예정', icon: 'calendar', count: upcomingCount },
      { id: 'in-progress', label: '진행중', icon: 'clock', count: inProgressCount },
      { id: 'completed', label: '완료', icon: 'location', count: completedCount },
    ];
  }, [roundings]);

  // 필터링된 라운딩 데이터
  const filteredRoundings = useMemo(() => {
    let filtered = roundings;

    // 상태별 필터링
    if (activeFilter !== 'all') {
      filtered = filtered.filter(rounding => rounding.status === activeFilter);
    }

    // 검색어 필터링
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(rounding => 
        rounding.courseName.toLowerCase().includes(query) ||
        rounding.eventName.toLowerCase().includes(query)
      );
    }

    return filtered;
  }, [roundings, activeFilter, searchQuery]);

  const handleRoundingClick = (roundingId: string) => {
    // 라운딩 상세 페이지로 이동
    setSelectedRoundingId(roundingId);
    setShowDetail(true);
  };

  // 상세 페이지 표시
  if (showDetail && selectedRoundingId) {
    return (
      <RoundingDetailPage 
        roundingId={selectedRoundingId}
        onBack={() => {
          setShowDetail(false);
          setSelectedRoundingId(null);
        }}
      />
    );
  }

  // 빈 상태 처리
  if (roundings.length === 0) {
    return (
      <div 
        className="flex-1 overflow-y-auto scroll-container"
        style={{ 
          padding: `${designTokens.spacing.lg} ${designTokens.spacing.lg} ${designTokens.spacing.lg}`,
          backgroundColor: designTokens.colors.background.light
        }}
      >
        <EmptyState
          icon="calendar"
          title="등록된 라운딩이 없습니다"
          description="새로운 라운딩을 등록해보세요"
          action={{
            label: "라운딩 등록하기",
            onClick: () => setActiveTab('rounding')
          }}
        />
      </div>
    );
  }

  // 필터링 결과가 없을 때
  if (filteredRoundings.length === 0) {
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
            {getIconComponent('calendar', { size: 24, color: designTokens.colors.primary[600] })}
            <h1 style={{
              fontSize: designTokens.typography.fontSize.xl,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0
            }}>
              내 일정
            </h1>
          </div>
          <p style={{
            fontSize: designTokens.typography.fontSize.sm,
            color: designTokens.colors.text.secondary,
            margin: 0
          }}>
            예정된 라운딩과 진행 중인 경기를 확인하세요
          </p>
        </motion.div>

        {/* 필터링 시스템 */}
        <RoundingFilter
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
          description={searchQuery ? `"${searchQuery}"에 대한 검색 결과가 없습니다` : "선택한 조건에 맞는 라운딩이 없습니다"}
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
      {/* 헤더 - 홈페이지와 일관된 디자인 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.5 }}
        style={{ marginBottom: designTokens.spacing.lg }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm, marginBottom: designTokens.spacing.sm }}>
          {getIconComponent('calendar', { size: 24, color: designTokens.colors.primary[600] })}
          <h1 style={{
            fontSize: designTokens.typography.fontSize.xl,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            margin: 0
          }}>
            내 일정
          </h1>
        </div>
        <p style={{
          fontSize: designTokens.typography.fontSize.sm,
          fontWeight: designTokens.typography.fontWeight.medium,
          color: designTokens.colors.text.secondary,
          margin: 0
        }}>
          예정된 라운딩과 진행 중인 경기를 확인하세요
        </p>
      </motion.div>

      {/* 필터링 시스템 */}
      <RoundingFilter
        activeFilter={activeFilter}
        onFilterChange={setActiveFilter}
        filters={filterOptions}
        searchQuery={searchQuery}
        onSearchChange={setSearchQuery}
      />

      {/* 라운딩 목록 - 최적화된 간격 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4, duration: 0.5 }}
        style={{ 
          display: 'flex', 
          flexDirection: 'column', 
          gap: designTokens.spacing.lg, // md → lg (더 넓은 간격)
          marginBottom: designTokens.spacing['2xl'] // 하단 여백 추가
        }}
      >
        {filteredRoundings.map((rounding) => {
          const dDay = dateUtils.calculateDDay(rounding.date);
          return (
            <RoundingCard
              key={rounding.id}
              data={{
                id: rounding.id,
                courseName: rounding.courseName,
                eventName: rounding.eventName,
                date: rounding.date,
                time: rounding.time,
                status: rounding.status,
                players: rounding.players,
                weather: rounding.weather as 'sunny' | 'cloudy' | 'rainy' | 'windy',
                temperature: rounding.temperature,
                greenFee: rounding.greenFee,
                holes: rounding.holes,
                dDay: dDay,
                notice: rounding.notice
              }}
              onClick={() => handleRoundingClick(rounding.id)}
            />
          );
        })}
      </motion.div>

      {/* 새 라운딩 등록 버튼 - 홈페이지와 일관된 디자인 */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.6, duration: 0.5 }}
        style={{ marginTop: designTokens.spacing['3xl'] }} // 2xl → 3xl (더 넓은 간격)
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
            border: `2px dashed ${designTokens.colors.primary[300]}`,
            padding: designTokens.golf.card.padding.md,
            textAlign: 'center',
            cursor: 'pointer',
            position: 'relative',
            overflow: 'hidden',
            boxShadow: `
              0 4px 16px rgba(0, 0, 0, 0.08),
              0 2px 4px rgba(0, 0, 0, 0.04)
            `,
          }}
          whileHover={{ 
            scale: 1.02,
            borderColor: designTokens.colors.primary[500],
            transition: { duration: 0.2 }
          }}
          whileTap={{ scale: 0.98 }}
          onClick={() => setActiveTab('groups')}
        >
          <div style={{
            width: '48px',
            height: '48px',
            margin: '0 auto',
            marginBottom: designTokens.spacing.md,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            background: `linear-gradient(135deg, ${designTokens.colors.primary[500]} 0%, ${designTokens.colors.primary[600]} 100%)`,
            borderRadius: '12px',
            color: 'white',
            fontSize: '24px',
            fontWeight: 'bold'
          }}>
            +
          </div>
          <h3 style={{
            fontSize: designTokens.typography.fontSize.lg,
            fontWeight: designTokens.typography.fontWeight.semibold,
            color: designTokens.colors.text.primary,
            marginBottom: designTokens.spacing.sm,
            margin: 0
          }}>
            새 라운딩 등록하기
          </h3>
          <p style={{
            fontSize: designTokens.typography.fontSize.sm,
            fontWeight: designTokens.typography.fontWeight.medium,
            color: designTokens.colors.text.secondary,
            margin: 0
          }}>
            동문회에서 새로운 라운딩을 등록하거나 참가하세요
          </p>
        </motion.div>
      </motion.div>
    </div>
  );
};

export default RoundingPage;